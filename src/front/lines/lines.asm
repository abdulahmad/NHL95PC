; The league line editor from Edit Rosters. Scratch, dress, and the roster printout.
bits 32
%include "hockey.inc"
section s_737AA progbits alloc exec nowrite align=1
extern __CHK, AllocMemBlock, byte_D11BC, byte_D12DE, CareerDbPtr, CareerDbPtr2, cddriveptr, ClearInputQueue
extern ClearScreen, dlgbevelcol1, dlgbevelcol2, dlgedgecol1, dlgedgecol2, dlgedgecol3, dlgfillcol, DrawArtMasked
extern DrawBitmap, DrawLineEditorScreen, DrawMenuBar, DrawMenuDropdown, DrawMenuItemNorm, DrawMenuItemSel, DrawShape, dword_D1398
extern dword_D139C, dword_D13C8, dword_D13CC, dword_D1418, dword_D141C, dword_D1458, dword_D145C, dword_D1468
extern dword_D146C, editptrspr, FadeOutPalCycle, FadePalStep, fileoncd, FindShape, FitPlayerName, FreeMemBlock
extern fullscrbmp, GetInputEvent, GrabBlock, jerseyremap, KeyDbPtr, LineEdHitTest, lineedpanel, lineslotx
extern linesloty, LoadBank, LoadJerseyColours, mainfont, MakeJerseyShape, MakePath, memcpy_, menuact_dbdress
extern menuact_dbscratch, MenuHitTest, MessageBox, MouseRead, MouseSetPos, msglines, musichandle, musicon
extern pointerspr, PrintCenteredText, PrintFmt1, PrintFmt2, PrintLineEdStatus, PrintShadowText, ptrupdatefn, PutBlock
extern qsort_, rostergstat, rosterjersey, rosterlist, rosterpstat, rosterslot, rosterstat, rosterstatsmenubar
extern rosterteam, rosterteamrec, RunMenu, SetClipWindow, SetColorRemap, SetDrawBitmap, SetPalette, SetTextColors
extern SetViewRect, ShowLoadingScreen, songdata, sprintf_, statsgoalieorder, statsgoalieplr, statsplayerbuf, statsplayoffs
extern statsskaterorder, statsskaterplr, str_A4, str_Bkgd2, str_C2dS2, str_C5, str_dot2, str_Embpal4
extern str_fmt2d, str_fmt3d, str_fmt4d, str_fmtEmb, str_fmtMinSec, str_fmtTenths, str_G4, str_GA3
extern str_GAA4, str_GP8, str_Gstat3, str_Keys3, str_L8, str_Lelogo, str_Lineditp2, str_Menubuff8
extern str_Min4, str_Name2, str_No2, str_Pal25, str_Pal26, str_PCT2, str_PIM4, str_PlusMinus7
extern str_Pntr3, str_Pointer13, str_Pos2, str_Pstat3, str_PT2, str_S2dSS, str_S6, str_SA3
extern str_Shots4, str_Shrt2, str_SRoster, str_T6, str_W6, sub_8FCDF, sub_9121C, sub_91FE0
extern SetScreenTarget, TextRestoreState, TextSaveState, TextSetColors, TextSetFont
global str_RosterIncomplete, str_Scratch, str_Dress, str_Player, str_GoalieW, DbLineEditor, FindRosterSlot, DbLineEditorLoop
global DrawLineJerseys, CheckRosterComplete, LineEdDone, MenuShowPlayerStats, MenuShowPlayerStats_status, MenuShowPlayerStats_ret, ScratchPlayer, DressPlayer
global CmpRosterSkaters, CmpRosterGoalies, MenuRegSeasonStats, MenuRegSeasonStats_common, MenuPlayoffStats, ShowRosterStats
str_RosterIncomplete:
        db 059h,06Fh,075h,072h,020h,052h,06Fh,073h,074h,065h,072h,020h,069h,073h,020h,069h
        db 06Eh,063h,06Fh,06Dh,070h,06Ch,065h,074h,065h,02Eh,00h
str_Scratch:
        db 053h,063h,072h,061h,074h,063h,068h,00h
str_Dress:
        db 044h,072h,065h,073h,073h,00h
str_Player:
        db 050h,06Ch,061h,079h,065h,072h,00h
str_GoalieW:
        db 047h,06Fh,061h,06Ch,069h,065h,00h
;-----------------------------------------------------------------------------
; DbLineEditor                                                    737E1  95 PC
; Edit Rosters line editor (create_player): fade out, loading screen, dialog
; colours, lineditp graphics / shrt font, runs DbLineEditorLoop, restores
;-----------------------------------------------------------------------------
; C: src/front/lines/DbLineEditor.c
%ifdef CBUILD
%include "c/front/lines/DbLineEditor.inc"
%else
DbLineEditor:
        push dword 50h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 30h
        mov byte [byte esp+02Ch], al
        mov dword [byte esp+020h], edx
        mov dword [byte esp+028h], ebx
        mov dword [byte esp+024h], ecx
        push byte 20h
        push dword 300h
        push str_Pal25
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
        cmp byte [musicon], 0
        je short .1
        cmp dword [songdata], byte 0
        je short .1
        mov eax, dword [musichandle]
        mov ebx, 32h
        mov edx, 3
        call sub_8FCDF
.1:
        call ShowLoadingScreen
        mov ebx, dword [fullscrbmp]
        push ebx
        call SetDrawBitmap
        add esp, byte 4
        mov al, byte [byte esp+02Ch]
        mov byte [lineedpanel], al
        mov ecx, 0C1h
        mov dword [dlgfillcol], ecx
        mov dword [dlgedgecol1], 0C0h
        mov dword [dlgedgecol2], ecx
        mov ebp, 0C2h
        mov dword [dlgedgecol3], ebp
        mov dword [dlgbevelcol1], 0C3h
        mov dword [dlgbevelcol2], ebp
        push dword 0F0h
        push dword 140h
        call MouseSetPos
        add esp, byte 8
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        xor ecx, ecx
        mov ebx, str_Lineditp2
        cmp byte [fileoncd+0E8h], 1
        jne short .2
        mov edx, dword [cddriveptr]
        jmp short .3
.2:
        xor edx, edx
.3:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        mov edi, eax
        add esp, byte 8
        push str_Shrt2
        push eax
        call FindShape
        mov esi, eax
        add esp, byte 8
        mov ebx, dword [byte esp+024h]
        push ebx
        movzx ebp, byte [byte esp+030h]
        mov ecx, dword [byte esp+02Ch]
        xor ebx, ebx
        mov edx, eax
        mov eax, ebp
        call DrawLineEditorScreen
        call FadeOutPalCycle
        call SetScreenTarget
        mov edx, dword [fullscrbmp]
        mov ecx, dword [byte edx+02Ch]
        push ecx
        call DrawBitmap
        add esp, byte 4
        push edi
        mov eax, dword [byte esp+028h]
        push eax
        mov edx, dword [byte esp+030h]
        push edx
        xor ecx, ecx
        mov ebx, ebp
        mov edx, esi
        mov eax, dword [byte esp+02Ch]
        call DbLineEditorLoop
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebx, 41h
        mov dword [dlgfillcol], ebx
        mov ecx, 40h
        mov dword [dlgedgecol1], ecx
        mov esi, 42h
        mov dword [dlgedgecol2], esi
        mov dword [dlgedgecol3], ebx
        mov dword [dlgbevelcol1], ecx
        mov dword [dlgbevelcol2], esi
        add esp, byte 30h
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FindRosterSlot                                                  739B6  95 PC
; (slot, panel): index of the rosterlist entry whose roster slot (+2) matches
;-----------------------------------------------------------------------------
; C: src/front/lines/FindRosterSlot.c
%ifdef CBUILD
%include "c/front/lines/FindRosterSlot.inc"
%else
FindRosterSlot:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        sub esp, byte 8
        mov byte [byte esp+04h], al
        mov dh, dl
        xor dl, dl
        jmp short .3
.1:
        xor ebx, ebx
        mov bl, dh
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        mov ebx, eax
        mov ecx, eax
        shl ecx, 6
        sub ecx, eax
        xor ebx, eax
        mov bl, dl
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        mov al, byte [dword ecx+eax+rosterslot]
        cmp al, byte [byte esp+04h]
        jne short .2
        mov byte [esp], dl
        mov dl, 1Ch
.2:
        inc dl
.3:
        cmp dl, 1Ch
        jb short FindRosterSlot.1
        mov al, byte [esp]
        add esp, byte 8
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DbLineEditorLoop                             73A18  95 PC, medium confidence
; Line editor screen and input loop (lelogo, menus via MenuHitTest /
; DrawMenuItemSel, drag players into the 40 line slots)
;-----------------------------------------------------------------------------
DbLineEditorLoop:
        push dword 158h
        call __CHK
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 128h
        push eax
        push edx
        sub ebp, byte 7Ah
        mov byte [byte ebp+072h], bl
        xor edx, edx
        mov dword [byte ebp+06Ah], edx
        mov ebx, 0FFFFFFFFh
        mov dword [byte ebp+026h], ebx
        mov dword [byte ebp+02Eh], ebx
        mov dword [byte ebp+056h], 0C0h
        mov dword [byte ebp+052h], 0C1h
        mov dword [byte ebp+05Ah], 0C2h
        push str_Pntr3
        mov edx, dword [dword ebp+092h]
        push edx
        call FindShape
        mov dword [byte ebp+046h], eax
        add esp, byte 8
        mov eax, dword [dword ebp+08Ah]
        mov dword [byte ebp-0Eh], eax
        mov eax, dword [dword ebp+08Eh]
        mov dword [byte ebp+012h], eax
        xor ebx, ebx
        mov dword [byte ebp-02h], ebx
        mov dword [byte ebp-06h], ebx
        mov dword [byte ebp-0Ah], ebx
        mov dword [byte ebp+0Eh], ebx
        mov dword [byte ebp+0Ah], ebx
        mov dword [byte ebp+06h], ebx
        mov dword [byte ebp+02h], ebx
        mov dword [byte ebp-012h], ebx
        mov dword [byte ebp-016h], ebx
        mov dword [byte ebp-01Ah], ebx
        mov dword [byte ebp-01Eh], ebx
        mov dword [byte ebp-07Ah], ebx
        mov dword [byte ebp-07Eh], ebx
        mov dword [menuact_dbdress], ebx
        mov dword [menuact_dbscratch], ebx
        mov edx, dword [byte ebp+046h]
        mov edx, dword [byte edx+02h]
        sar edx, 10h
        mov eax, dword [byte ebp+046h]
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        lea ebx, [byte eax+01h]
        lea eax, [byte edx+01h]
        imul eax, ebx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_Pointer13
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte ebp+066h], eax
        mov edi, eax
        mov esi, dword [byte ebp+046h]
        movsd
        movsd
        movsd
        movsd
        movsb
        mov edx, dword [byte ebp+046h]
        mov dx, word [byte edx+04h]
        inc edx
        mov word [byte eax+04h], dx
        mov edx, dword [byte ebp+046h]
        mov dx, word [byte edx+06h]
        inc edx
        mov word [byte eax+06h], dx
        mov edx, dword [byte ebp-0Eh]
        mov edx, dword [edx]
        mov eax, dword [byte ebp-0Eh]
        mov edi, dword [byte eax+08h]
        add edx, edi
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov esi, eax
        mov dword [byte ebp+03Eh], eax
        mov edx, dword [byte ebp-0Eh]
        mov edx, dword [byte edx+04h]
        mov eax, dword [byte ebp-0Eh]
        mov ebx, dword [byte eax+0Ch]
        add edx, ebx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edi, eax
        mov dword [byte ebp+03Ah], eax
        xor ecx, ecx
        mov dword [byte ebp+042h], ecx
.1:
        mov eax, dword [dword ebp-0B2h]
        add eax, dword [byte ebp+042h]
        mov dl, byte [eax]
        cmp dl, 64h
        je short .2
        xor ebx, ebx
        mov bl, byte [byte ebp+072h]
        mov al, dl
        and eax, 0FFh
        mov edx, ebx
        call FindRosterSlot
        mov cl, al
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        mov edx, eax
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        xor edx, eax
        mov dl, cl
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov dl, byte [dword ebx+eax+rosterjersey]
.2:
        mov eax, dword [byte ebp+042h]
        mov byte [dword eax+ebp-0AEh], dl
        mov ebx, dword [byte ebp+042h]
        inc ebx
        mov dword [byte ebp+042h], ebx
        cmp ebx, byte 28h
        jl short DbLineEditorLoop.1
        xor eax, eax
        mov dword [byte ebp+042h], eax
.3:
        xor ebx, ebx
        mov bl, byte [byte ebp+072h]
        mov eax, dword [dword ebp-0B2h]
        add eax, dword [byte ebp+042h]
        mov al, byte [byte eax+028h]
        and eax, 0FFh
        mov edx, ebx
        call FindRosterSlot
        mov cl, al
        mov eax, dword [dword ebp-0B2h]
        add eax, dword [byte ebp+042h]
        cmp byte [byte eax+028h], 64h
        je short .4
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        mov edx, eax
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        xor edx, eax
        mov dl, cl
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, ebx
        cmp byte [dword eax+rosterstat], 3
        jne short .4
        mov byte [dword eax+rosterstat], 2
.4:
        mov ebx, dword [byte ebp+042h]
        inc ebx
        mov dword [byte ebp+042h], ebx
        cmp ebx, byte 8
        jl short DbLineEditorLoop.3
        push byte 20h
        push dword 300h
        push str_Pal25
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte ebp+04Ah], eax
        xor ecx, ecx
        mov ebx, str_Embpal4
        cmp byte [fileoncd+08Eh], 1
        jne short .5
        mov edx, dword [cddriveptr]
        jmp short .6
.5:
        xor edx, edx
.6:
        lea eax, [byte ebp-05Eh]
        call MakePath
        push byte 0
        lea eax, [byte ebp-05Eh]
        push eax
        call LoadBank
        mov dword [byte ebp+046h], eax
        add esp, byte 8
        push str_Pal26
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, dword [byte ebp+04Ah]
        call memcpy_
        mov edx, dword [byte ebp+046h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov cl, byte [byte ebp+072h]
        mov ebx, dword [byte ebp+04Ah]
        mov edx, dword [dword ebp+092h]
        mov eax, ecx
        call LoadJerseyColours
        xor eax, eax
        mov al, byte [dword ecx+rosterteam]
        mov al, byte [nosplit eax*4+byte_D11BC]
        mov byte [byte ebp+06Eh], al
        xor eax, eax
        mov al, byte [byte ebp+06Eh]
        mov al, byte [dword eax+jerseyremap]
        mov byte [byte ebp+06Eh], al
        mov al, byte [byte_D12DE]
        mov byte [byte ebp+076h], al
        mov ebx, ecx
        mov edx, dword [dword ebp-0B6h]
        lea eax, [dword ebp-0AEh]
        call DrawLineJerseys
        xor ecx, ecx
        mov ebx, str_Lelogo
        cmp byte [fileoncd+021Bh], 1
        jne short .7
        mov edx, dword [cddriveptr]
        jmp short .8
.7:
        xor edx, edx
.8:
        lea eax, [byte ebp-05Eh]
        call MakePath
        push byte 0
        lea eax, [byte ebp-05Eh]
        push eax
        call LoadBank
        mov dword [byte ebp+046h], eax
        add esp, byte 8
        push str_Pal26
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [dword eax+026Eh]
        mov eax, dword [byte ebp+04Ah]
        add eax, 25Eh
        mov ebx, 93h
        call memcpy_
        mov ecx, dword [byte ebp+046h]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov ebx, 10h
        mov edx, dword [byte ebp+04Ah]
        xor eax, eax
        call FadePalStep
        cmp edi, byte 20h
        jge short .9
        xor eax, eax
        jmp short .10
.9:
        lea eax, [byte edi-020h]
.10:
        push eax
        cmp esi, byte 1Ch
        jge short .11
        xor eax, eax
        jmp short .12
.11:
        lea eax, [byte esi-01Ch]
.12:
        push eax
        mov eax, dword [editptrspr]
        push eax
        call GrabBlock
        add esp, byte 0Ch
        cmp edi, byte 20h
        jge short .13
        xor eax, eax
        jmp short .14
.13:
        lea eax, [byte edi-020h]
.14:
        push eax
        cmp esi, byte 1Ch
        jge short .15
        xor eax, eax
        jmp short .16
.15:
        lea eax, [byte esi-01Ch]
.16:
        push eax
        mov edx, dword [byte ebp+066h]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        push edi
        lea eax, [byte esi-03h]
        push eax
        mov ebx, dword [pointerspr]
        push ebx
        call sub_91FE0
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
        lea eax, [byte ebp+042h]
        push eax
        push eax
        push eax
        call MouseRead
        add esp, byte 0Ch
        call ClearInputQueue
        jmp near .28
.17:
        sub edi, byte 20h
.18:
        push edi
        cmp esi, byte 1Ch
        jge short .19
        xor esi, esi
        jmp short .20
.19:
        sub esi, byte 1Ch
.20:
        push esi
        mov ebx, dword [byte ebp+066h]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        mov ecx, dword [byte ebp+03Ah]
        cmp ecx, byte 20h
        jge short .21
        xor eax, eax
        jmp short .22
.21:
        lea eax, [byte ecx-020h]
.22:
        push eax
        mov esi, dword [byte ebp+03Eh]
        cmp esi, byte 1Ch
        jge short .23
        xor eax, eax
        jmp short .24
.23:
        lea eax, [byte esi-01Ch]
.24:
        push eax
        mov edi, dword [byte ebp+066h]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+03Ah]
        mov edx, dword [byte ebp-0Eh]
        cmp eax, dword [byte edx+0Ch]
        jle near .26
        cmp dword [byte ebp+03Eh], 1F4h
        jge near .26
        cmp dword [byte ebp+026h], byte 0FFFFFFFFh
        je near .26
        cmp dword [byte ebp-0Ah], byte 0
        je short .25
        lea eax, [byte ebp+032h]
        push eax
        lea eax, [byte ebp+036h]
        push eax
        lea eax, [byte ebp-07Eh]
        push eax
        lea eax, [byte ebp+012h]
        push eax
        mov ecx, dword [byte ebp+06Ah]
        lea ebx, [byte ebp-0Eh]
        mov edx, dword [byte ebp+03Ah]
        mov eax, dword [byte ebp+03Eh]
        call MenuHitTest
        test eax, eax
        jne short .26
.25:
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, ebx
        cmp byte [dword eax+rosterstat], 2
        je short .26
        xor ecx, ecx
        mov cl, byte [byte ebp+076h]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        xor edx, edx
        mov dl, byte [dword eax+rosterjersey]
        mov eax, jerseyremap
        call MakeJerseyShape
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov eax, dword [byte ebp+03Ah]
        sub eax, byte 20h
        push eax
        mov eax, dword [byte ebp+03Eh]
        sub eax, byte 1Ch
        push eax
        mov eax, dword [dword ebp-0B6h]
        push eax
        call sub_91FE0
        add esp, byte 0Ch
.26:
        mov edx, dword [byte ebp+03Ah]
        push edx
        mov eax, dword [byte ebp+03Eh]
        sub eax, byte 3
        push eax
        mov ebx, dword [pointerspr]
        push ebx
.27:
        call sub_91FE0
        add esp, byte 0Ch
        mov esi, dword [byte ebp+03Eh]
        mov edi, dword [byte ebp+03Ah]
.28:
        xor ecx, ecx
.29:
        call GetInputEvent
        test eax, eax
        je short .30
        lea ebx, [byte ebp+03Ah]
        lea edx, [byte ebp+03Eh]
        call dword [ptrupdatefn]
        mov ecx, eax
        test al, 2
        je short DbLineEditorLoop.29
.30:
        test cl, 2
        jne short .32
        cmp esi, dword [byte ebp+03Eh]
        jne short .31
        cmp edi, dword [byte ebp+03Ah]
        je short DbLineEditorLoop.28
.31:
        cmp edi, byte 20h
        jge near DbLineEditorLoop.17
        xor edi, edi
        jmp near DbLineEditorLoop.18
.32:
        lea eax, [byte ebp+032h]
        push eax
        lea eax, [byte ebp+036h]
        push eax
        lea eax, [byte ebp-07Eh]
        push eax
        lea eax, [byte ebp+012h]
        push eax
        mov ecx, dword [byte ebp+06Ah]
        lea ebx, [byte ebp-0Eh]
        mov edx, dword [byte ebp+03Ah]
        mov eax, dword [byte ebp+03Eh]
        call MenuHitTest
        lea edx, [byte edi-020h]
        test eax, eax
        je near .61
        mov ebx, dword [byte ebp+036h]
        shl ebx, 2
        mov eax, dword [byte ebp+032h]
        shl eax, 5
        mov dword [byte ebp+04Eh], eax
        mov eax, dword [byte ebx+ebp-0Eh]
        add eax, dword [byte ebp+04Eh]
        cmp dword [byte eax+014h], byte 0
        je near .45
        mov eax, dword [byte ebp+032h]
        cmp eax, dword [byte ebx+ebp-01Eh]
        jne near .39
        cmp edi, byte 20h
        jge short .33
        xor edx, edx
.33:
        push edx
        cmp esi, byte 1Ch
        jge short .34
        xor esi, esi
        jmp short .35
.34:
        sub esi, byte 1Ch
.35:
        push esi
        mov esi, dword [byte ebp+066h]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov dword [byte ebp+042h], 3
        jmp short .38
.36:
        mov edx, ebx
        shl edx, 2
        mov esi, dword [byte edx+ebp+02h]
        test esi, esi
        je short .37
        mov edi, dword [byte ebp+ebx*8-07Ah]
        push edi
        mov ebx, dword [byte ebp+ebx*8-07Eh]
        push ebx
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+042h]
        xor esi, esi
        mov dword [byte ebp+eax*8-07Ah], esi
        mov dword [byte ebp+eax*8-07Eh], esi
        mov edi, dword [byte ebp+eax*4+02h]
        push edi
        call FreeMemBlock
        add esp, byte 4
.37:
        dec dword [byte ebp+042h]
.38:
        mov ebx, dword [byte ebp+042h]
        test ebx, ebx
        jge short DbLineEditorLoop.36
        xor ecx, ecx
        mov dword [byte ebp+06Ah], ecx
        mov eax, dword [byte ebp+036h]
        mov esi, dword [byte ebp+032h]
        shl esi, 5
        mov eax, dword [byte ebp+eax*4-0Eh]
        add esi, eax
        lea eax, [byte ebp+03Ah]
        push eax
        lea eax, [byte ebp+03Eh]
        push eax
        mov edi, dword [dword ebp+08Eh]
        push edi
        mov eax, dword [dword ebp+08Ah]
        push eax
        push ecx
        mov edx, dword [dword ebp-0B6h]
        push edx
        xor ebx, ebx
        mov bl, byte [byte ebp+072h]
        lea ecx, [byte ebp+026h]
        mov edx, dword [dword ebp-0B2h]
        lea eax, [dword ebp-0AEh]
        call dword [byte esi+014h]
        xor ebx, ebx
        mov dword [byte ebp-02h], ebx
        mov dword [byte ebp-06h], ebx
        mov dword [byte ebp-0Ah], ebx
        mov dword [byte ebp+0Ah], ebx
        mov dword [byte ebp+06h], ebx
        mov dword [byte ebp+02h], ebx
        mov dword [byte ebp-012h], ebx
        mov dword [byte ebp-016h], ebx
        mov dword [byte ebp-01Ah], ebx
        mov dword [byte ebp+01Eh], ebx
        mov dword [byte ebp+01Ah], ebx
        mov dword [byte ebp+016h], ebx
        cmp eax, byte 1
        je near .130
        call ClearInputQueue
        jmp near .123
.39:
        cmp edi, byte 20h
        jge short .40
        xor edx, edx
.40:
        push edx
        cmp esi, byte 1Ch
        jge short .41
        xor esi, esi
        jmp short .42
.41:
        sub esi, byte 1Ch
.42:
        push esi
        mov esi, dword [byte ebp+066h]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [byte ebp+05Ah]
        push edi
        mov eax, dword [byte ebp+052h]
        push eax
        mov eax, dword [byte ebp+036h]
        mov ebx, dword [byte ebp+eax*8-07Ah]
        mov edx, dword [byte ebp+eax*8-07Eh]
        mov ecx, dword [byte ebp+eax*4-01Eh]
        shl ecx, 5
        mov eax, dword [byte ebp+eax*4-0Eh]
        add eax, ecx
        mov ecx, dword [byte ebp+056h]
        call DrawMenuItemSel
        mov edx, dword [byte ebp+036h]
        mov eax, dword [byte ebp+032h]
        mov dword [byte ebp+edx*4-01Eh], eax
        push edi
        mov ecx, dword [byte ebp+052h]
        push ecx
        mov ebx, dword [byte ebp+edx*8-07Ah]
        mov eax, dword [byte ebp+edx*8-07Eh]
        mov ecx, dword [byte ebp+edx*4-01Eh]
        shl ecx, 5
        mov esi, dword [byte ebp+edx*4-0Eh]
        add esi, ecx
.43:
        mov ecx, dword [byte ebp+056h]
        mov edx, eax
        mov eax, esi
.44:
        call DrawMenuItemNorm
        jmp near .123
.45:
        cmp dword [byte eax+018h], byte 0
        je near .57
        cmp edi, byte 20h
        jge short .46
        xor edx, edx
.46:
        push edx
        cmp esi, byte 1Ch
        jge short .47
        xor esi, esi
        jmp short .48
.47:
        sub esi, byte 1Ch
.48:
        push esi
        mov ecx, dword [byte ebp+066h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+06Ah]
        cmp eax, dword [byte ebp+036h]
        je short .52
        mov dword [byte ebp+042h], eax
        jmp short .51
.49:
        shl eax, 2
        xor esi, esi
        mov dword [byte eax+ebp-01Eh], esi
        mov edi, dword [byte eax+ebp+02h]
        test edi, edi
        je short .50
        mov edx, dword [byte ebp+042h]
        mov ebx, dword [byte ebp+edx*8-07Ah]
        push ebx
        mov ecx, dword [byte ebp+edx*8-07Eh]
        push ecx
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+042h]
        mov dword [byte ebp+eax*8-07Ah], esi
        mov dword [byte ebp+eax*8-07Eh], esi
        mov edx, dword [byte ebp+eax*4+02h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [byte ebp+042h]
        mov dword [byte ebp+eax*4+02h], esi
        mov dword [byte ebp+eax*4-0Eh], esi
        mov dword [byte ebp+eax*4+012h], esi
.50:
        dec dword [byte ebp+042h]
.51:
        mov eax, dword [byte ebp+042h]
        mov ecx, dword [byte ebp+036h]
        cmp eax, ecx
        jg short DbLineEditorLoop.49
        mov dword [byte ebp+06Ah], ecx
.52:
        mov eax, dword [byte ebp+05Ah]
        push eax
        mov edx, dword [byte ebp+052h]
        push edx
        mov esi, dword [byte ebp+06Ah]
        mov ebx, dword [byte ebp+esi*8-07Ah]
        mov edx, dword [byte ebp+esi*8-07Eh]
        mov eax, dword [byte ebp+esi*4-01Eh]
        shl eax, 5
        mov dword [byte ebp+046h], eax
        mov eax, dword [byte ebp+esi*4-0Eh]
        add eax, dword [byte ebp+046h]
        mov ecx, dword [byte ebp+056h]
        call DrawMenuItemSel
        mov eax, dword [byte ebp+032h]
        mov dword [byte ebp+esi*4-01Eh], eax
        mov eax, dword [byte ebp+05Ah]
        push eax
        mov edx, dword [byte ebp+052h]
        push edx
        mov ebx, dword [byte ebp+esi*8-07Ah]
        mov edx, dword [byte ebp+esi*8-07Eh]
        mov eax, dword [byte ebp+032h]
        shl eax, 5
        mov ecx, dword [byte ebp+esi*4-0Eh]
        add eax, ecx
        mov ecx, dword [byte ebp+056h]
        call DrawMenuItemNorm
        mov eax, dword [byte ebp+036h]
        mov ecx, dword [byte ebp+032h]
        shl ecx, 5
        mov ebx, dword [byte ebp+eax*4-0Eh]
        inc esi
        mov dword [byte ebp+06Ah], esi
        mov ebx, dword [byte ecx+ebx+018h]
        mov dword [byte ebp+esi*4-0Eh], ebx
        mov eax, dword [byte ebp+eax*4-0Eh]
        add eax, ecx
        mov ebx, dword [byte eax+01Ch]
        mov dword [byte ebp+esi*4+012h], ebx
        cmp esi, byte 1
        je short .53
        mov edx, dword [byte eax+08h]
        jmp short .54
.53:
        mov edx, dword [eax]
.54:
        mov eax, dword [byte ebp+06Ah]
        mov ebx, dword [dword ebp+eax*8-086h]
        add edx, ebx
        mov dword [byte ebp+eax*8-07Eh], edx
        mov edx, dword [byte ebp+032h]
        shl edx, 5
        mov eax, dword [byte ebp+036h]
        shl eax, 2
        cmp dword [byte ebp+06Ah], byte 1
        je short .55
        mov eax, dword [byte eax+ebp-0Eh]
        mov eax, dword [byte edx+eax+04h]
        jmp short .56
.55:
        mov eax, dword [byte eax+ebp-0Eh]
        mov eax, dword [byte edx+eax+0Ch]
.56:
        mov edx, dword [byte ebp+06Ah]
        shl edx, 3
        mov dword [byte ebp+05Eh], edx
        mov esi, dword [dword edx+ebp-082h]
        add eax, esi
        mov dword [byte edx+ebp-07Ah], eax
        mov eax, dword [byte ebp+06Ah]
        shl eax, 2
        mov dword [byte ebp+062h], eax
        mov edx, dword [byte eax+ebp+012h]
        shl edx, 5
        mov eax, dword [byte eax+ebp-0Eh]
        mov ebx, dword [byte edx+eax-018h]
        sub ebx, dword [eax]
        inc ebx
        mov dword [byte ebp+022h], ebx
        mov edx, dword [byte edx+eax-014h]
        sub edx, dword [byte eax+04h]
        inc edx
        mov dword [byte ebp+02Ah], edx
        push byte 20h
        mov eax, dword [byte ebp+022h]
        shl eax, 2
        imul eax, edx
        add eax, byte 11h
        push eax
        push str_Menubuff8
        call AllocMemBlock
        add esp, byte 0Ch
        mov edx, dword [byte ebp+062h]
        mov dword [byte edx+ebp+02h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [byte edx+ebp+02h]
        mov edx, dword [byte ebp+022h]
        mov word [byte eax+04h], dx
        mov eax, dword [byte ebp+062h]
        mov eax, dword [byte eax+ebp+02h]
        mov edx, dword [byte ebp+02Ah]
        mov word [byte eax+06h], dx
        mov eax, dword [byte ebp+05Eh]
        mov esi, dword [byte eax+ebp-07Ah]
        push esi
        mov edi, dword [byte eax+ebp-07Eh]
        push edi
        mov eax, dword [byte ebp+062h]
        mov edx, dword [byte eax+ebp+02h]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte ebp+05Ah]
        push ebx
        mov ecx, dword [byte ebp+052h]
        push ecx
        mov esi, dword [byte ebp+056h]
        push esi
        mov ecx, dword [byte ebp+05Eh]
        mov ecx, dword [byte ecx+ebp-07Ah]
        mov ebx, dword [byte ebp+05Eh]
        mov ebx, dword [byte ebx+ebp-07Eh]
        mov edx, dword [byte ebp+062h]
        mov edx, dword [byte edx+ebp+012h]
        mov eax, dword [byte ebp+062h]
        mov eax, dword [byte eax+ebp-0Eh]
        call DrawMenuDropdown
        mov eax, dword [byte ebp+062h]
        xor edi, edi
        mov dword [byte eax+ebp-01Eh], edi
        mov eax, dword [byte ebp+05Ah]
        push eax
        mov edx, dword [byte ebp+052h]
        push edx
        mov ebx, dword [byte ebp+05Eh]
        mov ebx, dword [byte ebx+ebp-07Ah]
        mov edx, dword [byte ebp+05Eh]
        mov edx, dword [byte edx+ebp-07Eh]
        mov eax, dword [byte ebp+062h]
        mov eax, dword [byte eax+ebp-0Eh]
        mov ecx, esi
        jmp near DbLineEditorLoop.44
.57:
        cmp edi, byte 20h
        jge short .58
        xor edx, edx
.58:
        push edx
        cmp esi, byte 1Ch
        jge short .59
        xor esi, esi
        jmp short .60
.59:
        sub esi, byte 1Ch
.60:
        push esi
        mov ecx, dword [byte ebp+066h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov esi, dword [byte ebp+05Ah]
        push esi
        mov edi, dword [byte ebp+052h]
        push edi
        mov eax, dword [byte ebp+036h]
        mov ebx, dword [byte ebp+eax*8-07Ah]
        mov edx, dword [byte ebp+eax*8-07Eh]
        mov ecx, dword [byte ebp+eax*4-01Eh]
        shl ecx, 5
        mov eax, dword [byte ebp+eax*4-0Eh]
        add eax, ecx
        mov ecx, dword [byte ebp+056h]
        call DrawMenuItemSel
        mov edx, dword [byte ebp+036h]
        mov eax, dword [byte ebp+032h]
        mov dword [byte ebp+edx*4-01Eh], eax
        push esi
        push edi
        mov ebx, dword [byte ebp+edx*8-07Ah]
        mov eax, dword [byte ebp+edx*8-07Eh]
        mov esi, dword [byte ebp+edx*4-01Eh]
        shl esi, 5
        mov edx, dword [byte ebp+edx*4-0Eh]
        add esi, edx
        jmp near DbLineEditorLoop.43
.61:
        cmp edi, byte 20h
        jge short .62
        xor edx, edx
.62:
        push edx
        cmp esi, byte 1Ch
        jge short .63
        xor esi, esi
        jmp short .64
.63:
        sub esi, byte 1Ch
.64:
        push esi
        mov ecx, dword [byte ebp+066h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        lea ebx, [byte ebp+02Eh]
        mov edx, dword [byte ebp+03Ah]
        mov eax, dword [byte ebp+03Eh]
        call LineEdHitTest
        test eax, eax
        je near .123
        mov dword [byte ebp+042h], 3
        jmp short .67
.65:
        mov eax, ecx
        shl eax, 2
        mov edx, dword [byte eax+ebp+02h]
        test edx, edx
        je short .66
        mov ebx, dword [byte ebp+ecx*8-07Ah]
        push ebx
        mov ecx, dword [byte ebp+ecx*8-07Eh]
        push ecx
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+042h]
        xor edi, edi
        mov dword [byte ebp+eax*8-07Ah], edi
        mov dword [byte ebp+eax*8-07Eh], edi
        mov edx, dword [byte ebp+eax*4+02h]
        push edx
        call FreeMemBlock
        add esp, byte 4
.66:
        dec dword [byte ebp+042h]
.67:
        mov ecx, dword [byte ebp+042h]
        test ecx, ecx
        jge short DbLineEditorLoop.65
        xor esi, esi
        mov dword [byte ebp+06Ah], esi
        mov dword [byte ebp-02h], esi
        mov dword [byte ebp-06h], esi
        mov dword [byte ebp-0Ah], esi
        mov dword [byte ebp+0Ah], esi
        mov dword [byte ebp+06h], esi
        mov dword [byte ebp+02h], esi
        mov dword [byte ebp-012h], esi
        mov dword [byte ebp-016h], esi
        mov dword [byte ebp-01Ah], esi
        mov dword [byte ebp+01Eh], esi
        mov dword [byte ebp+01Ah], esi
        mov dword [byte ebp+016h], esi
        cmp dword [byte ebp+02Eh], byte 64h
        jge near .116
        cmp dword [byte ebp+026h], byte 0FFFFFFFFh
        je near .116
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov esi, eax
        shl esi, 6
        sub esi, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        cmp byte [dword esi+eax+rosterstat], 2
        je near .116
        push dword 0C1h
        push dword 0C0h
        call TextSetColors
        add esp, byte 8
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, esi
        mov edx, dword [byte ebp+02Eh]
        cmp edx, byte 0Ch
        jge near .76
        mov dh, byte [dword eax+rosterlist]
        cmp dh, 43h
        je short .68
        cmp dh, 4Ch
        je short .68
        cmp dh, 52h
        jne near .123
.68:
        mov ebx, 3
        mov eax, dword [byte ebp+02Eh]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov dword [byte ebp+042h], eax
        xor esi, esi
.69:
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add ebx, eax
        mov edx, dword [byte ebp+042h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, esi
        mov dl, byte [dword eax+ebp-0AEh]
        cmp dl, byte [dword ebx+rosterjersey]
        jne short .70
        mov byte [dword eax+ebp-0AEh], 64h
.70:
        inc esi
        cmp esi, byte 3
        jl short DbLineEditorLoop.69
        mov ebx, 3
        mov eax, dword [byte ebp+02Eh]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [ebx+eax]
        mov ebx, dword [byte ebp+042h]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        add esi, eax
        mov al, byte [dword edx+rosterjersey]
        mov byte [dword esi+ebp-0AEh], al
        xor esi, esi
.71:
        mov edx, dword [byte ebp+042h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, esi
        cmp byte [dword eax+ebp-0AEh], 63h
        ja short .72
        xor ecx, ecx
        mov cl, byte [byte ebp+076h]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        xor edx, edx
        mov dl, byte [dword eax+ebp-0AEh]
        mov eax, jerseyremap
        call MakeJerseyShape
        jmp short .75
.72:
        xor eax, eax
        mov dl, byte [byte ebp+076h]
.73:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 90h
        jl short DbLineEditorLoop.73
        mov eax, 0C0h
        mov dl, byte [byte ebp+076h]
.74:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 0F0h
        jl short DbLineEditorLoop.74
.75:
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov edx, dword [byte ebp+042h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, esi
        mov ecx, dword [nosplit eax*8+linesloty]
        push ecx
        mov edi, dword [nosplit eax*8+lineslotx]
        push edi
        mov eax, dword [dword ebp-0B6h]
        push eax
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 3
        jl near DbLineEditorLoop.71
        jmp near .123
.76:
        cmp edx, byte 12h
        jge near .84
        cmp byte [dword eax+rosterlist], 44h
        jne near .123
        mov edx, dword [byte ebp+02Eh]
        sub edx, byte 0Ch
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [byte ebp+042h], eax
        xor esi, esi
        mov cl, 64h
.77:
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [ebx+eax]
        mov eax, dword [byte ebp+042h]
        add eax, eax
        add eax, esi
        mov bl, byte [dword eax+ebp-0A2h]
        cmp bl, byte [dword edx+rosterjersey]
        jne short .78
        mov byte [dword eax+ebp-0A2h], cl
.78:
        inc esi
        cmp esi, byte 2
        jl short DbLineEditorLoop.77
        mov edx, dword [byte ebp+02Eh]
        sub edx, byte 0Ch
        mov ebx, 2
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [byte ebp+042h]
        add edx, edx
        add esi, edx
        mov al, byte [dword ebx+eax+rosterjersey]
        mov byte [dword esi+ebp-0A2h], al
        xor esi, esi
.79:
        mov eax, dword [byte ebp+042h]
        add eax, eax
        add eax, esi
        cmp byte [dword eax+ebp-0A2h], 63h
        ja short .80
        xor ecx, ecx
        mov cl, byte [byte ebp+076h]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        xor edx, edx
        mov dl, byte [dword eax+ebp-0A2h]
        mov eax, jerseyremap
        call MakeJerseyShape
        jmp short .83
.80:
        xor eax, eax
        mov dl, byte [byte ebp+076h]
.81:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 90h
        jl short DbLineEditorLoop.81
        mov eax, 0C0h
        mov dl, byte [byte ebp+076h]
.82:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 0F0h
        jl short DbLineEditorLoop.82
.83:
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov eax, dword [byte ebp+042h]
        add eax, eax
        add eax, esi
        mov edi, dword [nosplit eax*8+dword_D139C]
        push edi
        mov edx, dword [nosplit eax*8+dword_D1398]
        push edx
        mov ebx, dword [dword ebp-0B6h]
        push ebx
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 2
        jl near DbLineEditorLoop.79
        jmp near .123
.84:
        cmp edx, byte 1Ch
        jge near .92
        cmp byte [dword eax+rosterlist], 47h
        je near .123
        sub edx, byte 12h
        mov ebx, 5
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [byte ebp+042h], eax
        xor esi, esi
.85:
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add ebx, eax
        mov edx, dword [byte ebp+042h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        add eax, esi
        mov dl, byte [dword eax+ebp-09Ch]
        cmp dl, byte [dword ebx+rosterjersey]
        jne short .86
        mov byte [dword eax+ebp-09Ch], 64h
.86:
        inc esi
        cmp esi, byte 5
        jl short DbLineEditorLoop.85
        mov edx, dword [byte ebp+02Eh]
        sub edx, byte 12h
        mov ebx, 5
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add ebx, eax
        mov edx, dword [byte ebp+042h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        add esi, eax
        mov al, byte [dword ebx+rosterjersey]
        mov byte [dword esi+ebp-09Ch], al
        xor esi, esi
.87:
        mov edx, dword [byte ebp+042h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        add eax, esi
        cmp byte [dword eax+ebp-09Ch], 63h
        ja short .88
        xor ecx, ecx
        mov cl, byte [byte ebp+076h]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        xor edx, edx
        mov dl, byte [dword eax+ebp-09Ch]
        mov eax, jerseyremap
        call MakeJerseyShape
        jmp short .91
.88:
        xor eax, eax
        mov dl, byte [byte ebp+076h]
.89:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 90h
        jl short DbLineEditorLoop.89
        mov eax, 0C0h
        mov dl, byte [byte ebp+076h]
.90:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 0F0h
        jl short DbLineEditorLoop.90
.91:
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov edx, dword [byte ebp+042h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        add eax, esi
        mov edx, dword [nosplit eax*8+dword_D13CC]
        push edx
        mov ebx, dword [nosplit eax*8+dword_D13C8]
        push ebx
        mov ecx, dword [dword ebp-0B6h]
        push ecx
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 5
        jl near DbLineEditorLoop.87
        jmp near .123
.92:
        cmp edx, byte 24h
        jge near .100
        cmp byte [dword eax+rosterlist], 47h
        je near .123
        sub edx, byte 1Ch
        mov eax, edx
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        mov dword [byte ebp+042h], eax
        xor esi, esi
        mov cl, 64h
.93:
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [ebx+eax]
        mov eax, dword [byte ebp+042h]
        shl eax, 2
        add eax, esi
        mov bl, byte [dword eax+ebp-092h]
        cmp bl, byte [dword edx+rosterjersey]
        jne short .94
        mov byte [dword eax+ebp-092h], cl
.94:
        inc esi
        cmp esi, byte 4
        jl short DbLineEditorLoop.93
        mov edx, dword [byte ebp+02Eh]
        sub edx, byte 1Ch
        mov ebx, 4
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [byte ebp+042h]
        shl edx, 2
        add esi, edx
        mov al, byte [dword ebx+eax+rosterjersey]
        mov byte [dword esi+ebp-092h], al
        xor esi, esi
.95:
        mov eax, dword [byte ebp+042h]
        shl eax, 2
        add eax, esi
        cmp byte [dword eax+ebp-092h], 63h
        ja short .96
        xor ecx, ecx
        mov cl, byte [byte ebp+076h]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        xor edx, edx
        mov dl, byte [dword eax+ebp-092h]
        mov eax, jerseyremap
        call MakeJerseyShape
        jmp short .99
.96:
        xor eax, eax
        mov dl, byte [byte ebp+076h]
.97:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 90h
        jl short DbLineEditorLoop.97
        mov eax, 0C0h
        mov dl, byte [byte ebp+076h]
.98:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 0F0h
        jl short DbLineEditorLoop.98
.99:
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov eax, dword [byte ebp+042h]
        shl eax, 2
        add eax, esi
        mov ecx, dword [nosplit eax*8+dword_D141C]
        push ecx
        mov edi, dword [nosplit eax*8+dword_D1418]
        push edi
        mov eax, dword [dword ebp-0B6h]
        push eax
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 4
        jl near DbLineEditorLoop.95
        jmp near .123
.100:
        cmp edx, byte 26h
        jge near .108
        cmp byte [dword eax+rosterlist], 47h
        jne near .123
        xor esi, esi
.101:
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov dl, byte [dword esi+ebp-08Ah]
        cmp dl, byte [dword ebx+eax+rosterjersey]
        jne short .102
        mov byte [dword esi+ebp-08Ah], 64h
.102:
        inc esi
        cmp esi, byte 2
        jl short DbLineEditorLoop.101
        mov esi, dword [byte ebp+02Eh]
        sub esi, byte 24h
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov al, byte [dword ebx+eax+rosterjersey]
        mov byte [dword esi+ebp-08Ah], al
        xor esi, esi
.103:
        cmp byte [dword esi+ebp-08Ah], 63h
        ja short .104
        xor ecx, ecx
        mov cl, byte [byte ebp+076h]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        xor edx, edx
        mov dl, byte [dword esi+ebp-08Ah]
        mov eax, jerseyremap
        call MakeJerseyShape
        jmp short .107
.104:
        xor eax, eax
        mov dl, byte [byte ebp+076h]
.105:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 90h
        jl short DbLineEditorLoop.105
        mov eax, 0C0h
        mov dl, byte [byte ebp+076h]
.106:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 0F0h
        jl short DbLineEditorLoop.106
.107:
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov edi, dword [nosplit esi*8+dword_D145C]
        push edi
        mov edx, dword [nosplit esi*8+dword_D1458]
        push edx
        mov ebx, dword [dword ebp-0B6h]
        push ebx
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 2
        jl near DbLineEditorLoop.103
        jmp near .123
.108:
        cmp byte [dword eax+rosterlist], 47h
        je near .123
        xor esi, esi
        mov ch, 64h
.109:
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov dl, byte [dword esi+ebp-088h]
        cmp dl, byte [dword ebx+eax+rosterjersey]
        jne short .110
        mov byte [dword esi+ebp-088h], ch
.110:
        inc esi
        cmp esi, byte 2
        jl short DbLineEditorLoop.109
        mov esi, dword [byte ebp+02Eh]
        sub esi, byte 26h
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov al, byte [dword ebx+eax+rosterjersey]
        mov byte [dword esi+ebp-088h], al
        xor esi, esi
.111:
        cmp byte [dword esi+ebp-088h], 63h
        ja short .112
        xor ecx, ecx
        mov cl, byte [byte ebp+076h]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        xor edx, edx
        mov dl, byte [dword esi+ebp-088h]
        mov eax, jerseyremap
        call MakeJerseyShape
        jmp short .115
.112:
        xor eax, eax
        mov dl, byte [byte ebp+076h]
.113:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 90h
        jl short DbLineEditorLoop.113
        mov eax, 0C0h
        mov dl, byte [byte ebp+076h]
.114:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 0F0h
        jl short DbLineEditorLoop.114
.115:
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov edx, dword [nosplit esi*8+dword_D146C]
        push edx
        mov ebx, dword [nosplit esi*8+dword_D1468]
        push ebx
        mov ecx, dword [dword ebp-0B6h]
        push ecx
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 2
        jl near DbLineEditorLoop.111
        jmp near .123
.116:
        cmp dword [byte ebp+02Eh], byte 64h
        jl near .123
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov ecx, dword [byte ebp+02Eh]
        sub ecx, byte 64h
        mov dword [byte ebp+02Eh], ecx
        mov eax, ecx
        shl eax, 3
        sub eax, ecx
        shl eax, 2
        sub eax, ecx
        add eax, ebx
        mov bl, byte [dword eax+rosterstat]
        test bl, bl
        je near .123
        cmp bl, 4
        je short .117
        cmp bl, 3
        je short .117
        cmp bl, 2
        jne near .123
.117:
        mov esi, dword [byte ebp+026h]
        cmp esi, byte 0FFFFFFFFh
        je near .120
        xor edx, edx
        mov dl, byte [byte ebp+072h]
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
        cmp byte [dword ebx+eax+rosterstat], 2
        jne short .118
        push dword 0C1h
        push dword 0FCh
        jmp short .119
.118:
        push dword 0C1h
        push dword 0C3h
.119:
        call TextSetColors
        add esp, byte 8
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov ecx, rosterlist
        add ecx, ebx
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [byte ecx+eax+08h]
        push edx
        xor edx, edx
        mov dl, byte [dword ebx+eax+rosterjersey]
        push edx
        mov al, byte [dword ebx+eax+rosterlist]
        and eax, 0FFh
        push eax
        push str_C2dS2
        lea eax, [byte ebp-03Eh]
        push eax
        call sprintf_
        add esp, byte 14h
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        lea edx, [byte eax+016h]
        lea ebx, [byte ebp-03Eh]
        mov eax, 1FAh
        call PrintLineEdStatus
.120:
        mov eax, dword [byte ebp+02Eh]
        mov dword [byte ebp+026h], eax
        mov dword [menuact_dbdress], DressPlayer
        mov dword [menuact_dbscratch], ScratchPlayer
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+02Eh]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        cmp byte [dword ebx+eax+rosterstat], 2
        jne short .121
        push dword 0C1h
        push dword 0FDh
        jmp short .122
.121:
        push dword 0C1h
        push dword 0C0h
.122:
        call TextSetColors
        add esp, byte 8
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov ecx, rosterlist
        add ecx, ebx
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add ecx, eax
        add ecx, byte 8
        push ecx
        xor edx, edx
        mov dl, byte [dword ebx+eax+rosterjersey]
        push edx
        mov al, byte [dword ebx+eax+rosterlist]
        and eax, 0FFh
        push eax
        push str_C2dS2
        lea eax, [byte ebp-03Eh]
        push eax
        call sprintf_
        add esp, byte 14h
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        lea edx, [byte eax+016h]
        lea ebx, [byte ebp-03Eh]
        mov eax, 1FAh
        call PrintLineEdStatus
.123:
        mov edx, dword [byte ebp+03Ah]
        cmp edx, byte 20h
        jge short .124
        xor eax, eax
        jmp short .125
.124:
        lea eax, [byte edx-020h]
.125:
        push eax
        mov ebx, dword [byte ebp+03Eh]
        cmp ebx, byte 1Ch
        jge short .126
        xor eax, eax
        jmp short .127
.126:
        lea eax, [byte ebx-01Ch]
.127:
        push eax
        mov ecx, dword [byte ebp+066h]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+03Ah]
        mov edx, dword [byte ebp-0Eh]
        cmp eax, dword [byte edx+0Ch]
        jle near .129
        mov edi, dword [byte ebp+03Eh]
        cmp edi, 1F4h
        jge near .129
        cmp dword [byte ebp+026h], byte 0FFFFFFFFh
        je near .129
        cmp dword [byte ebp-0Ah], byte 0
        je short .128
        lea eax, [byte ebp+032h]
        push eax
        lea eax, [byte ebp+036h]
        push eax
        lea eax, [byte ebp-07Eh]
        push eax
        lea eax, [byte ebp+012h]
        push eax
        mov ecx, dword [byte ebp+06Ah]
        lea ebx, [byte ebp-0Eh]
        mov edx, dword [byte ebp+03Ah]
        mov eax, edi
        call MenuHitTest
        test eax, eax
        jne short .129
.128:
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte ebp+026h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, ebx
        cmp byte [dword eax+rosterstat], 2
        je short .129
        xor ecx, ecx
        mov cl, byte [byte ebp+076h]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        xor edx, edx
        mov dl, byte [dword eax+rosterjersey]
        mov eax, jerseyremap
        call MakeJerseyShape
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov eax, dword [byte ebp+03Ah]
        sub eax, byte 20h
        push eax
        mov eax, dword [byte ebp+03Eh]
        sub eax, byte 1Ch
        push eax
        mov ebx, dword [dword ebp-0B6h]
        push ebx
        call sub_91FE0
        add esp, byte 0Ch
.129:
        mov ecx, dword [byte ebp+03Ah]
        push ecx
        mov eax, dword [byte ebp+03Eh]
        sub eax, byte 3
        push eax
        mov esi, dword [pointerspr]
        push esi
        jmp near DbLineEditorLoop.27
.130:
        call ClearInputQueue
        mov edi, dword [byte ebp+066h]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebx, 10h
        mov edx, dword [byte ebp+04Ah]
        mov eax, 1
        call FadePalStep
        mov eax, dword [byte ebp+04Ah]
        push eax
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        lea esp, [byte ebp+07Ah]
        pop ebp
        pop edi
        pop esi
        ret 0Ch
;-----------------------------------------------------------------------------
; DrawLineJerseys                                                 75046  95 PC
; (lines, ..., panel): draws the 40 line slots as team-coloured jersey
; numbers (MakeJerseyShape) at lineslotx / linesloty
;-----------------------------------------------------------------------------
; C: src/front/lines/DrawLineJerseys.c
%ifdef CBUILD
%include "c/front/lines/DrawLineJerseys.inc"
%else
DrawLineJerseys:
        push dword 58h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 30h
        mov ebp, eax
        mov dword [byte esp+020h], edx
        mov byte [byte esp+02Ch], bl
        xor eax, eax
        mov al, bl
        mov al, byte [dword eax+rosterteam]
        and eax, 0FFh
        mov al, byte [nosplit eax*4+byte_D11BC]
        mov byte [byte esp+024h], al
        xor eax, eax
        mov al, byte [byte esp+024h]
        mov al, byte [dword eax+jerseyremap]
        mov byte [byte esp+024h], al
        mov al, byte [byte_D12DE]
        mov byte [byte esp+028h], al
        xor esi, esi
.1:
        lea eax, [esi+ebp]
        cmp byte [eax], 63h
        ja short .2
        xor ecx, ecx
        mov cl, byte [byte esp+028h]
        xor ebx, ebx
        mov bl, byte [byte esp+024h]
        xor edx, edx
        mov dl, byte [eax]
        mov eax, jerseyremap
        call MakeJerseyShape
        jmp short .5
.2:
        xor eax, eax
        mov dl, byte [byte esp+028h]
.3:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 90h
        jl short DrawLineJerseys.3
        mov eax, 0C0h
        mov dl, byte [byte esp+028h]
.4:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 0F0h
        jl short DrawLineJerseys.4
.5:
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov edx, dword [nosplit esi*8+linesloty]
        push edx
        mov ebx, dword [nosplit esi*8+lineslotx]
        push ebx
        mov ecx, dword [byte esp+028h]
        push ecx
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 28h
        jl short DrawLineJerseys.1
        xor esi, esi
.6:
        xor edx, edx
        mov dl, byte [byte esp+02Ch]
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
        add eax, ebx
        mov dh, byte [dword eax+rosterstat]
        test dh, dh
        je near .x
        mov al, dh
        cmp dh, 2
        jb short .9
        jbe short .7
        cmp dh, 3
        je short .8
        jmp short .9
.7:
        mov edi, 0FCh
        jmp short .9
.8:
        mov edi, 0C3h
.9:
        push dword 0C1h
        push edi
        call TextSetColors
        add esp, byte 8
        xor edx, edx
        mov dl, byte [byte esp+02Ch]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ecx, eax
        shl ecx, 6
        sub ecx, eax
        mov ebx, rosterlist
        add ebx, ecx
        mov edx, esi
        mov eax, esi
        shl eax, 3
        sub eax, esi
        shl eax, 2
        sub eax, esi
        add ebx, eax
        add ebx, byte 8
        push ebx
        xor edx, esi
        mov dl, byte [dword ecx+eax+rosterjersey]
        push edx
        mov al, byte [dword ecx+eax+rosterlist]
        and eax, 0FFh
        push eax
        push str_C2dS2
        lea eax, [byte esp+010h]
        push eax
        call sprintf_
        add esp, byte 14h
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        add eax, esi
        lea edx, [byte eax+016h]
        mov ebx, esp
        mov eax, 1FAh
        call PrintLineEdStatus
        inc esi
        cmp esi, byte 1Ch
        jl near DrawLineJerseys.6
.x:
        add esp, byte 30h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CheckRosterComplete                                             751FC  95 PC
; Dressed (status 3) players must be 18 skaters and 2 goalies, else "Your
; Roster is incomplete." with the counts ("%s %2d %s%s", Scratch / Dress,
; Player / Goalie)
;-----------------------------------------------------------------------------
; C: src/front/lines/CheckRosterComplete.c
%ifdef CBUILD
%include "c/front/lines/CheckRosterComplete.inc"
%else
CheckRosterComplete:
        push dword 0B0h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 7Ch
        push eax
        push edx
        mov byte [dword esp+080h], bl
        xor ebp, ebp
        mov dword [byte esp+07Ch], ebp
        mov ecx, 6
        lea edi, [byte esp+040h]
        mov esi, str_RosterIncomplete
        rep movsd
        movsw
        movsb
        lea edi, [byte esp+05Ch]
        mov esi, str_Scratch
        movsd
        movsd
        lea edi, [byte esp+074h]
        mov esi, str_Dress
        movsd
        movsw
        lea edi, [byte esp+06Ch]
        mov esi, str_Player
        movsd
        movsw
        movsb
        lea edi, [byte esp+064h]
        mov esi, str_GoalieW
        movsd
        movsw
        movsb
        mov esi, str_S2dSS
        xor ebx, ebx
.1:
        xor edx, edx
        mov dl, byte [dword esp+080h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ecx, eax
        shl ecx, 6
        sub ecx, eax
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, ecx
        cmp byte [dword eax+rosterstat], 3
        jne short .3
        cmp byte [dword eax+rosterlist], 47h
        je short .2
        inc ebp
        jmp short .3
.2:
        inc dword [byte esp+07Ch]
.3:
        inc ebx
        cmp ebx, byte 1Ch
        jl short CheckRosterComplete.1
        cmp ebp, byte 12h
        jne short .4
        cmp dword [byte esp+07Ch], byte 2
        je near .22
.4:
        cmp ebp, byte 12h
        jge short .7
        mov eax, 12h
        sub eax, ebp
        cmp eax, byte 1
        jne short .5
        mov eax, str_dot2
        jmp short .6
.5:
        mov eax, str_S6
.6:
        push eax
        lea eax, [byte esp+070h]
        push eax
        mov eax, 12h
        sub eax, ebp
        push eax
        lea eax, [dword esp+080h]
        jmp short .10
.7:
        jle short .11
        lea eax, [byte ebp-012h]
        cmp eax, byte 1
        jne short .8
        mov eax, str_dot2
        jmp short .9
.8:
        mov eax, str_S6
.9:
        push eax
        lea eax, [byte esp+070h]
        push eax
        lea eax, [byte ebp-012h]
        push eax
        lea eax, [byte esp+068h]
.10:
        push eax
        push esi
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 18h
.11:
        mov eax, dword [byte esp+07Ch]
        cmp eax, byte 2
        jge short .14
        mov eax, 2
        sub eax, dword [byte esp+07Ch]
        cmp eax, byte 1
        jne short .12
        mov eax, str_dot2
        jmp short .13
.12:
        mov eax, str_S6
.13:
        push eax
        lea eax, [byte esp+068h]
        push eax
        mov eax, 2
        sub eax, dword [dword esp+084h]
        push eax
        lea eax, [dword esp+080h]
        jmp short .17
.14:
        jle short .18
        sub eax, byte 2
        cmp eax, byte 1
        jne short .15
        mov eax, str_dot2
        jmp short .16
.15:
        mov eax, str_S6
.16:
        push eax
        lea eax, [byte esp+068h]
        push eax
        mov eax, dword [dword esp+084h]
        sub eax, byte 2
        push eax
        lea eax, [byte esp+068h]
.17:
        push eax
        push esi
        lea eax, [byte esp+038h]
        push eax
        call sprintf_
        add esp, byte 18h
.18:
        cmp ebp, byte 12h
        je short .19
        cmp dword [byte esp+07Ch], byte 2
        je short .19
        lea eax, [byte esp+040h]
        mov dword [msglines], eax
        lea eax, [byte esp+08h]
        mov dword [msglines+4], eax
        lea eax, [byte esp+024h]
        mov dword [msglines+8], eax
        push byte 0FFFFFFFFh
        mov ebx, dword [byte esp+04h]
        push ebx
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push byte 0
        push byte 0
        mov ecx, 3
        jmp short .21
.19:
        cmp ebp, byte 12h
        je short .20
        lea eax, [byte esp+040h]
        mov dword [msglines], eax
        lea eax, [byte esp+08h]
        mov dword [msglines+4], eax
        push byte 0FFFFFFFFh
        mov eax, dword [byte esp+04h]
        push eax
        mov edx, dword [byte esp+0Ch]
        push edx
        push byte 0
        push byte 0
        mov ecx, 2
        jmp short .21
.20:
        lea eax, [byte esp+040h]
        mov dword [msglines], eax
        lea eax, [byte esp+024h]
        mov dword [msglines+4], eax
        push byte 0FFFFFFFFh
        mov edi, dword [byte esp+04h]
        push edi
        mov ebp, dword [byte esp+0Ch]
        push ebp
        push byte 0
        push byte 0
        mov ecx, 2
.21:
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov eax, 1
        jmp short .x
.22:
        xor eax, eax
.x:
        add esp, 84h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LineEdDone                                                      75456  95 PC
; Line editor "Done": CheckRosterComplete, maps the 40 line slots and the 8
; extra (scratched) slots back to roster slots, copies the team record lines
; +0BCh to +0ECh
;-----------------------------------------------------------------------------
; C: src/front/lines/MenuShowPlayerStats.c (LineEdDone)
%ifdef CBUILD
%include "c/front/lines/MenuShowPlayerStats.LineEdDone.inc"
%else
LineEdDone:
        push dword 14h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov ebp, edx
        mov byte [esp], bl
        xor ebx, ebx
        mov bl, byte [esp]
        mov edx, dword [byte esp+028h]
        mov eax, dword [byte esp+024h]
        call CheckRosterComplete
        test eax, eax
        je short .1
        xor eax, eax
        jmp near .11
.1:
        xor esi, esi
.2:
        lea ecx, [edi+esi]
        mov ah, byte [ecx]
        cmp ah, 64h
        jne short .3
        mov byte [esi+ebp], ah
        jmp short .6
.3:
        xor ecx, ecx
.4:
        xor edx, edx
        mov dl, byte [esp]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov eax, ecx
        shl eax, 3
        sub eax, ecx
        shl eax, 2
        sub eax, ecx
        add eax, ebx
        cmp byte [dword eax+rosterstat], 0
        je short .5
        mov dl, byte [edi+esi]
        cmp dl, byte [dword eax+rosterjersey]
        jne short .5
        mov al, byte [dword eax+rosterslot]
        mov byte [esi+ebp], al
        jmp short .6
.5:
        inc ecx
        cmp ecx, byte 1Ch
        jl short LineEdDone.4
.6:
        inc esi
        cmp esi, byte 28h
        jl short LineEdDone.2
        xor esi, esi
.7:
        mov byte [byte esi+ebp+028h], 64h
        inc esi
        cmp esi, byte 8
        jl short LineEdDone.7
        xor esi, esi
        xor ecx, ecx
        jmp short .10
.8:
        xor edx, edx
        mov dl, byte [esp]
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
        add eax, ebx
        mov bl, byte [dword eax+rosterstat]
        test bl, bl
        je short .9
        cmp bl, 3
        je short .9
        mov al, byte [dword eax+rosterslot]
        mov byte [byte ecx+ebp+028h], al
        inc ecx
.9:
        inc esi
.10:
        cmp esi, byte 1Ch
        jl short LineEdDone.8
        movzx esi, byte [esp]
        mov esi, dword [nosplit esi*4+rosterteamrec]
        mov ecx, 0Ch
        lea edi, [dword esi+0ECh]
        lea esi, [dword esi+0BCh]
        rep movsd
        mov eax, 1
.11:
        add esp, byte 4
        jmp near MenuShowPlayerStats_ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuShowPlayerStats                                             7556E  95 PC
; Line editor "Show Player Statistics": loads keys / pstat / gstat, Regular
; Season / Play-Off menu, redraws the lines
;-----------------------------------------------------------------------------
; C: src/front/lines/MenuShowPlayerStats.c
%ifdef CBUILD
%include "c/front/lines/MenuShowPlayerStats.inc"
%else
MenuShowPlayerStats:
        push dword 48h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 24h
        mov ebp, eax
        mov byte [byte esp+020h], bl
        mov esi, ecx
        push byte 0
        push dword 5B0h
        push str_Keys3
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsplayerbuf], eax
        push byte 0
        push dword 497h
        push str_Pstat3
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [rosterpstat], eax
        push byte 0
        push dword 10Eh
        push str_Gstat3
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [rostergstat], eax
        mov ecx, 0C3h
        mov ebx, 0C2h
        mov edx, 0C1h
        mov eax, 0C0h
        call ShowRosterStats
        push dword 0C2h
        mov ecx, 0C1h
        mov ebx, 0C0h
        mov edx, 2
        mov eax, rosterstatsmenubar
        call RunMenu
        mov edx, dword [rostergstat]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [rosterpstat]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        mov ecx, dword [statsplayerbuf]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        xor edi, edi
        mov dword [statsplayerbuf], edi
        mov dword [rostergstat], edi
        mov dword [rosterpstat], edi
        mov ebx, dword [fullscrbmp]
        push ebx
        call SetDrawBitmap
        add esp, byte 4
        push edi
        call ClearScreen
        add esp, byte 4
        mov ecx, dword [byte esp+040h]
        push ecx
        movzx edi, byte [byte esp+024h]
        mov ecx, dword [byte esp+040h]
        mov ebx, dword [byte esp+03Ch]
        mov edx, dword [byte esp+038h]
        mov eax, edi
        call DrawLineEditorScreen
        mov ebx, edi
        mov edx, dword [byte esp+034h]
        mov eax, ebp
        call DrawLineJerseys
        call SetScreenTarget
        mov eax, dword [fullscrbmp]
        mov ebp, dword [byte eax+02Ch]
        push ebp
        call sub_9121C
        add esp, byte 4
        cmp dword [esi], byte 0
        jl near MenuShowPlayerStats_status.1
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 2
        mov edx, eax
        shl edx, 6
        sub edx, eax
        mov edi, dword [esi]
        mov eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 2
        sub eax, edi
        cmp byte [dword edx+eax+rosterstat], 2
        jne short .1
        push dword 0C1h
        push byte 7Eh
        jmp short .2
.1:
        push dword 0C1h
        push dword 0C0h
.2:
        call TextSetColors
        add esp, byte 8
        movzx edi, byte [byte esp+020h]
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 2
        mov ebp, eax
        shl ebp, 6
        sub ebp, eax
        mov edx, rosterlist
        add edx, ebp
        mov edi, dword [esi]
        mov eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 2
        sub eax, edi
        add edx, eax
        add edx, byte 8
        push edx
        xor edx, edx
        mov dl, byte [dword eax+ebp+rosterjersey]
        push edx
        mov al, byte [dword eax+ebp+rosterlist]
        and eax, 0FFh
        push eax
        push str_C2dS2
        lea eax, [byte esp+010h]
        push eax
        call sprintf_
        add esp, byte 14h
        mov esi, dword [esi]
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        add eax, esi
MenuShowPlayerStats_status:
        lea edx, [byte eax+016h]
        mov ebx, esp
        mov eax, 1FAh
        call PrintLineEdStatus
.1:
        xor eax, eax
        add esp, byte 24h
MenuShowPlayerStats_ret:
        pop ebp
        pop edi
        pop esi
        ret 18h
%endif ; C
;-----------------------------------------------------------------------------
; ScratchPlayer                                                   75770  95 PC
; Status 2 (scratched): removes the player from every line slot, redraws,
; prints his "%c %2d %s" row
;-----------------------------------------------------------------------------
; C: src/front/lines/MenuShowPlayerStats.c (ScratchPlayer)
%ifdef CBUILD
%include "c/front/lines/MenuShowPlayerStats.ScratchPlayer.inc"
%else
ScratchPlayer:
        push dword 48h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 24h
        mov edi, eax
        mov byte [byte esp+020h], bl
        mov esi, ecx
        xor ebx, ebx
.1:
        xor edx, edx
        mov dl, byte [byte esp+020h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ecx, eax
        shl ecx, 6
        sub ecx, eax
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [ecx+eax]
        lea eax, [edi+ebx]
        mov cl, byte [eax]
        cmp cl, byte [dword edx+rosterjersey]
        jne short .2
        mov byte [eax], 64h
.2:
        inc ebx
        cmp ebx, byte 28h
        jl short ScratchPlayer.1
        xor ebx, ebx
        mov bl, byte [byte esp+020h]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        mov ebp, eax
        shl ebp, 6
        sub ebp, eax
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov byte [dword eax+ebp+rosterstat], 2
        mov edx, dword [byte esp+034h]
        mov eax, edi
        call DrawLineJerseys
        push dword 0C1h
        push dword 0FDh
        call TextSetColors
        add esp, byte 8
        mov ebx, rosterlist
        add ebx, ebp
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [byte ebx+eax+08h]
        push edx
        xor edx, edx
        mov dl, byte [dword eax+ebp+rosterjersey]
        push edx
        mov al, byte [dword eax+ebp+rosterlist]
        and eax, 0FFh
        push eax
        push str_C2dS2
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
        jmp near MenuShowPlayerStats_status
%endif ; C
;-----------------------------------------------------------------------------
; DressPlayer                                                     75868  95 PC
; Status 3 (dressed), redraws, prints his row
;-----------------------------------------------------------------------------
; C: src/front/lines/MenuShowPlayerStats.c (DressPlayer)
%ifdef CBUILD
%include "c/front/lines/MenuShowPlayerStats.DressPlayer.inc"
%else
DressPlayer:
        push dword 44h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 20h
        mov edi, eax
        mov esi, ecx
        and ebx, 0FFh
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        mov ebp, eax
        shl ebp, 6
        sub ebp, eax
        mov edx, dword [ecx]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov byte [dword eax+ebp+rosterstat], 3
        mov edx, dword [byte esp+030h]
        mov eax, edi
        call DrawLineJerseys
        push dword 0C1h
        push dword 0C0h
        call TextSetColors
        add esp, byte 8
        mov ebx, rosterlist
        add ebx, ebp
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add ebx, eax
        add ebx, byte 8
        push ebx
        xor edx, edx
        mov dl, byte [dword eax+ebp+rosterjersey]
        push edx
        mov al, byte [dword eax+ebp+rosterlist]
        and eax, 0FFh
        push eax
        push str_C2dS2
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
        jmp near MenuShowPlayerStats_ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpRosterSkaters                             75931  95 PC, medium confidence
; Qsort compare of skater stat rows (regular or play-off half by
; statsplayoffs)
;-----------------------------------------------------------------------------
; C: src/front/lines/CmpRosterSkaters.c
%ifdef CBUILD
%include "c/front/lines/CmpRosterSkaters.inc"
%else
CmpRosterSkaters:
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
        shl eax, 2
        add ebx, eax
        shl ebx, 3
        mov eax, dword [rosterpstat]
        add eax, ebx
        jmp short .2
.1:
        mov ebx, dword [eax]
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 3
        mov ebx, dword [rosterpstat]
        add eax, ebx
        add eax, byte 12h
.2:
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [edx]
        mov edx, ebx
        shl edx, 2
        add edx, ebx
        shl edx, 3
        mov ebx, dword [rosterpstat]
        add ebx, edx
        jmp short .4
.3:
        mov ebx, dword [edx]
        mov edx, ebx
        shl edx, 2
        add edx, ebx
        shl edx, 3
        mov ebx, dword [rosterpstat]
        add ebx, edx
        add ebx, byte 12h
.4:
        mov edx, ebx
        cmp word [ebx], byte 0
        sete bl
        mov ecx, ebx
        and ecx, 0FFh
        mov si, word [eax]
        test si, si
        sete bl
        and ebx, 0FFh
        xor ebx, ecx
        je short .7
        mov dx, word [edx]
.5:
        and edx, 0FFFFh
        mov eax, esi
.6:
        and eax, 0FFFFh
        jmp short .11
.7:
        mov bx, word [byte edx+06h]
        mov di, word [byte eax+06h]
        cmp bx, di
        je short .8
        mov edx, ebx
        and edx, 0FFFFh
        mov eax, edi
        jmp short CmpRosterSkaters.6
.8:
        cmp si, word [edx]
        je short .9
        xor ebx, ebx
        mov bx, si
        xor eax, eax
        mov ax, word [edx]
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.9:
        mov bx, word [byte edx+02h]
        mov si, word [byte eax+02h]
        cmp bx, si
        je short .10
        mov edx, ebx
        jmp short CmpRosterSkaters.5
.10:
        mov edx, dword [byte edx+0Eh]
        sar edx, 10h
        mov eax, dword [byte eax+0Eh]
        sar eax, 10h
.11:
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpRosterGoalies                             75A37  95 PC, medium confidence
; Qsort compare of goalie stat rows
;-----------------------------------------------------------------------------
; C: src/front/lines/CmpRosterGoalies.c
%ifdef CBUILD
%include "c/front/lines/CmpRosterGoalies.inc"
%else
CmpRosterGoalies:
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
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        mov ebx, dword [rostergstat]
        add eax, ebx
        jmp short .2
.1:
        mov ebx, dword [eax]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        mov ebx, dword [rostergstat]
        add eax, ebx
        add eax, byte 16h
.2:
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [edx]
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 2
        mov ebx, dword [rostergstat]
        add ebx, edx
        jmp short .4
.3:
        mov ebx, dword [edx]
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 2
        mov ebx, dword [rostergstat]
        add ebx, edx
        add ebx, byte 16h
.4:
        mov edx, ebx
        cmp word [byte ebx+0Ch], byte 0
        sete bl
        mov ecx, ebx
        and ecx, 0FFh
        mov si, word [byte eax+0Ch]
        test si, si
        sete bl
        and ebx, 0FFh
        xor ebx, ecx
        je short .5
        mov dx, word [byte edx+0Ch]
        jmp short .9
.5:
        mov bx, word [byte edx+010h]
        mov di, word [byte eax+010h]
        cmp bx, di
        je short .7
        xor ebx, ebx
        mov bx, di
        xor eax, eax
        mov ax, word [byte edx+010h]
.6:
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.7:
        mov bx, word [byte edx+0Ch]
        cmp bx, si
        je short .10
.8:
        mov edx, ebx
.9:
        and edx, 0FFFFh
        mov eax, esi
        jmp near .14
.10:
        mov bx, word [edx]
        mov si, word [eax]
        cmp bx, si
        jne short CmpRosterGoalies.8
        mov bx, word [byte edx+0Eh]
        mov di, word [byte eax+0Eh]
        cmp bx, di
        je short .11
        mov eax, edi
        and eax, 0FFFFh
        mov edx, ebx
        and edx, 0FFFFh
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.11:
        mov bx, word [byte edx+02h]
        mov cx, word [byte eax+02h]
        cmp bx, cx
        je short .12
        mov edx, ebx
        and edx, 0FFFFh
        mov eax, ecx
        jmp short .14
.12:
        mov bx, word [byte edx+04h]
        mov si, word [byte eax+04h]
        cmp bx, si
        je short .13
        xor ebx, ebx
        mov bx, si
        xor eax, eax
        mov ax, word [byte edx+04h]
        jmp near CmpRosterGoalies.6
.13:
        mov dx, word [byte edx+014h]
        and edx, 0FFFFh
        mov ax, word [byte eax+014h]
.14:
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; MenuRegSeasonStats                                              75BAA  95 PC
; "Regular Season Statistics ...": statsplayoffs = 0, ShowRosterStats
;-----------------------------------------------------------------------------
MenuRegSeasonStats:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        xor edx, edx
        mov dword [statsplayoffs], edx
MenuRegSeasonStats_common:
        mov ecx, 0C3h
        mov ebx, 0C2h
        mov edx, 0C1h
        mov eax, 0C0h
        call ShowRosterStats
        xor eax, eax
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; MenuPlayoffStats                                                75BDE  95 PC
; "Play-Off Statistics ...": statsplayoffs = 1, ShowRosterStats
;-----------------------------------------------------------------------------
MenuPlayoffStats:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov dword [statsplayoffs], 1
        jmp short MenuRegSeasonStats_common
%endif ; C
;-----------------------------------------------------------------------------
; ShowRosterStats                                                 75BF7  95 PC
; "%s Roster:" print-out: skaters (Pos No Name GP G A PT Shots PIM +/-) and
; goalies (GP Min GAA W L T GA SA PCT), sorted
;-----------------------------------------------------------------------------
ShowRosterStats:
        push dword 0C8h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 98h
        push eax
        push edx
        push ebx
        push ecx
        xor edx, edx
        mov dword [dword esp+0A0h], edx
        xor ebp, ebp
        jmp near .3
.1:
        xor eax, eax
        mov al, byte [lineedpanel]
        mov edx, dword [nosplit eax*4+rosterteamrec]
        mov eax, ebp
        shl eax, 2
        add eax, edx
        mov ecx, dword [byte eax+04Ch]
        cmp ecx, byte 0FFFFFFFFh
        je short .2
        mov eax, ecx
        call KeyDbPtr
        mov esi, ebp
        shl esi, 2
        sub esi, ebp
        shl esi, 2
        add esi, ebp
        shl esi, 2
        mov edi, dword [statsplayerbuf]
        add edi, esi
        mov ecx, 0Dh
        mov esi, eax
        rep movsd
        mov eax, dword [byte eax+028h]
        call CareerDbPtr
        mov edx, dword [dword esp+0A0h]
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        mov edi, dword [rosterpstat]
        add edi, ebx
        mov ecx, 0Ah
        mov esi, eax
        rep movsd
        mov dword [nosplit edx*4+statsskaterplr], ebp
        mov dword [nosplit edx*4+statsskaterorder], edx
        lea esi, [byte edx+01h]
        mov dword [dword esp+0A0h], esi
.2:
        inc ebp
.3:
        cmp ebp, byte 19h
        jl near ShowRosterStats.1
        xor ebx, ebx
        mov dword [dword esp+0A4h], ebx
        xor ebp, ebp
        jmp near .6
.4:
        xor eax, eax
        mov al, byte [lineedpanel]
        mov edx, dword [nosplit eax*4+rosterteamrec]
        mov eax, ebp
        shl eax, 2
        add eax, edx
        mov ebx, dword [dword eax+0B0h]
        cmp ebx, byte 0FFFFFFFFh
        je short .5
        mov eax, ebx
        call KeyDbPtr
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
        mov esi, eax
        rep movsd
        mov eax, dword [byte eax+028h]
        call CareerDbPtr2
        mov ebx, eax
        mov eax, dword [dword esp+0A4h]
        mov esi, eax
        shl esi, 2
        sub esi, eax
        shl esi, 2
        sub esi, eax
        shl esi, 2
        mov edi, dword [rostergstat]
        add edi, esi
        mov ecx, 0Bh
        mov esi, ebx
        rep movsd
        mov dword [nosplit eax*4+statsgoalieplr], edx
        mov dword [nosplit eax*4+statsgoalieorder], eax
        lea ecx, [byte eax+01h]
        mov dword [dword esp+0A4h], ecx
.5:
        inc ebp
.6:
        cmp ebp, byte 3
        jl near ShowRosterStats.4
        mov ecx, CmpRosterSkaters
        mov ebx, 4
        mov edx, dword [dword esp+0A0h]
        mov eax, statsskaterorder
        call qsort_
        mov ecx, CmpRosterGoalies
        mov ebx, 4
        mov edx, dword [dword esp+0A4h]
        mov eax, statsgoalieorder
        call qsort_
        mov edi, dword [fullscrbmp]
        push edi
        call SetDrawBitmap
        add esp, byte 4
        push byte 0
        call ClearScreen
        add esp, byte 4
        xor eax, eax
        mov al, byte [lineedpanel]
        mov ebp, dword [nosplit eax*4+rosterteamrec]
        push ebp
        push str_fmtEmb
        lea eax, [byte esp+058h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor ecx, ecx
        lea ebx, [byte esp+050h]
        xor eax, eax
        mov al, byte [lineedpanel]
        mov al, byte [dword eax+rosterteam]
        and eax, 0FFh
        cmp byte [dword eax+fileoncd+070h], 1
        jne short .7
        mov edx, dword [cddriveptr]
        jmp short .8
.7:
        xor edx, edx
.8:
        lea eax, [byte esp+078h]
        call MakePath
        push byte 0
        lea eax, [byte esp+07Ch]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push str_Bkgd2
        push eax
        call FindShape
        mov edi, eax
        add esp, byte 8
        push dword 1E0h
        push byte 13h
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push edi
        call DrawShape
        add esp, byte 4
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push esi
        call FreeMemBlock
        add esp, byte 4
        lea eax, [byte esp+010h]
        push eax
        call TextSaveState
        add esp, byte 4
        mov eax, dword [mainfont]
        push eax
        call TextSetFont
        add esp, byte 4
        mov edx, dword [byte esp+04h]
        push edx
        mov ecx, dword [byte esp+0Ch]
        mov ebx, dword [byte esp+010h]
        mov edx, 2
        mov eax, rosterstatsmenubar
        call DrawMenuBar
        mov edx, dword [esp]
        mov eax, dword [byte esp+0Ch]
        call SetTextColors
        xor eax, eax
        mov al, byte [lineedpanel]
        mov eax, dword [nosplit eax*4+rosterteamrec]
        add eax, byte 5
        push eax
        push str_SRoster
        lea eax, [byte esp+058h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [byte esp+050h]
        mov eax, 19h
        call PrintCenteredText
        mov ebx, str_Pos2
        mov edx, 30h
        mov eax, 14h
        call PrintShadowText
        mov ebx, str_No2
        mov edx, 30h
        mov eax, 42h
        call PrintShadowText
        mov ebx, str_Name2
        mov edx, 30h
        mov eax, 60h
        call PrintShadowText
        mov ebx, str_GP8
        mov edx, 30h
        mov eax, 10Eh
        call PrintShadowText
        mov ebx, str_G4
        mov edx, 30h
        mov eax, 136h
        call PrintShadowText
        mov ebx, str_A4
        mov edx, 30h
        mov eax, 15Eh
        call PrintShadowText
        mov ebx, str_PT2
        mov edx, 30h
        mov eax, 186h
        call PrintShadowText
        mov ebx, str_Shots4
        mov edx, 30h
        mov eax, 1AEh
        call PrintShadowText
        mov ebx, str_PIM4
        mov edx, 30h
        mov eax, 1E8h
        call PrintShadowText
        mov ebx, str_PlusMinus7
        mov edx, 30h
        mov eax, 210h
        call PrintShadowText
        xor ebp, ebp
        mov esi, 40h
        jmp near .13
.9:
        mov eax, dword [nosplit ebp*4+statsskaterorder]
        mov dword [dword esp+09Ch], eax
        mov eax, dword [nosplit eax*4+statsskaterplr]
        mov edi, eax
        shl edi, 2
        sub edi, eax
        shl edi, 2
        add edi, eax
        shl edi, 2
        mov eax, dword [statsplayerbuf]
        add edi, eax
        movsx eax, byte [byte edi+02h]
        push eax
        push str_C5
        lea eax, [byte esp+058h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [byte esp+050h]
        mov edx, esi
        mov eax, 14h
        call PrintShadowText
        mov dh, byte [byte edi+01h]
        cmp dh, 64h
        jae short .10
        xor ecx, ecx
        mov cl, dh
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 42h
        call PrintFmt1
.10:
        lea ebx, [byte edi+013h]
        lea edx, [byte edi+03h]
        mov ecx, 0A6h
        lea eax, [byte esp+050h]
        call FitPlayerName
        lea ebx, [byte esp+050h]
        mov edx, esi
        mov eax, 60h
        call PrintShadowText
        mov eax, dword [dword esp+09Ch]
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        shl ebx, 3
        cmp dword [statsplayoffs], byte 0
        jne short .11
        mov edi, dword [rosterpstat]
        add edi, ebx
        jmp short .12
.11:
        mov eax, dword [rosterpstat]
        add ebx, eax
        lea edi, [byte ebx+012h]
.12:
        xor ecx, ecx
        mov cx, word [edi]
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 10Eh
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+02h]
        mov ebx, str_fmt3d
        mov edx, esi
        mov eax, 136h
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+04h]
        mov ebx, str_fmt3d
        mov edx, esi
        mov eax, 15Eh
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+06h]
        mov ebx, str_fmt3d
        mov edx, esi
        mov eax, 186h
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+0Eh]
        mov ebx, str_fmt4d
        mov edx, esi
        mov eax, 1AEh
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+0Ch]
        mov ebx, str_fmt3d
        mov edx, esi
        mov eax, 1E8h
        call PrintFmt1
        mov ecx, dword [byte edi+0Eh]
        sar ecx, 10h
        mov ebx, str_fmt4d
        mov edx, esi
        mov eax, 210h
        call PrintFmt1
        add esi, byte 0Dh
        inc ebp
.13:
        cmp ebp, dword [dword esp+0A0h]
        jl near ShowRosterStats.9
        mov esi, 195h
        mov ebx, str_Pos2
        mov edx, esi
        mov eax, 14h
        call PrintShadowText
        mov ebx, str_No2
        mov edx, esi
        mov eax, 42h
        call PrintShadowText
        mov ebx, str_Name2
        mov edx, esi
        mov eax, 60h
        call PrintShadowText
        mov ebx, str_GP8
        mov edx, esi
        mov eax, 10Eh
        call PrintShadowText
        mov ebx, str_Min4
        mov edx, esi
        mov eax, 136h
        call PrintShadowText
        mov ebx, str_GAA4
        mov edx, esi
        mov eax, 15Eh
        call PrintShadowText
        mov ebx, str_W6
        mov edx, esi
        mov eax, 190h
        call PrintShadowText
        mov ebx, str_L8
        mov edx, esi
        mov eax, 1AEh
        call PrintShadowText
        cmp dword [statsplayoffs], byte 0
        jne short .14
        mov ebx, str_T6
        mov edx, esi
        mov eax, 1CCh
        call PrintShadowText
.14:
        mov ebx, str_GA3
        mov edx, esi
        mov eax, 1EAh
        call PrintShadowText
        mov ebx, str_SA3
        mov edx, esi
        mov eax, 20Eh
        call PrintShadowText
        mov ebx, str_PCT2
        mov edx, esi
        mov eax, 240h
        call PrintShadowText
        xor ebp, ebp
        add esi, byte 10h
        jmp near .20
.15:
        mov eax, dword [nosplit ebp*4+statsgoalieorder]
        mov dword [dword esp+09Ch], eax
        mov eax, dword [nosplit eax*4+statsgoalieplr]
        mov edi, eax
        shl edi, 2
        sub edi, eax
        shl edi, 2
        add eax, edi
        shl eax, 2
        mov edi, dword [statsplayerbuf]
        add edi, eax
        movsx eax, byte [byte edi+02h]
        push eax
        push str_C5
        lea eax, [byte esp+058h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [byte esp+050h]
        mov edx, esi
        mov eax, 14h
        call PrintShadowText
        mov bl, byte [byte edi+01h]
        cmp bl, 64h
        jae short .16
        xor ecx, ecx
        mov cl, bl
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 42h
        call PrintFmt1
.16:
        lea ebx, [byte edi+013h]
        lea edx, [byte edi+03h]
        mov ecx, 0A6h
        lea eax, [byte esp+050h]
        call FitPlayerName
        lea ebx, [byte esp+050h]
        mov edx, esi
        mov eax, 60h
        call PrintShadowText
        mov eax, dword [dword esp+09Ch]
        mov edi, eax
        shl edi, 2
        sub edi, eax
        shl edi, 2
        sub edi, eax
        shl edi, 2
        cmp dword [statsplayoffs], byte 0
        jne short .17
        mov eax, dword [rostergstat]
        add edi, eax
        jmp short .18
.17:
        mov eax, dword [rostergstat]
        add edi, eax
        add edi, byte 16h
.18:
        mov dword [dword esp+098h], edi
        xor ecx, ecx
        mov cx, word [edi]
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 10Eh
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+0Ch]
        mov ebx, str_fmt4d
        mov edx, esi
        mov eax, 136h
        call PrintFmt1
        xor ebx, ebx
        mov bx, word [byte edi+010h]
        mov ecx, 64h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        push edx
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov ecx, eax
        mov ebx, str_fmtMinSec
        mov edx, esi
        mov eax, 15Eh
        call PrintFmt2
        xor ecx, ecx
        mov cx, word [byte edi+02h]
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 190h
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+04h]
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 1AEh
        call PrintFmt1
        mov ecx, dword [statsplayoffs]
        test ecx, ecx
        jne short .19
        mov cx, word [byte edi+06h]
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 1CCh
        call PrintFmt1
.19:
        xor ecx, ecx
        mov eax, dword [dword esp+098h]
        mov cx, word [byte eax+0Eh]
        mov ebx, str_fmt3d
        mov edx, esi
        mov eax, 1EAh
        call PrintFmt1
        xor ecx, ecx
        mov eax, dword [dword esp+098h]
        mov cx, word [byte eax+012h]
        mov ebx, str_fmt4d
        mov edx, esi
        mov eax, 20Eh
        call PrintFmt1
        xor edi, edi
        mov eax, dword [dword esp+098h]
        mov di, word [byte eax+014h]
        mov ebx, 0Ah
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        push edx
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        mov ecx, eax
        mov ebx, str_fmtTenths
        mov edx, esi
        mov eax, 240h
        call PrintFmt2
        add esi, byte 0Dh
        inc ebp
.20:
        cmp ebp, dword [dword esp+0A4h]
        jl near ShowRosterStats.15
        call SetScreenTarget
        mov eax, dword [fullscrbmp]
        mov esi, dword [byte eax+02Ch]
        push esi
        call sub_9121C
        add esp, byte 4
        lea eax, [byte esp+010h]
        push eax
        call TextRestoreState
        add esp, byte 4
        xor eax, eax
        add esp, 0A8h
        pop ebp
        pop edi
        pop esi
        ret
