; Dialog boxes. Text entry, lists, buttons, scroll bars, and the messages they show.
bits 32
%include "hockey.inc"
section s_2FDD1 progbits alloc exec nowrite align=1
extern __CHK, boxfillcolor, boxlitecolor, boxshadecolor, byte_C4B6C, byte_D42C3, byte_D42C5, ClearInputQueue
extern criterrflag, dbchoicebtns, dbchoicelines, dbextension, dlgsavebuf, dlgsavex, dlgsavey, dlgtextbg
extern dlgtextfg, dword_C4B69, dword_D42AC, editbuf, editcuron, editcurw, editmaxw, editpos
extern editx, edity, fontcolor, fputchar, FreeMemBlock, GetInputEvent, InputInstall, InputRemove
extern listscroll, MouseSetPos, pointerspr, PollKey, PrintMenuText, PrintShadowText, ptrupdatefn, SetTextColors
extern SetTickDeadline, str_DBOX, str_Dot, str_extDB, str_ORG, str_Pointer6, str_Space, strlen_
extern AllocMemBlock, TextSetColors, PutBlock, TextWidthN, FillRect, sub_90EC0, sub_91044, DrawArt
extern GrabBlock, TextPrintAt, KeyDown, MouseRead, sub_B3D46, sub_B3D64, SetScreenTarget, FillRectColor
extern TickDeadlinePassed, unknown_libname_4
global AskDatabaseChoice, DrawBevelRect, DlgReturnZero, TextInputDialog, DlgNullCallback, SetListItemColors, ListHitTest, DrawListItem
global DrawListItem_x, DrawListItems, ListDialog, MeasureTextLine, SetDialogColors, TrackButtons, TrackButtons_x, DrawButtons
global DrawButton, DrawButton_x, InitScrollBar, DrawScrollBar, TrackScrollBars, SaveDialogBg, RestoreDialogBg, GrowToButton
global GrowToButtons, MessageBox, RunMessageBox, CritErrHandler, DrawEditCursor, DrawEditCursor_x, DrawEditCursor_ret, DrawEditText
global EditTextField
;-----------------------------------------------------------------------------
; AskDatabaseChoice                                               2FDD1  95 PC
; MessageBox "Do you wish to use your Current database or the Original NHL
; database?" (Current / Original); sets dbextension to ".ORG" or ".DB"
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/AskDatabaseChoice.c
%ifdef CBUILD
%include "c/pc/dialogs/AskDatabaseChoice.inc"
%else
AskDatabaseChoice:
        push dword 30h
        call __CHK
        push ebx
        push ecx
        push edx
        sub esp, byte 0Ch
        mov eax, esp
        push eax
        lea eax, [byte esp+08h]
        push eax
        lea eax, [byte esp+010h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+04h]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        push byte 2
        push dbchoicebtns
        mov ecx, 3
        mov ebx, dbchoicelines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [byte esp+08h], eax
        cmp eax, byte 1
        jne short .1
        mov dword [dbextension], str_ORG
        jmp short .2
.1:
        mov dword [dbextension], str_extDB
.2:
        mov eax, dword [byte esp+08h]
        add esp, byte 0Ch
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawBevelRect                                                   2FE49  95 PC
; (x, y, w, h, fill, lite, shade): fills the rect and draws the lit top/left
; and shaded bottom/right edges
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/DrawBevelRect.c
%ifdef CBUILD
%include "c/pc/dialogs/DrawBevelRect.inc"
%else
DrawBevelRect:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov esi, edx
        lea ebp, [byte eax+ebx-01h]
        mov dword [esp], ebp
        lea ebp, [byte edx+ecx-01h]
        mov edx, dword [byte esp+014h]
        push edx
        push ecx
        push ebx
        push esi
        push eax
        call FillRect
        add esp, byte 14h
        mov ebx, dword [byte esp+018h]
        push ebx
        push ebp
        push edi
        push esi
        push edi
        call FillRectColor
        add esp, byte 14h
        mov ecx, dword [byte esp+018h]
        push ecx
        push esi
        mov eax, dword [byte esp+08h]
        push eax
        push esi
        push edi
        call FillRectColor
        add esp, byte 14h
        mov edx, dword [byte esp+01Ch]
        push edx
        push ebp
        mov ebx, dword [byte esp+08h]
        push ebx
        push ebp
        push edi
        call FillRectColor
        add esp, byte 14h
        mov ecx, dword [byte esp+01Ch]
        push ecx
        push ebp
        mov edi, dword [byte esp+08h]
        push edi
        push esi
        push edi
        call FillRectColor
        add esp, byte 14h
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret 0Ch
%endif ; C
;-----------------------------------------------------------------------------
; DlgReturnZero                                                   2FED2  95 PC
; Returns 0; passed as a callback by database_dialogs
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/DlgReturnZero.c
%ifdef CBUILD
%include "c/pc/dialogs/DlgReturnZero.inc"
%else
DlgReturnZero:
        push dword 4
        call __CHK
        xor eax, eax
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TextInputDialog                                                 2FEDF  95 PC
; (prompt, buf, maxlen, width, ...): DBOX prompt box with an EditTextField;
; used for "Enter league name" and league_setup names
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/TextInputDialog.c
%ifdef CBUILD
%include "c/pc/dialogs/TextInputDialog.inc"
%else
TextInputDialog:
        push dword 138h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 114h
        push eax
        mov esi, edx
        mov edi, ebx
        mov ebp, ecx
        call InputRemove
        call SetScreenTarget
        xor edx, edx
        mov bl, 4Dh
        jmp short .2
.1:
        mov byte [byte esp+edx+04h], bl
        inc edx
.2:
        cmp edx, edi
        jl short TextInputDialog.1
        xor ah, ah
        mov byte [byte esp+edi+04h], ah
        lea eax, [byte esp+04h]
        push eax
        call fputchar
        add esp, byte 4
        mov dword [dword esp+0114h], eax
        cmp eax, ebp
        jge short .3
        mov dword [dword esp+0114h], ebp
.3:
        mov edx, dword [esp]
        push edx
        add dword [dword esp+0118h], byte 0Ch
        call fputchar
        add esp, byte 4
        lea ebp, [byte eax+010h]
        mov ecx, dword [dword esp+0114h]
        cmp ebp, ecx
        jge short .4
        lea ebp, [byte ecx+010h]
.4:
        xor eax, eax
        mov al, byte [byte_D42C3]
        add eax, eax
        add eax, byte 20h
        mov dword [dword esp+0104h], eax
        mov edx, 280h
        sub edx, ebp
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+0110h], eax
        mov edx, 1E0h
        mov eax, dword [dword esp+0104h]
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+010Ch], eax
        mov ecx, dword [dword esp+0104h]
        mov ebx, ebp
        mov edx, eax
        mov eax, dword [dword esp+0110h]
        call SaveDialogBg
        mov edx, dword [dlgtextbg]
        mov eax, dword [dlgtextfg]
        call SetTextColors
        mov edx, dword [boxshadecolor]
        push edx
        mov ebx, dword [boxlitecolor]
        push ebx
        mov ecx, dword [boxfillcolor]
        push ecx
        mov ecx, dword [dword esp+0110h]
        mov ebx, ebp
        mov edx, dword [dword esp+0118h]
        mov eax, dword [dword esp+011Ch]
        call DrawBevelRect
        mov eax, dword [dlgtextbg]
        push eax
        mov edx, dword [dlgtextfg]
        push edx
        call TextSetColors
        add esp, byte 8
        mov eax, dword [dword esp+010Ch]
        add eax, byte 7
        mov dword [dword esp+0108h], eax
        mov ebx, dword [esp]
        push ebx
        call fputchar
        add esp, byte 4
        mov edx, ebp
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov ecx, dword [dword esp+0110h]
        add eax, ecx
        mov ebx, dword [esp]
        mov edx, dword [dword esp+0108h]
        call PrintShadowText
        mov eax, dword [dword esp+0114h]
        mov edx, ebp
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea edx, [ecx+eax]
        mov dword [dword esp+0110h], edx
        mov ebx, dword [boxlitecolor]
        push ebx
        mov ecx, dword [boxshadecolor]
        push ecx
        mov ebp, dword [dlgtextbg]
        push ebp
        mov edx, dword [dword esp+0118h]
        add edx, byte 1Fh
        mov ecx, 12h
        mov ebx, dword [dword esp+0120h]
        mov eax, dword [dword esp+011Ch]
        call DrawBevelRect
        mov eax, dword [dlgtextbg]
        push eax
        mov edx, dword [dlgtextfg]
        push edx
        call TextSetColors
        add esp, byte 8
.5:
        push byte 1
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short TextInputDialog.5
        push byte 1Ch
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short TextInputDialog.5
        call ClearInputQueue
        cmp dword [dword esp+0128h], byte 0
        je near .11
.6:
        mov byte [esi], 0
        mov ecx, dword [dword esp+0138h]
        push ecx
        push byte 0
        push DlgReturnZero
        mov eax, dword [dword esp+0118h]
        add eax, byte 20h
        push eax
        mov ecx, dword [dword esp+0120h]
        add ecx, byte 6
        mov ebx, dword [dword esp+0124h]
        sub ebx, byte 8
        mov edx, edi
        mov eax, esi
        call EditTextField
        xor ebp, ebp
        xor edx, edx
        jmp short .9
.7:
        mov al, byte [edx+esi]
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        jne short .8
        mov ch, byte [esi]
        cmp ch, 20h
        je short .8
        test ch, ch
        je short .8
        cmp ch, 2Dh
        jne short .10
.8:
        mov eax, esi
        call unknown_libname_4
        mov ebp, eax
        inc edx
.9:
        cmp edx, edi
        jl short TextInputDialog.7
.10:
        cmp ebp, dword [dword esp+012Ch]
        jl short TextInputDialog.6
        cmp ebp, dword [dword esp+0130h]
        jg near TextInputDialog.6
        jmp short .13
.11:
        mov byte [esi], 0
        mov ecx, dword [dword esp+0138h]
        push ecx
        push byte 0
        push DlgReturnZero
        mov eax, dword [dword esp+0118h]
        add eax, byte 20h
        push eax
        mov ecx, dword [dword esp+0120h]
        add ecx, byte 6
        mov ebx, dword [dword esp+0124h]
        sub ebx, byte 8
        mov edx, edi
        mov eax, esi
        call EditTextField
        mov ebp, eax
        mov edx, 1
        cmp dword [dword esp+0134h], byte 0
        je short .12
        cmp byte [esi], 0
        jne short .12
        cmp eax, byte 1Bh
        je short .12
        xor edx, edx
.12:
        test edx, edx
        je short TextInputDialog.11
.13:
        push byte 1
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short TextInputDialog.13
        push byte 1Ch
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short TextInputDialog.13
        call ClearInputQueue
        call RestoreDialogBg
        call InputInstall
        mov eax, ebp
        add esp, 118h
;-----------------------------------------------------------------------------
; DlgNullCallback                                                 30203  95 PC
; Empty stdcall stub (ret 14h)
;-----------------------------------------------------------------------------
DlgNullCallback:
        pop ebp
        pop edi
        pop esi
        ret 14h
%endif ; C
;-----------------------------------------------------------------------------
; SetListItemColors                            30209  95 PC, medium confidence
; (item, sel): text colours dlgtextfg/dlgtextbg, swapped for the selected
; item
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/SetListItemColors.c
%ifdef CBUILD
%include "c/pc/dialogs/SetListItemColors.inc"
%else
SetListItemColors:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        cmp edx, eax
        jne short .1
        mov edx, dword [dlgtextbg]
        mov eax, dword [dlgtextfg]
        jmp short .2
.1:
        mov edx, dword [dlgtextfg]
        mov eax, dword [dlgtextbg]
.2:
        push eax
        push edx
        call TextSetColors
        add esp, byte 8
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ListHitTest                                                     3023E  95 PC
; (mx, my, x, y, w, count): row under the mouse or -1 (row height font height
; + 2)
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/ListHitTest.c
%ifdef CBUILD
%include "c/pc/dialogs/ListHitTest.inc"
%else
ListHitTest:
        push dword 18h
        call __CHK
        push esi
        push edi
        sub esp, byte 0Ch
        mov esi, eax
        mov edi, edx
        mov dword [byte esp+08h], ecx
        mov eax, dword [byte esp+018h]
        lea edx, [byte ecx+02h]
        mov dword [byte esp+08h], edx
        add ebx, byte 2
        mov dword [esp], ebx
        sub eax, byte 4
        add ebx, eax
        mov dword [byte esp+04h], ebx
        mov ecx, 0FFFFFFFFh
        xor eax, eax
        jmp short .3
.1:
        xor edx, edx
        mov dl, byte [byte_D42C3]
        lea ebx, [byte edx+02h]
        imul ebx, eax
        add ebx, dword [byte esp+08h]
        add edx, ebx
        add edx, byte 2
        cmp esi, dword [esp]
        jl short .2
        cmp esi, dword [byte esp+04h]
        jg short .2
        cmp edi, ebx
        jl short .2
        cmp edi, edx
        jg short .2
        mov ecx, eax
.2:
        inc eax
.3:
        cmp eax, dword [byte esp+01Ch]
        jge short .4
        test ecx, ecx
        jl short ListHitTest.1
.4:
        mov eax, ecx
        add esp, byte 0Ch
        pop edi
        pop esi
        ret 8
%endif ; C
;-----------------------------------------------------------------------------
; DrawListItem                                 302B9  95 PC, medium confidence
; Fills one list row (disabled rows in boxfillcolor) and prints its text left
; / right / centred
;-----------------------------------------------------------------------------
DrawListItem:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        push eax
        mov esi, edx
        mov edi, ebx
        mov ebp, ecx
        xor edx, edx
        mov dl, byte [byte_D42C3]
        mov eax, dword [byte esp+018h]
        sub eax, dword [byte esp+014h]
        add edx, byte 2
        imul eax, edx
        add eax, byte 2
        add edi, eax
        add esi, byte 2
        lea ebp, [byte ecx-04h]
        cmp dword [byte esp+024h], byte 0
        je short .1
        mov edx, dword [byte esp+028h]
        add edx, dword [byte esp+018h]
        cmp byte [edx], 0
        je short .1
        mov edx, dword [boxfillcolor]
        jmp short .3
.1:
        mov eax, dword [byte esp+01Ch]
        cmp eax, dword [byte esp+018h]
        jne short .2
        mov edx, dword [dlgtextfg]
        jmp short .3
.2:
        mov edx, dword [dlgtextbg]
.3:
        push edx
        xor eax, eax
        mov al, byte [byte_D42C3]
        add eax, byte 2
        push eax
        push ebp
        push edi
        push esi
        call FillRect
        add esp, byte 14h
        mov edx, dword [byte esp+01Ch]
        mov eax, dword [byte esp+018h]
        call SetListItemColors
        mov ebx, dword [byte esp+020h]
        cmp ebx, byte 1
        jb short .7
        jbe short .4
        cmp ebx, byte 2
        je short .5
        jmp short .7
.4:
        mov ebx, dword [esp]
        push ebx
        call fputchar
        add esp, byte 4
        sub ebp, eax
        lea eax, [byte ebp-04h]
        jmp short .6
.5:
        mov edx, dword [esp]
        push edx
        call fputchar
        add esp, byte 4
        mov edx, ebp
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
.6:
        add esi, eax
.7:
        lea edx, [byte edi+01h]
        mov ebx, dword [esp]
        mov eax, esi
        call PrintMenuText
        add esp, byte 4
DrawListItem_x:
        pop ebp
        pop edi
        pop esi
        ret 18h
;-----------------------------------------------------------------------------
; DrawListItems                                3039C  95 PC, medium confidence
; DrawListItem for each visible row
;-----------------------------------------------------------------------------
DrawListItems:
        push dword 30h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        push eax
        mov ebp, edx
        mov edi, ebx
        mov dword [byte esp+04h], ecx
        xor esi, esi
        jmp short .2
.1:
        mov ebx, dword [byte esp+02Ch]
        push ebx
        mov ecx, dword [byte esp+02Ch]
        push ecx
        mov eax, dword [byte esp+02Ch]
        push eax
        mov edx, dword [byte esp+028h]
        push edx
        mov eax, dword [byte esp+028h]
        add eax, esi
        push eax
        mov ebx, dword [byte esp+02Ch]
        push ebx
        shl eax, 2
        add eax, dword [byte esp+018h]
        mov eax, dword [eax]
        mov ecx, dword [byte esp+01Ch]
        mov ebx, edi
        mov edx, ebp
        call DrawListItem
        inc esi
.2:
        cmp esi, dword [byte esp+020h]
        jl short DrawListItems.1
        add esp, byte 8
        jmp short DrawListItem_x
;-----------------------------------------------------------------------------
; ListDialog                                                      303FB  95 PC
; (items, count, title, ...): DBOX list box with scroll bar; returns the
; chosen item ("Choose which team to ...", league_setup, highlights)
;-----------------------------------------------------------------------------
ListDialog:
        push dword 84h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 58h
        push eax
        mov esi, edx
        mov dword [byte esp+01Ch], ebx
        mov dword [byte esp+038h], ecx
        call SetScreenTarget
        xor edx, edx
        mov dword [byte esp+034h], edx
        mov dword [byte esp+054h], edx
        xor ebp, ebp
        cmp dword [byte esp+06Ch], byte 0
        je short .1
        mov ebp, 0FFFFFFFFh
.1:
        mov dword [byte esp+03Ch], esi
        cmp esi, byte 14h
        jle short .2
        mov dword [byte esp+03Ch], 14h
.2:
        mov edx, dword [byte esp+01Ch]
        push edx
        call fputchar
        add esp, byte 4
        mov dword [byte esp+04Ch], eax
        xor ebx, ebx
        mov dword [byte esp+014h], ebx
        jmp short .6
.3:
        cmp dword [byte esp+06Ch], byte 0
        je short .4
        mov eax, dword [byte esp+070h]
        add eax, ecx
        mov byte [eax], 0
.4:
        mov eax, dword [byte esp+014h]
        shl eax, 2
        add eax, dword [esp]
        mov edx, dword [eax]
        push edx
        call fputchar
        add esp, byte 4
        mov edi, eax
        cmp eax, dword [byte esp+04Ch]
        jle short .5
        mov dword [byte esp+04Ch], eax
.5:
        inc dword [byte esp+014h]
.6:
        mov ecx, dword [byte esp+014h]
        cmp esi, ecx
        jg short ListDialog.3
        mov eax, dword [byte esp+04Ch]
        add eax, byte 9
        mov dword [byte esp+04Ch], eax
        cmp edi, eax
        jle short .7
        mov dword [byte esp+04Ch], edi
.7:
        mov ebx, dword [byte esp+01Ch]
        push ebx
        call fputchar
        add esp, byte 4
        mov edi, eax
        xor eax, eax
        mov al, byte [byte_D42C3]
        add eax, byte 2
        mov ecx, dword [byte esp+03Ch]
        imul eax, ecx
        add eax, byte 4
        mov dword [byte esp+020h], eax
        mov edx, 280h
        sub edx, dword [byte esp+04Ch]
        sub edx, byte 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [byte esp+030h], eax
        mov edx, 1E0h
        mov ebx, dword [byte esp+020h]
        sub edx, ebx
        sub edx, byte 20h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [byte esp+02Ch], eax
        mov eax, dword [byte esp+04Ch]
        add eax, byte 10h
        mov dword [byte esp+028h], eax
        lea eax, [byte ebx+020h]
        mov dword [byte esp+024h], eax
        mov eax, dword [byte esp+030h]
        add eax, byte 8
        mov dword [byte esp+048h], eax
        mov eax, dword [byte esp+02Ch]
        add eax, byte 18h
        mov dword [byte esp+040h], eax
        cmp esi, ecx
        jle near .8
        mov dword [byte esp+034h], 0FFFFFFFFh
        sub dword [byte esp+048h], byte 0Ah
        mov ebx, dword [byte esp+030h]
        sub ebx, byte 0Ah
        mov dword [byte esp+030h], ebx
        mov ecx, dword [byte esp+028h]
        lea eax, [ebx+ecx]
        mov dword [listscroll], eax
        mov eax, dword [byte esp+02Ch]
        mov dword [listscroll+4], eax
        mov dword [listscroll+8], 0Ah
        mov eax, dword [byte esp+024h]
        mov dword [listscroll+0Ch], eax
        mov ebx, esi
        mov edx, dword [byte esp+03Ch]
        mov eax, listscroll
        call InitScrollBar
        xor edx, edx
        mov dword [listscroll+20h], edx
        mov eax, dword [listscroll+0Ch]
        sub eax, byte 4
        imul eax, edx
        mov ebx, dword [listscroll+28h]
        div ebx
        mov dword [listscroll+14h], eax
        lea ebx, [byte ecx+0Ah]
        mov ecx, dword [byte esp+024h]
        mov edx, dword [byte esp+02Ch]
        mov eax, dword [byte esp+030h]
        call SaveDialogBg
        mov eax, listscroll
        call DrawScrollBar
        jmp short .9
.8:
        mov ecx, dword [byte esp+024h]
        mov ebx, dword [byte esp+028h]
        mov edx, dword [byte esp+02Ch]
        mov eax, dword [byte esp+030h]
        call SaveDialogBg
.9:
        mov ebx, dword [boxshadecolor]
        push ebx
        mov ecx, dword [boxlitecolor]
        push ecx
        mov esi, dword [boxfillcolor]
        push esi
        mov ecx, dword [byte esp+030h]
        mov ebx, dword [byte esp+034h]
        mov edx, dword [byte esp+038h]
        mov eax, dword [byte esp+03Ch]
        call DrawBevelRect
        mov edx, dword [dlgtextbg]
        mov eax, dword [dlgtextfg]
        call SetTextColors
        mov ecx, dword [byte esp+02Ch]
        add ecx, byte 6
        mov edx, dword [byte esp+028h]
        sub edx, edi
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, dword [byte esp+030h]
        mov ebx, dword [byte esp+01Ch]
        mov edx, ecx
        call PrintShadowText
        mov eax, dword [boxlitecolor]
        push eax
        mov edx, dword [boxshadecolor]
        push edx
        mov ebx, dword [dlgtextbg]
        push ebx
        mov ecx, dword [byte esp+02Ch]
        mov ebx, dword [byte esp+058h]
        mov edx, dword [byte esp+04Ch]
        mov eax, dword [byte esp+054h]
        call DrawBevelRect
        mov ecx, dword [byte esp+070h]
        push ecx
        mov esi, dword [byte esp+070h]
        push esi
        mov edi, dword [byte esp+040h]
        push edi
        mov eax, dword [byte esp+048h]
        push eax
        push ebp
        mov edx, dword [byte esp+068h]
        push edx
        mov ecx, dword [byte esp+064h]
        mov ebx, dword [byte esp+058h]
        mov edx, dword [byte esp+060h]
        mov eax, dword [byte esp+018h]
        call DrawListItems
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
        push str_Pointer6
        call AllocMemBlock
        mov dword [byte esp+024h], eax
        add esp, byte 0Ch
        mov dword [byte esp+044h], eax
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
        mov edx, dword [byte esp+018h]
        mov word [byte edx+04h], ax
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+06h]
        inc eax
        mov word [byte edx+06h], ax
        lea eax, [byte esp+0Ch]
        push eax
        lea eax, [byte esp+014h]
        push eax
        lea eax, [byte esp+01Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov eax, dword [byte esp+010h]
        mov dword [byte esp+08h], eax
        mov eax, dword [byte esp+0Ch]
        mov dword [byte esp+04h], eax
        push eax
        mov ecx, dword [byte esp+014h]
        push ecx
        mov esi, dword [byte esp+020h]
        push esi
        call GrabBlock
        add esp, byte 0Ch
        mov edi, dword [byte esp+0Ch]
        push edi
        mov eax, dword [byte esp+014h]
        push eax
        mov edx, dword [pointerspr]
        push edx
        call DrawArt
        add esp, byte 0Ch
        call ClearInputQueue
        xor esi, esi
.10:
        xor edi, edi
        mov dword [byte esp+058h], edi
.11:
        call GetInputEvent
        mov ecx, eax
        test eax, eax
        je short .12
        lea ebx, [byte esp+04h]
        lea edx, [byte esp+08h]
        call dword [ptrupdatefn]
        mov dword [byte esp+058h], eax
.12:
        test ecx, ecx
        je short .13
        test byte [byte esp+058h], 2
        je short ListDialog.11
.13:
        cmp dword [byte esp+058h], byte 0
        jne short .15
        mov eax, dword [byte esp+08h]
        cmp eax, dword [byte esp+010h]
        jne short .14
        mov eax, dword [byte esp+04h]
        cmp eax, dword [byte esp+0Ch]
        je near .26
.14:
        mov ecx, dword [byte esp+0Ch]
        push ecx
        mov edi, dword [byte esp+014h]
        push edi
        mov eax, dword [byte esp+04Ch]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [byte esp+04h]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        mov ecx, dword [byte esp+04Ch]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
        mov edi, dword [byte esp+04h]
        push edi
        mov eax, dword [byte esp+0Ch]
        push eax
        mov edx, dword [pointerspr]
        push edx
        jmp near .25
.15:
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+014h]
        push ebx
        mov ecx, dword [byte esp+04Ch]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        test byte [byte esp+058h], 2
        je near .23
        mov edi, dword [byte esp+03Ch]
        push edi
        mov eax, dword [byte esp+050h]
        push eax
        mov ecx, dword [byte esp+048h]
        mov ebx, dword [byte esp+050h]
        mov edx, dword [byte esp+0Ch]
        mov eax, dword [byte esp+010h]
        call ListHitTest
        mov dword [byte esp+014h], eax
        test eax, eax
        jl near .19
        mov dword [byte esp+050h], ebp
        mov ebp, dword [byte esp+054h]
        add ebp, eax
        cmp dword [byte esp+06Ch], byte 0
        je short .17
        cmp ebp, dword [byte esp+050h]
        jne short .16
        mov eax, dword [byte esp+070h]
        cmp byte [eax+ebp], 0
        jne short .17
.16:
        mov eax, dword [byte esp+070h]
        mov dl, byte [eax+ebp]
        not dl
        mov byte [eax+ebp], dl
.17:
        mov ecx, dword [byte esp+050h]
        test ecx, ecx
        jl short .18
        mov edi, dword [byte esp+054h]
        cmp ecx, edi
        jl short .18
        mov edx, dword [byte esp+03Ch]
        lea eax, [edi+edx]
        cmp eax, ecx
        jle short .18
        mov ecx, dword [byte esp+070h]
        push ecx
        mov edi, dword [byte esp+070h]
        push edi
        mov eax, dword [byte esp+040h]
        push eax
        push ebp
        mov edx, dword [byte esp+060h]
        push edx
        mov ebx, dword [byte esp+068h]
        push ebx
        mov eax, edx
        shl eax, 2
        add eax, dword [byte esp+018h]
        mov eax, dword [eax]
        mov ecx, dword [byte esp+064h]
        mov ebx, dword [byte esp+058h]
        mov edx, dword [byte esp+060h]
        call DrawListItem
.18:
        mov edi, dword [byte esp+070h]
        push edi
        mov eax, dword [byte esp+070h]
        push eax
        mov edx, dword [byte esp+040h]
        push edx
        push ebp
        push ebp
        mov ebx, dword [byte esp+068h]
        push ebx
        mov eax, ebp
        shl eax, 2
        add eax, dword [byte esp+018h]
        mov eax, dword [eax]
        mov ecx, dword [byte esp+064h]
        mov ebx, dword [byte esp+058h]
        mov edx, dword [byte esp+060h]
        call DrawListItem
.19:
        cmp ebp, dword [byte esp+050h]
        jne short .23
        cmp dword [byte esp+06Ch], byte 0
        je short .20
        mov eax, dword [byte esp+070h]
        cmp byte [eax+ebp], 0
        je short .21
.20:
        mov eax, 1
        jmp short .22
.21:
        xor eax, eax
.22:
        test eax, eax
        je short .23
        mov esi, 1
.23:
        cmp dword [byte esp+034h], byte 0
        je short .24
        mov ebx, dword [byte esp+058h]
        push ebx
        mov ecx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        mov edx, 1
        mov eax, listscroll
        call TrackScrollBars
        test eax, eax
        jl short .24
        mov eax, dword [byte esp+054h]
        mov ecx, dword [listscroll+20h]
        cmp eax, ecx
        je short .24
        mov dword [byte esp+054h], ecx
        mov edi, dword [byte esp+070h]
        push edi
        mov eax, dword [byte esp+070h]
        push eax
        mov edx, dword [byte esp+040h]
        push edx
        mov ebx, dword [byte esp+048h]
        push ebx
        push ebp
        push ecx
        mov ecx, dword [byte esp+064h]
        mov ebx, dword [byte esp+058h]
        mov edx, dword [byte esp+060h]
        mov eax, dword [byte esp+018h]
        call DrawListItems
.24:
        mov edi, dword [byte esp+04h]
        push edi
        mov eax, dword [byte esp+0Ch]
        push eax
        mov edx, dword [byte esp+04Ch]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+04h]
        push ebx
        mov ecx, dword [byte esp+0Ch]
        push ecx
        mov edi, dword [pointerspr]
        push edi
.25:
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+08h]
        mov dword [byte esp+010h], eax
        mov eax, dword [byte esp+04h]
        mov dword [byte esp+0Ch], eax
.26:
        test esi, esi
        je near ListDialog.10
        mov ebx, dword [byte esp+0Ch]
        push ebx
        mov ecx, dword [byte esp+014h]
        push ecx
        mov esi, dword [byte esp+04Ch]
        push esi
        call PutBlock
        add esp, byte 0Ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        call RestoreDialogBg
        mov eax, ebp
        add esp, byte 5Ch
        pop ebp
        pop edi
        pop esi
        ret 8
;-----------------------------------------------------------------------------
; MeasureTextLine                                                 309E4  95 PC
; (str, &maxw, &h, lineh): widens maxw to the text width and adds lineh to h
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/MeasureTextLine.c
%ifdef CBUILD
%include "c/pc/dialogs/MeasureTextLine.inc"
%else
MeasureTextLine:
        push dword 14h
        call __CHK
        push esi
        push edi
        push ebp
        mov edi, edx
        mov esi, ebx
        mov ebp, ecx
        push eax
        call fputchar
        add esp, byte 4
        cmp eax, dword [edi]
        jle short .1
        mov dword [edi], eax
.1:
        add dword [esi], ebp
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetDialogColors                                                 30A0C  95 PC
; Sets boxfillcolor / boxlitecolor / boxshadecolor and dlgtextfg / dlgtextbg
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/SetDialogColors.c
%ifdef CBUILD
%include "c/pc/dialogs/SetDialogColors.inc"
%else
SetDialogColors:
        push dword 4
        call __CHK
        mov dword [boxfillcolor], eax
        mov dword [boxlitecolor], edx
        mov dword [boxshadecolor], ebx
        mov dword [dlgtextfg], ecx
        mov eax, dword [byte esp+04h]
        mov dword [dlgtextbg], eax
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; TrackButtons                                                    30A39  95 PC
; (btns, n, mx, my, flags): presses / releases 1Ch-byte buttons under the
; mouse, returns the clicked index
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/TrackButtons.c
%ifdef CBUILD
%include "c/pc/dialogs/TrackButtons.inc"
%else
TrackButtons:
        push dword 14h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov dword [esp], edx
        mov edi, ebx
        mov ebp, 0FFFFFFFFh
        xor edx, edx
        jmp near .6
.1:
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        add eax, esi
        mov ebx, dword [eax]
        cmp edi, ebx
        jl short .3
        add ebx, dword [byte eax+08h]
        cmp edi, ebx
        jge short .3
        mov ebx, dword [byte eax+04h]
        cmp ecx, ebx
        jl short .3
        add ebx, dword [byte eax+0Ch]
        cmp ecx, ebx
        jge short .3
        cmp dword [byte eax+010h], byte 0
        jne short .2
        test byte [byte esp+014h], 1
        je short .2
        mov dword [byte eax+010h], 0FFFFFFFFh
        call DrawButton
.2:
        test byte [byte esp+014h], 2
        je short .5
        mov ebp, edx
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        add eax, esi
        jmp short .4
.3:
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        add eax, esi
        cmp dword [byte eax+010h], byte 0
        je short .5
.4:
        mov dword [byte eax+010h], 0
        call DrawButton
.5:
        inc edx
.6:
        cmp edx, dword [esp]
        jl short TrackButtons.1
        mov eax, ebp
        add esp, byte 4
TrackButtons_x:
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; DrawButtons                                                     30AE2  95 PC
; Clears the pressed flag and draws each button
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/TrackButtons.c (DrawButtons)
%ifdef CBUILD
%include "c/pc/dialogs/TrackButtons.DrawButtons.inc"
%else
DrawButtons:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        mov esi, eax
        mov ecx, edx
        xor edx, edx
        jmp short .2
.1:
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        add eax, esi
        mov dword [byte eax+010h], 0
        call DrawButton
        inc edx
.2:
        cmp edx, ecx
        jl short DrawButtons.1
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawButton                                                      30B16  95 PC
; Bevel box (lite / shade swapped when pressed) with the label centred
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/TrackButtons.c (DrawButton)
%ifdef CBUILD
%include "c/pc/dialogs/TrackButtons.DrawButton.inc"
%else
DrawButton:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov esi, eax
        cmp dword [byte eax+010h], byte 0
        je short .1
        mov eax, dword [boxshadecolor]
        mov ebx, dword [boxlitecolor]
        xor ebx, eax
        mov dword [boxlitecolor], ebx
        mov ecx, eax
        xor ecx, ebx
        mov dword [boxshadecolor], ecx
        mov edi, ebx
        xor edi, ecx
        mov dword [boxlitecolor], edi
.1:
        mov ebp, dword [boxshadecolor]
        push ebp
        mov eax, dword [boxlitecolor]
        push eax
        mov edx, dword [boxfillcolor]
        push edx
        mov ecx, dword [byte esi+0Ch]
        mov ebx, dword [byte esi+08h]
        mov edx, dword [byte esi+04h]
        mov eax, dword [esi]
        call DrawBevelRect
        cmp dword [byte esi+010h], byte 0
        je short .2
        mov eax, dword [boxshadecolor]
        mov ecx, dword [boxlitecolor]
        xor ecx, eax
        mov dword [boxlitecolor], ecx
        mov edi, eax
        xor edi, ecx
        mov dword [boxshadecolor], edi
        mov ebp, ecx
        xor ebp, edi
        mov dword [boxlitecolor], ebp
.2:
        mov eax, dword [byte esi+018h]
        test eax, eax
        je short DrawButton_x
        mov edi, eax
        xor edx, edx
        mov dl, byte [byte_D42C3]
        mov eax, dword [byte esi+0Ch]
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov ebp, dword [byte esi+04h]
        add ebp, eax
        push edi
        call fputchar
        add esp, byte 4
        mov edx, dword [byte esi+08h]
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, dword [esi]
        mov ebx, edi
        mov edx, ebp
        call PrintShadowText
DrawButton_x:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; InitScrollBar                                30BF3  95 PC, medium confidence
; (sb, pos, range): sets the scroll-bar thumb size and clears its state
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/TrackButtons.c (InitScrollBar)
%ifdef CBUILD
%include "c/pc/dialogs/TrackButtons.InitScrollBar.inc"
%else
InitScrollBar:
        push dword 8
        call __CHK
        push ecx
        mov ecx, eax
        mov dword [byte eax+028h], ebx
        mov dword [byte eax+024h], edx
        mov dword [byte eax+020h], 0
        mov dword [byte eax+010h], 0
        mov dword [byte eax+014h], 0
        mov edx, dword [byte eax+08h]
        sub edx, byte 4
        mov dword [byte eax+018h], edx
        mov edx, dword [byte eax+0Ch]
        sub edx, byte 4
        imul edx, dword [byte eax+024h]
        mov ebx, dword [byte eax+028h]
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [byte ecx+01Ch], eax
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawScrollBar                                30C3D  95 PC, medium confidence
; Trough and thumb bevel boxes (inverted while dragged)
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/TrackButtons.c (DrawScrollBar)
%ifdef CBUILD
%include "c/pc/dialogs/TrackButtons.DrawScrollBar.inc"
%else
DrawScrollBar:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov esi, eax
        mov edi, dword [eax]
        mov ebp, dword [byte eax+04h]
        mov edx, dword [boxshadecolor]
        push edx
        mov ebx, dword [boxlitecolor]
        push ebx
        mov ecx, dword [boxfillcolor]
        push ecx
        mov ecx, dword [byte eax+0Ch]
        mov ebx, dword [byte eax+08h]
        mov edx, ebp
        mov eax, edi
        call DrawBevelRect
        cmp dword [byte esi+02Ch], byte 0
        je short .1
        mov ebx, dword [boxshadecolor]
        mov edx, dword [boxlitecolor]
        xor edx, ebx
        mov dword [boxlitecolor], edx
        mov ecx, ebx
        xor ecx, edx
        mov dword [boxshadecolor], ecx
        mov eax, edx
        xor eax, ecx
        mov dword [boxlitecolor], eax
.1:
        mov ebx, dword [byte esi+010h]
        add ebx, byte 2
        lea eax, [edi+ebx]
        mov ebx, dword [byte esi+014h]
        add ebx, byte 2
        add ebp, ebx
        mov edx, dword [boxshadecolor]
        push edx
        mov ebx, dword [boxlitecolor]
        push ebx
        mov ecx, dword [boxfillcolor]
        push ecx
        mov ecx, dword [byte esi+01Ch]
        mov ebx, dword [byte esi+018h]
        mov edx, ebp
        call DrawBevelRect
        cmp dword [byte esi+02Ch], byte 0
        je near DrawButton_x
        mov ebx, dword [boxshadecolor]
        mov ebp, dword [boxlitecolor]
        xor ebp, ebx
        mov dword [boxlitecolor], ebp
        mov eax, ebx
        xor eax, ebp
        mov dword [boxshadecolor], eax
        mov edx, ebp
        xor edx, eax
        mov dword [boxlitecolor], edx
        jmp near DrawButton_x
%endif ; C
;-----------------------------------------------------------------------------
; TrackScrollBars                              30D0E  95 PC, medium confidence
; Drags the thumb under the mouse, recomputes the position, redraws; returns
; the bar index
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/TrackButtons.c (TrackScrollBars)
%ifdef CBUILD
%include "c/pc/dialogs/TrackButtons.TrackScrollBars.inc"
%else
TrackScrollBars:
        push dword 20h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov esi, eax
        mov dword [byte esp+04h], edx
        mov dword [byte esp+0Ch], ebx
        mov ebp, ecx
        mov dword [byte esp+08h], 0FFFFFFFFh
        xor ecx, ecx
        jmp near .9
.1:
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 4
        add eax, esi
        mov edx, dword [byte esp+0Ch]
        mov edi, dword [eax]
        cmp edx, edi
        jl near .6
        mov ebx, dword [byte eax+08h]
        lea edx, [edi+ebx]
        cmp edx, dword [byte esp+0Ch]
        jle near .6
        mov edx, dword [byte eax+04h]
        cmp ebp, edx
        jl near .6
        add edx, dword [byte eax+0Ch]
        cmp ebp, edx
        jge near .6
        mov edi, dword [byte eax+014h]
        test byte [byte esp+020h], 1
        je short .2
        cmp dword [byte eax+02Ch], byte 0
        jne short .2
        mov dword [byte eax+02Ch], 0FFFFFFFFh
        mov edi, 0FFFFFFFFh
.2:
        test byte [byte esp+020h], 2
        je short .3
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 4
        mov dword [byte esi+eax+02Ch], 0
        mov edi, 0FFFFFFFFh
.3:
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 4
        lea ebx, [esi+eax]
        mov eax, ebp
        mov edx, dword [byte ebx+04h]
        sub eax, edx
        mov dword [esp], eax
        mov eax, dword [byte ebx+01Ch]
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edx, dword [esp]
        sub edx, eax
        mov dword [byte ebx+014h], edx
        test edx, edx
        jge short .4
        mov dword [byte ebx+014h], 0
        jmp short .5
.4:
        mov eax, dword [byte ebx+0Ch]
        sub eax, dword [byte ebx+01Ch]
        sub eax, byte 4
        cmp eax, dword [byte ebx+014h]
        jge short .5
        mov dword [byte ebx+014h], eax
.5:
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 4
        lea ebx, [esi+eax]
        mov edx, dword [byte ebx+014h]
        imul edx, dword [byte ebx+028h]
        mov eax, dword [byte ebx+0Ch]
        sub eax, byte 4
        mov dword [esp], eax
        mov eax, edx
        sar edx, 1Fh
        idiv dword [esp]
        mov dword [byte ebx+020h], eax
        mov dword [byte esp+08h], ecx
        cmp edi, dword [byte ebx+014h]
        je short .8
        mov eax, ebx
        jmp short .7
.6:
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 4
        add eax, esi
        cmp dword [byte eax+02Ch], byte 0
        je short .8
        mov dword [byte eax+02Ch], 0
.7:
        call DrawScrollBar
.8:
        inc ecx
.9:
        cmp ecx, dword [byte esp+04h]
        jl near TrackScrollBars.1
        mov eax, dword [byte esp+08h]
        add esp, byte 10h
        jmp near TrackButtons_x
%endif ; C
;-----------------------------------------------------------------------------
; SaveDialogBg                                                    30E66  95 PC
; Allocates DBOX and saves the screen under the dialog rect (x rounded to 4)
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/SaveDialogBg.c
%ifdef CBUILD
%include "c/pc/dialogs/SaveDialogBg.inc"
%else
SaveDialogBg:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ebp, eax
        mov dword [esp], edx
        mov dword [byte esp+08h], ebx
        mov dword [byte esp+04h], ecx
        lea eax, [byte ecx+04h]
        lea esi, [byte ebx+08h]
        imul eax, esi
        add eax, byte 11h
        push byte 20h
        push eax
        push str_DBOX
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dlgsavebuf], eax
        test eax, eax
        je short .x
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov esi, dword [byte esp+08h]
        add esi, byte 7
        mov eax, dword [dlgsavebuf]
        mov word [byte eax+04h], si
        mov esi, dword [byte esp+04h]
        add esi, byte 4
        mov eax, dword [dlgsavebuf]
        mov word [byte eax+06h], si
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        shl eax, 2
        mov dword [dlgsavex], eax
        mov eax, dword [esp]
        mov dword [dlgsavey], eax
        push eax
        mov ebx, dword [dlgsavex]
        push ebx
        mov ecx, dword [dlgsavebuf]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
.x:
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; RestoreDialogBg                                                 30F12  95 PC
; Puts back and frees the DBOX save
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/RestoreDialogBg.c
%ifdef CBUILD
%include "c/pc/dialogs/RestoreDialogBg.inc"
%else
RestoreDialogBg:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        push ebp
        mov edx, dword [dlgsavebuf]
        test edx, edx
        je short .x
        mov ebx, dword [dlgsavey]
        push ebx
        mov ecx, dword [dlgsavex]
        push ecx
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [dlgsavebuf]
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor ebp, ebp
        mov dword [dlgsavebuf], ebp
.x:
        pop ebp
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GrowToButton                                 30F5F  95 PC, medium confidence
; Widens w / h to fit one button (unused)
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/GrowToButton.c
%ifdef CBUILD
%include "c/pc/dialogs/GrowToButton.inc"
%else
GrowToButton:
        push dword 8
        call __CHK
        push ecx
        test byte [byte eax+014h], 1
        je short .1
        mov ecx, dword [eax]
        add ecx, dword [byte eax+08h]
        add ecx, byte 8
        cmp ecx, dword [edx]
        jle short .3
        jmp short .2
.1:
        mov ecx, dword [byte eax+08h]
        sub ecx, dword [eax]
        add ecx, byte 8
        cmp ecx, dword [edx]
        jle short .3
.2:
        mov dword [edx], ecx
.3:
        test byte [byte eax+014h], 4
        je short .4
        mov edx, dword [byte eax+04h]
        add edx, dword [byte eax+0Ch]
        lea eax, [byte edx+08h]
        cmp eax, dword [ebx]
        jle short .x
        mov dword [ebx], eax
        pop ecx
        ret
.4:
        mov edx, dword [byte eax+0Ch]
        sub edx, dword [byte eax+04h]
        lea eax, [byte edx+08h]
        cmp eax, dword [ebx]
        jle short .x
        mov dword [ebx], eax
.x:
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GrowToButtons                                30FB4  95 PC, medium confidence
; Widens w / h to fit the button row
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/GrowToButtons.c
%ifdef CBUILD
%include "c/pc/dialogs/GrowToButtons.inc"
%else
GrowToButtons:
        push dword 10h
        call __CHK
        push esi
        push edi
        push ebp
        mov ebp, edx
        xor edx, edx
        xor edi, edi
        jmp short .8
.1:
        test byte [byte eax+014h], 1
        je short .2
        mov esi, dword [eax]
        add esi, dword [byte eax+08h]
        jmp short .3
.2:
        mov esi, dword [byte eax+08h]
        sub esi, dword [eax]
.3:
        add esi, byte 8
        add edx, esi
        cmp edx, dword [ebx]
        jle short .4
        mov dword [ebx], edx
.4:
        test byte [byte eax+014h], 4
        je short .5
        mov esi, dword [byte eax+04h]
        add esi, dword [byte eax+0Ch]
        add esi, byte 8
        cmp esi, dword [ecx]
        jle short .7
        jmp short .6
.5:
        mov esi, dword [byte eax+0Ch]
        sub esi, dword [byte eax+04h]
        add esi, byte 8
        cmp esi, dword [ecx]
        jle short .7
.6:
        mov dword [ecx], esi
.7:
        inc edi
.8:
        cmp edi, ebp
        jl short GrowToButtons.1
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MessageBox                                   31013  95 PC, medium confidence
; (x, y (-1 = centred), message line table, line count, buttons, button
; count, ...): the league/front-end message dialog used for every 'Copying
; databases' / 'Insert disk' / error box
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/TextInputDialog.c (MessageBox)
%ifdef CBUILD
%include "c/pc/dialogs/TextInputDialog.MessageBox.inc"
%else
MessageBox:
        push dword 3Ch
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 20h
        mov edi, eax
        mov ebp, edx
        mov dword [byte esp+010h], ebx
        mov dword [byte esp+0Ch], ecx
        call SetScreenTarget
        call RestoreDialogBg
        xor edx, edx
        mov dword [byte esp+04h], edx
        mov dword [esp], edx
        xor eax, eax
        mov al, byte [byte_D42C3]
        add eax, byte 2
        mov dword [byte esp+014h], eax
        xor esi, esi
        jmp short .2
.1:
        mov eax, esi
        shl eax, 2
        add eax, dword [byte esp+010h]
        mov eax, dword [eax]
        mov ecx, dword [byte esp+014h]
        mov ebx, esp
        lea edx, [byte esp+04h]
        call MeasureTextLine
        inc esi
.2:
        cmp esi, dword [byte esp+0Ch]
        jl short MessageBox.1
        add dword [byte esp+04h], byte 10h
        add dword [esp], byte 10h
        mov ecx, esp
        lea ebx, [byte esp+04h]
        mov edx, dword [byte esp+034h]
        mov eax, dword [byte esp+030h]
        call GrowToButtons
        test edi, edi
        jge short .3
        mov edx, 280h
        mov ebx, dword [byte esp+04h]
        sub edx, ebx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edi, eax
.3:
        test ebp, ebp
        jge short .4
        mov edx, 1E0h
        mov ecx, dword [esp]
        sub edx, ecx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [byte esp+01Ch], eax
        jmp short .5
.4:
        mov dword [byte esp+01Ch], ebp
.5:
        mov ecx, dword [esp]
        mov ebx, dword [byte esp+04h]
        mov edx, dword [byte esp+01Ch]
        mov eax, edi
        call SaveDialogBg
        mov esi, dword [boxshadecolor]
        push esi
        mov ebp, dword [boxlitecolor]
        push ebp
        mov eax, dword [boxfillcolor]
        push eax
        mov ecx, dword [byte esp+0Ch]
        mov ebx, dword [byte esp+010h]
        mov edx, dword [byte esp+028h]
        mov eax, edi
        call DrawBevelRect
        mov eax, dword [byte esp+01Ch]
        add eax, byte 8
        mov dword [byte esp+018h], eax
        mov edx, dword [dlgtextbg]
        mov eax, dword [dlgtextfg]
        call SetTextColors
        xor esi, esi
        jmp short .7
.6:
        mov ebp, esi
        shl ebp, 2
        add ebp, dword [byte esp+010h]
        mov eax, dword [byte ebp+00h]
        push eax
        call fputchar
        add esp, byte 4
        mov edx, dword [byte esp+04h]
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov ebx, dword [byte ebp+00h]
        add eax, edi
        mov edx, dword [byte esp+018h]
        call PrintShadowText
        mov eax, dword [byte esp+014h]
        add dword [byte esp+018h], eax
        inc esi
.7:
        cmp esi, dword [byte esp+0Ch]
        jl short MessageBox.6
        xor esi, esi
        jmp short .13
.8:
        mov eax, esi
        shl eax, 3
        sub eax, esi
        shl eax, 2
        add eax, dword [byte esp+030h]
        test byte [byte eax+014h], 1
        je short .9
        add dword [eax], edi
        jmp short .10
.9:
        mov edx, dword [byte esp+04h]
        add edx, edi
        sub edx, dword [byte eax+08h]
        add dword [eax], edx
.10:
        mov eax, esi
        shl eax, 3
        sub eax, esi
        shl eax, 2
        add eax, dword [byte esp+030h]
        test byte [byte eax+014h], 4
        je short .11
        mov edx, dword [byte esp+01Ch]
        jmp short .12
.11:
        mov edx, dword [byte esp+01Ch]
        add edx, dword [esp]
        sub edx, dword [byte eax+0Ch]
.12:
        add dword [byte eax+04h], edx
        inc esi
.13:
        mov ebx, dword [byte esp+034h]
        cmp esi, ebx
        jl short MessageBox.8
        mov edx, ebx
        mov eax, dword [byte esp+030h]
        call DrawButtons
        call ClearInputQueue
        cmp dword [byte esp+040h], byte 0
        je short .14
        mov ecx, ebx
        mov ebx, dword [byte esp+030h]
        mov edx, dword [byte esp+03Ch]
        mov eax, dword [byte esp+038h]
        call RunMessageBox
        mov dword [byte esp+08h], eax
        call RestoreDialogBg
.14:
        xor esi, esi
        jmp short .20
.15:
        mov eax, esi
        shl eax, 3
        sub eax, esi
        shl eax, 2
        add eax, dword [byte esp+030h]
        test byte [byte eax+014h], 1
        je short .16
        sub dword [eax], edi
        jmp short .17
.16:
        mov edx, dword [byte esp+04h]
        add edx, edi
        sub edx, dword [byte eax+08h]
        sub dword [eax], edx
.17:
        mov eax, esi
        shl eax, 3
        sub eax, esi
        shl eax, 2
        add eax, dword [byte esp+030h]
        test byte [byte eax+014h], 4
        je short .18
        mov edx, dword [byte esp+01Ch]
        jmp short .19
.18:
        mov edx, dword [byte esp+01Ch]
        add edx, dword [esp]
        sub edx, dword [byte eax+0Ch]
.19:
        sub dword [byte eax+04h], edx
        inc esi
.20:
        cmp esi, dword [byte esp+034h]
        jl short MessageBox.15
        mov eax, dword [byte esp+08h]
        add esp, byte 20h
        jmp near DlgNullCallback
%endif ; C
;-----------------------------------------------------------------------------
; RunMessageBox                                31250  95 PC, medium confidence
; MessageBox mouse loop: Pointer sprite, TrackButtons until a button is
; released; returns its index
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/RunMessageBox.c
%ifdef CBUILD
%include "c/pc/dialogs/RunMessageBox.inc"
%else
RunMessageBox:
        push dword 40h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        push eax
        push edx
        push ebx
        push ecx
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
        push str_Pointer6
        call AllocMemBlock
        mov ebp, eax
        add esp, byte 0Ch
        mov dword [byte esp+01Ch], eax
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
        mov word [byte ebp+04h], ax
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+06h]
        inc eax
        mov word [byte ebp+06h], ax
        xor edx, edx
        mov dword [byte esp+018h], edx
        mov esi, dword [byte esp+0Ch]
        mov esi, dword [esi]
        mov dword [byte esp+014h], esi
        mov edi, dword [byte esp+08h]
        mov edi, dword [edi]
        mov dword [byte esp+010h], edi
        push edi
        push esi
        call MouseSetPos
        add esp, byte 8
        push edi
        push esi
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        push edi
        push esi
        mov ebx, dword [pointerspr]
        push ebx
        call DrawArt
        add esp, byte 0Ch
.1:
        push byte 1
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short RunMessageBox.1
        push byte 1Ch
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short RunMessageBox.1
        call ClearInputQueue
        xor ebp, ebp
.2:
        call GetInputEvent
        test eax, eax
        je near .10
        lea ebx, [byte esp+010h]
        lea edx, [byte esp+014h]
        call dword [ptrupdatefn]
        mov dword [byte esp+020h], eax
        test byte [byte esp+020h], 2Fh
        je near .8
        push edi
        push esi
        mov ecx, dword [byte esp+024h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [esp]
        test eax, eax
        jle short .4
        test byte [byte esp+020h], 4
        je short .3
        mov ecx, 0FFFFFFFFh
        mov dword [byte esp+018h], ecx
        mov ebp, ecx
        jmp short .7
.3:
        mov ebx, dword [byte esp+020h]
        push ebx
        mov ecx, dword [byte esp+014h]
        mov ebx, dword [byte esp+018h]
        mov edx, eax
        mov eax, dword [byte esp+08h]
        call TrackButtons
        mov dword [byte esp+018h], eax
        test eax, eax
        jl short .7
        jmp short .6
.4:
        mov dl, byte [byte esp+020h]
        test dl, 4
        je short .5
        mov dword [byte esp+018h], 4
        jmp short .6
.5:
        test dl, 2Ah
        je short .7
.6:
        mov ebp, 0FFFFFFFFh
.7:
        push edi
        push esi
        mov eax, dword [byte esp+024h]
        push eax
        call GrabBlock
        add esp, byte 0Ch
        push edi
        push esi
        mov edx, dword [pointerspr]
        push edx
        call DrawArt
        add esp, byte 0Ch
.8:
        cmp esi, dword [byte esp+014h]
        jne short .9
        cmp edi, dword [byte esp+010h]
        je short .10
.9:
        push edi
        push esi
        mov esi, dword [byte esp+024h]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [byte esp+010h]
        push edi
        mov eax, dword [byte esp+018h]
        push eax
        push esi
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+010h]
        push ebx
        mov ecx, dword [byte esp+018h]
        push ecx
        mov esi, dword [pointerspr]
        push esi
        call DrawArt
        add esp, byte 0Ch
        mov esi, dword [byte esp+014h]
        mov edi, dword [byte esp+010h]
.10:
        test ebp, ebp
        je near RunMessageBox.2
.11:
        push byte 1
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short RunMessageBox.11
        push byte 1Ch
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short RunMessageBox.11
        call ClearInputQueue
        push edi
        push esi
        mov edi, dword [byte esp+024h]
        push edi
        call PutBlock
        add esp, byte 0Ch
        call ClearInputQueue
        mov ebp, dword [byte esp+010h]
        push ebp
        mov eax, dword [byte esp+018h]
        push eax
        call MouseSetPos
        add esp, byte 8
        mov eax, dword [byte esp+014h]
        mov edx, dword [byte esp+0Ch]
        mov dword [edx], eax
        mov eax, dword [byte esp+010h]
        mov edx, dword [byte esp+08h]
        mov dword [edx], eax
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [byte esp+018h]
        add esp, byte 24h
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CritErrHandler                                                  3149D  95 PC
; INT 24h handler installed at startup (sub_B3036): sets criterrflag = -1 and
; returns 0 (ignore); checked by database_merge disk-space code
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/CritErrHandler.c
%ifdef CBUILD
%include "c/pc/dialogs/CritErrHandler.inc"
%else
CritErrHandler:
        push dword 4
        call __CHK
        mov dword [criterrflag], 0FFFFFFFFh
        xor eax, eax
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawEditCursor                                                  314B4  95 PC
; XOR-draws the edit cursor (width 1, or font height in overwrite mode) at
; editpos
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/DrawEditCursor.c
%ifdef CBUILD
%include "c/pc/dialogs/DrawEditCursor.inc"
%else
DrawEditCursor:
        push dword 34h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        push eax
        push str_Dot
        call fputchar
        add esp, byte 4
        mov edi, eax
        cmp dword [editcuron], byte 0
        je near DrawEditCursor_ret
        mov eax, dword [editbuf]
        call strlen_
        cmp eax, dword [editpos]
        jge short .1
        mov eax, dword [editbuf]
        call strlen_
        mov dword [editpos], eax
.1:
        mov eax, dword [editbuf]
        add eax, dword [editpos]
        cmp byte [eax], 0
        je short .3
        test byte [esp], 2
        je short .2
        mov esi, edi
        jmp short .5
.2:
        push byte 1
        push eax
        call TextWidthN
        add esp, byte 8
        jmp short .4
.3:
        push str_Space
        call fputchar
        add esp, byte 4
.4:
        mov esi, eax
.5:
        test byte [esp], 2
        je short .6
        mov eax, dword [editpos]
        imul eax, edi
        jmp short .7
.6:
        mov edi, dword [editpos]
        push edi
        mov ebp, dword [editbuf]
        push ebp
        call TextWidthN
        add esp, byte 8
.7:
        add eax, dword [editx]
        movzx edi, byte [byte_D42C5]
        add edi, dword [edity]
        mov ebp, dword [editcurw]
        sub edi, ebp
        sub edi, byte 2
        mov edx, dword [fontcolor]
        push edx
        push ebp
        push esi
        push edi
        push eax
        call sub_91044
DrawEditCursor_x:
        add esp, byte 14h
DrawEditCursor_ret:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawEditText                                                    31599  95 PC
; Trims editbuf to editmaxw pixels, draws it and clears the rest of the field
;-----------------------------------------------------------------------------
; C: src/pc/dialogs/DrawEditCursor.c (DrawEditText)
%ifdef CBUILD
%include "c/pc/dialogs/DrawEditCursor.DrawEditText.inc"
%else
DrawEditText:
        push dword 34h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        push eax
        push str_Dot
        call fputchar
        add esp, byte 4
        mov ebp, eax
        cmp dword [editmaxw], byte 0
        je near .3
        test byte [esp], 2
        je short .2
.1:
        mov eax, dword [editbuf]
        call strlen_
        mov edi, eax
        imul edi, ebp
        cmp edi, dword [editmaxw]
        jle short .3
        mov eax, dword [editbuf]
        call strlen_
        test eax, eax
        je short .3
        mov eax, dword [editbuf]
        call strlen_
        mov esi, dword [editbuf]
        mov byte [byte esi+eax-01h], 0
        jmp short DrawEditText.1
.2:
        mov ebx, dword [editbuf]
        push ebx
        call fputchar
        add esp, byte 4
        cmp eax, dword [editmaxw]
        jle short .3
        mov eax, dword [editbuf]
        call strlen_
        test eax, eax
        je short .3
        mov eax, dword [editbuf]
        call strlen_
        mov esi, dword [editbuf]
        mov byte [byte esi+eax-01h], 0
        jmp short DrawEditText.2
.3:
        mov eax, dword [editbuf]
        call strlen_
        mov edi, eax
        cmp eax, dword [editpos]
        jge short .4
        mov dword [editpos], eax
.4:
        test byte [esp], 2
        je short .7
        xor esi, esi
        jmp short .6
.5:
        mov eax, dword [edity]
        push eax
        mov eax, ebp
        imul eax, esi
        add eax, dword [editx]
        push eax
        push str_Dot
        call TextPrintAt
        add esp, byte 0Ch
        inc esi
.6:
        cmp esi, edi
        jl short DrawEditText.5
        jmp short .8
.7:
        mov ebx, dword [edity]
        push ebx
        mov ecx, dword [editx]
        push ecx
        mov esi, dword [editbuf]
        push esi
        call TextPrintAt
        add esp, byte 0Ch
.8:
        cmp dword [editmaxw], byte 0
        je near DrawEditCursor_ret
        test byte [esp], 2
        je short .9
        imul edi, ebp
        jmp short .10
.9:
        mov ecx, dword [editbuf]
        push ecx
        call fputchar
        add esp, byte 4
        mov edi, eax
.10:
        mov eax, dword [editmaxw]
        sub eax, edi
        test eax, eax
        jle near DrawEditCursor_ret
        mov esi, dword [dword_D42AC]
        push esi
        movzx esi, byte [byte_D42C5]
        sub esi, byte 2
        push esi
        push eax
        mov ebp, dword [edity]
        push ebp
        add edi, dword [editx]
        push edi
        call sub_90EC0
        jmp near DrawEditCursor_x
%endif ; C
;-----------------------------------------------------------------------------
; EditTextField                                                   3170D  95 PC
; (buf, maxlen, maxw, x, y, idlecb, ..., flags): line editor with Left /
; Right / Home / End / Ins / Del / Backspace, digit-only or letters-only
; flags; Enter / Esc ends
;-----------------------------------------------------------------------------
EditTextField:
        push dword 1Ch
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, eax
        mov edi, edx
        mov dword [esp], ebx
        mov ebp, ecx
        call SetScreenTarget
        mov dword [editx], ebp
        mov eax, dword [byte esp+018h]
        mov dword [edity], eax
        mov dword [editbuf], esi
        mov eax, dword [esp]
        mov dword [editmaxw], eax
        xor edx, edx
        mov dword [editpos], edx
        mov eax, dword [byte esp+024h]
        call DrawEditText
        mov ebx, 1
        mov dword [editcurw], ebx
        mov dword [editcuron], ebx
        xor ebp, ebp
        mov eax, dword [byte esp+024h]
        call DrawEditCursor
        mov eax, dword [byte esp+020h]
        push eax
        call SetTickDeadline
        add esp, byte 4
        push byte 4
        call sub_B3D46
        add esp, byte 4
        jmp near .17
.1:
        cmp dword [byte esp+01Ch], byte 0
        je near .17
        call dword [byte esp+01Ch]
        jmp near .17
.2:
        mov eax, dword [byte esp+020h]
        push eax
        call SetTickDeadline
        add esp, byte 4
        mov edx, dword [byte esp+04h]
        cmp edx, byte 0Dh
        je near .33
        cmp edx, byte 1Bh
        jne short .3
        test byte [byte esp+024h], 4
        jne near .33
.3:
        mov ecx, dword [byte esp+04h]
        cmp ecx, 4D00h
        jne short .5
        mov eax, dword [editpos]
        cmp byte [esi+eax], 0
        je near .17
        mov eax, dword [byte esp+024h]
        call DrawEditCursor
        mov eax, dword [editpos]
        cmp edi, eax
        jle near .16
        lea edx, [byte eax+01h]
.4:
        mov dword [editpos], edx
        jmp near .16
.5:
        cmp ecx, 4B00h
        jne short .6
        mov eax, dword [byte esp+024h]
        call DrawEditCursor
        mov ebx, dword [editpos]
        test ebx, ebx
        je near .16
        lea ecx, [byte ebx-01h]
        mov dword [editpos], ecx
        jmp near .16
.6:
        cmp ecx, 4700h
        jne short .7
        mov eax, dword [byte esp+024h]
        call DrawEditCursor
        xor edx, edx
        jmp short EditTextField.4
.7:
        cmp ecx, 4F00h
        jne short .9
        mov eax, dword [byte esp+024h]
        call DrawEditCursor
        xor eax, eax
.8:
        mov dword [editpos], eax
        mov eax, dword [editpos]
        cmp byte [esi+eax], 0
        je near .16
        inc eax
        jmp short EditTextField.8
.9:
        cmp ecx, 5200h
        jne short .11
        mov eax, dword [byte esp+024h]
        call DrawEditCursor
        test ebp, ebp
        jne short .10
        mov ebp, 1
        xor eax, eax
        mov al, byte [byte_D42C3]
        mov dword [editcurw], eax
        jmp short .16
.10:
        xor ebp, ebp
        mov dword [editcurw], 1
        jmp short .16
.11:
        cmp ecx, 5300h
        jne near .19
        mov ebx, dword [editpos]
        cmp edi, ebx
        jle short .17
        mov eax, ebx
        cmp byte [esi+eax], 0
        je short .17
        mov eax, dword [byte esp+024h]
        call DrawEditCursor
        mov eax, dword [editpos]
        jmp short .13
.12:
        mov bl, byte [byte esi+eax+01h]
        mov byte [esi+eax], bl
        inc eax
.13:
        cmp eax, edi
        jl short EditTextField.12
.14:
        mov byte [byte edi+esi-01h], 0
.15:
        mov eax, dword [byte esp+024h]
        call DrawEditText
.16:
        mov eax, dword [byte esp+024h]
        call DrawEditCursor
.17:
        call PollKey
        mov dword [byte esp+04h], eax
        test eax, eax
        jne short .18
        call sub_B3D64
        test eax, eax
        je near EditTextField.1
        xor ebx, ebx
        mov dword [byte esp+04h], ebx
.18:
        cmp dword [byte esp+04h], byte 0
        jne near EditTextField.2
        push byte 4
        call sub_B3D46
        add esp, byte 4
        mov edx, dword [editcuron]
        mov dword [editcuron], 1
        mov eax, dword [byte esp+024h]
        call DrawEditCursor
        test edx, edx
        sete al
        and eax, 0FFh
        mov dword [editcuron], eax
        cmp dword [byte esp+020h], byte 0
        je short EditTextField.17
        call TickDeadlinePassed
        test eax, eax
        jne near .33
        jmp short EditTextField.17
.19:
        cmp ecx, byte 8
        jne short .22
        cmp dword [editpos], byte 0
        je near EditTextField.17
        mov eax, dword [byte esp+024h]
        call DrawEditCursor
        mov edx, dword [editpos]
        dec edx
        mov dword [editpos], edx
        mov eax, edx
        jmp short .21
.20:
        mov bl, byte [byte esi+eax+01h]
        mov byte [esi+eax], bl
        inc eax
.21:
        cmp eax, edi
        jl short EditTextField.20
        jmp near EditTextField.14
.22:
        mov dl, byte [byte esp+024h]
        test dl, 8
        je short .24
        cmp ecx, byte 30h
        jl near EditTextField.17
        cmp ecx, byte 39h
.23:
        jle near .27
        jmp near EditTextField.17
.24:
        test dl, 10h
        je short .26
        cmp ecx, byte 20h
        je short .27
        cmp ecx, byte 41h
        jl short .25
        cmp ecx, byte 5Ah
        jle short .27
.25:
        mov eax, dword [byte esp+04h]
        cmp eax, byte 61h
        jl near EditTextField.17
        cmp eax, byte 7Ah
        jmp short EditTextField.23
.26:
        cmp ecx, byte 20h
        jl near EditTextField.17
        cmp ecx, byte 7Ah
        jg near EditTextField.17
        cmp edi, dword [editpos]
        jle near EditTextField.17
        test dl, 1
        je short .27
        test dl, 1
        je near EditTextField.17
        mov al, byte [byte esp+04h]
        inc al
        and eax, 0FFh
        mov eax, dword [dword eax+byte_C4B6C-3]
        sar eax, 18h
        test al, 0E0h
        je near EditTextField.17
.27:
        mov eax, dword [byte esp+024h]
        call DrawEditCursor
        test ebp, ebp
        jne short .29
        mov eax, dword [editpos]
        mov cl, byte [esi+eax]
        test cl, cl
        jne short .28
        mov byte [byte esi+eax+01h], cl
.28:
        mov eax, dword [editpos]
        jmp short .32
.29:
        lea eax, [byte edi-02h]
        jmp short .31
.30:
        mov bl, byte [esi+eax]
        mov byte [byte esi+eax+01h], bl
        dec eax
.31:
        mov edx, dword [editpos]
        cmp eax, edx
        jge short EditTextField.30
        mov eax, edx
.32:
        mov dl, byte [byte esp+04h]
        mov byte [esi+eax], dl
        mov ebx, dword [editpos]
        cmp edi, ebx
        jle near EditTextField.15
        lea ecx, [byte ebx+01h]
        mov dword [editpos], ecx
        jmp near EditTextField.15
.33:
        mov eax, dword [byte esp+024h]
        call DrawEditCursor
        mov eax, dword [byte esp+04h]
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret 10h
