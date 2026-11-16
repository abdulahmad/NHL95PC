; The Open dialog for a player database: the current one, the original, or an extra copy.
bits 32
%include "hockey.inc"
section s_71F0C progbits alloc exec nowrite align=1
extern __CHK, attdb, attdb_size, btn_POHumanOut, byte_C4B6C, byte_D42C3, careerdb, careerdb_size
extern carteamsdb, carteamsdb_size, cddriveptr, ClearInputQueue, CmpFileNames, curdbname, dbdirty, dbdlgrects
extern dblistcur, dblistorig, dblisttemp, dblisttempnames, dbtablists, deldbmsg, DeleteDir, dlgedgecol1
extern dlgedgecol2, dlgfillcol, DlgReturnZero, DrawDlgFrame, DrawEditRosters, dword_D42AC, EditTextField, fdlg_arrow
extern fdlg_cancel, fdlg_del, fdlg_down, fdlg_noarrow, fdlg_none, fdlg_open, fdlg_tabexh, fdlg_tablp
extern fdlg_tabnone, fdlg_tabpo, fdlg_up, fdlgmask, fdlgshapes, fdlgtab, FileDlgHitTest, fileoncd
extern fputchar, FreeLeagueDbsMem, FreeMemBlock, GetInputEvent, keydb, keydb_size, leaguedbnames, LoadBothRosterLists
extern MakePath, MeasureTextLine, MessageBox, pointerspr, PrintShadowText, PrintTextCopy, ptrupdatefn, qsort_
extern savefname, seasondb, seasondb_size, str_Arro2, str_Buf2, str_Can2, str_CURRENT, str_Current4
extern str_Db3, str_DbBut, str_Dbcu, str_Dbdialog, str_Dbno, str_Dbor, str_Dbtm, str_Dbx
extern str_DBX2, str_Del2, str_Delete2, str_Done2, str_Down2, str_DSBOX, str_extDB, str_Noar2
extern str_None2, str_Open3, str_Open4, str_Org, str_ORG, str_ORIGINAL, str_Original2, str_Pdbx
extern str_Pointer12, str_Temporary, str_Up2, strcat_, strcpy_, strlen_, AllocMemBlock, LoadBank
extern OpenArtArchiveErr, TextSetColors, PutBlock, FillRect, DrawArtOpaque, DrawArtKeyFF, DrawArt, GrabBlock
extern PrintString, TextPrintAt, GetFileSize, KeyDown, MouseRead, FindShape, SetScreenTarget, FillRectColor
extern teamsdb, teamsdb_size, unknown_libname_1, unknown_libname_2, unknown_libname_4
global InputDialog, unk13_722FE, LoadDbDialogShapes, DbDialog_epilogue, DbDialog_ret, ScanDbFiles, DrawDbDialogButtons, DrawDbDialog_jt
global DrawDbDialog, DrawDbDialog_n6, DrawDbDialog_n5, DrawDbDialog_n4, DrawDbDialog_n3, DrawDbDialog_n2, DrawDbDialog_n1, DbDialogHitTest
global DrawDbList_jt, DrawDbList, DrawDbList_n6, DrawDbList_n5, DrawDbList_n4, DrawDbList_n3, DrawDbList_n2, DrawDbList_n1
global DbDialogLoop, OpenSelectedDb, LoadDbsFromDir, DeleteSelectedDb, MenuOpenDatabase
;-----------------------------------------------------------------------------
; InputDialog                                  71F0C  95 PC, medium confidence
; Text-input message box (line table, line count, buffer, ...) returning FFh
; on Esc; FixJerseyNumber, AskLeftRight, EditSkaterRating, FindPlayer
;-----------------------------------------------------------------------------
; C: src/pc/database_dialogs/InputDialog.c
%ifdef CBUILD
%include "c/pc/database_dialogs/InputDialog.inc"
%else
InputDialog:
        push dword 90h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 68h
        push eax
        push edx
        mov ebp, ebx
        mov dword [byte esp+068h], ecx
        mov dword [byte esp+06Ch], 0FFFFFFFFh
        xor ebx, ebx
        mov dword [byte esp+048h], ebx
        mov dword [byte esp+044h], ebx
        xor eax, eax
        mov al, byte [byte_D42C3]
        add eax, byte 2
        mov dword [byte esp+058h], eax
        xor esi, esi
        mov edi, dword [esp]
        jmp short .2
.1:
        mov eax, esi
        shl eax, 2
        add eax, dword [byte esp+04h]
        mov eax, dword [eax]
        mov ecx, dword [byte esp+058h]
        lea ebx, [byte esp+044h]
        lea edx, [byte esp+048h]
        call MeasureTextLine
        inc esi
.2:
        cmp esi, edi
        jl short InputDialog.1
        mov eax, dword [dword esp+080h]
        add eax, byte 8
        mov dword [byte esp+05Ch], eax
        cmp eax, dword [byte esp+048h]
        jle short .3
        mov dword [byte esp+048h], eax
.3:
        mov ebx, dword [byte esp+048h]
        add ebx, byte 10h
        mov dword [byte esp+048h], ebx
        mov ecx, dword [byte esp+044h]
        add ecx, byte 1Fh
        mov dword [byte esp+044h], ecx
        mov edx, 280h
        sub edx, ebx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [byte esp+060h], eax
        mov edx, 1E0h
        sub edx, ecx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [byte esp+064h], eax
        mov eax, dword [byte esp+060h]
        mov edx, eax
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        shl eax, 2
        mov dword [byte esp+054h], eax
        mov eax, dword [byte esp+064h]
        mov dword [byte esp+04Ch], eax
        lea edx, [byte ebx+06h]
        mov eax, edx
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        mov edx, eax
        shl edx, 2
        mov dword [byte esp+03Ch], edx
        mov ebx, eax
        shl ebx, 4
        lea eax, [byte ecx+04h]
        add ebx, byte 4
        imul ebx, eax
        add ebx, byte 11h
        push byte 0
        push ebx
        push str_DSBOX
        call AllocMemBlock
        mov edx, eax
        add esp, byte 0Ch
        mov dword [byte esp+050h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [byte esp+03Ch]
        inc eax
        mov word [byte edx+04h], ax
        mov eax, dword [byte esp+044h]
        add eax, 4
        mov word [byte edx+06h], ax
        mov eax, dword [byte esp+064h]
        push eax
        mov ebx, dword [byte esp+058h]
        push ebx
        push edx
        call GrabBlock
        add esp, byte 0Ch
        push byte 0
        mov ecx, dword [byte esp+068h]
        add ecx, dword [byte esp+048h]
        dec ecx
        mov ebx, dword [byte esp+064h]
        add ebx, dword [byte esp+04Ch]
        dec ebx
        mov edx, dword [byte esp+068h]
        mov eax, dword [byte esp+064h]
        call DrawDlgFrame
        xor esi, esi
        add dword [byte esp+064h], byte 8
        jmp short .5
.4:
        mov edi, esi
        shl edi, 2
        add edi, dword [byte esp+04h]
        mov ecx, dword [edi]
        push ecx
        call fputchar
        add esp, byte 4
        mov edx, dword [byte esp+048h]
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov ebx, dword [edi]
        add eax, dword [byte esp+060h]
        mov edx, dword [byte esp+064h]
        call PrintShadowText
        mov eax, dword [byte esp+058h]
        add dword [byte esp+064h], eax
        inc esi
.5:
        cmp esi, dword [esp]
        jl short InputDialog.4
        mov edx, dword [byte esp+048h]
        mov ecx, dword [byte esp+05Ch]
        sub edx, ecx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add dword [byte esp+060h], eax
        mov eax, dword [dlgfillcol]
        mov dword [byte esp+040h], eax
        mov edi, dword [dlgedgecol1]
        mov esi, dword [dlgedgecol2]
        xor eax, eax
        mov dword [dlgfillcol], eax
        mov dword [dword_D42AC], eax
        mov dword [dlgedgecol1], esi
        mov dword [dlgedgecol2], edi
        push eax
        mov ecx, dword [byte esp+068h]
        add ecx, byte 11h
        mov ebx, dword [byte esp+064h]
        add ebx, dword [byte esp+060h]
        dec ebx
        mov edx, dword [byte esp+068h]
        mov eax, dword [byte esp+064h]
        call DrawDlgFrame
        mov eax, dword [byte esp+040h]
        mov dword [dlgfillcol], eax
        mov dword [dlgedgecol1], edi
        mov dword [dlgedgecol2], esi
        xor esi, esi
        cmp dword [dword esp+084h], byte 0
        je near .12
        mov edi, dword [dword esp+08Ch]
.6:
        push byte 0Ch
        push byte 0
        push DlgReturnZero
        mov eax, dword [byte esp+070h]
        add eax, byte 2
        push eax
        mov ecx, dword [byte esp+070h]
        add ecx, byte 2
        mov ebx, dword [byte esp+06Ch]
        sub ebx, byte 8
        mov edx, dword [byte esp+078h]
        mov eax, ebp
        call EditTextField
        cmp eax, byte 1Bh
        je short .10
        mov dword [byte esp+06Ch], 0FFFFFFFFh
        cmp dword [dword esp+090h], byte 0
        je short .7
        cmp byte [byte ebp+00h], 0
        je short .11
.7:
        xor esi, esi
        mov ecx, dword [byte esp+068h]
        jmp short .9
.8:
        mov al, byte [esi+ebp]
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        je short .11
        mov eax, ebp
        call unknown_libname_4
        mov dword [byte esp+06Ch], eax
        inc esi
.9:
        cmp esi, ecx
        jl short InputDialog.8
        jmp short .11
.10:
        cmp dword [dword esp+090h], byte 0
        je near .18
.11:
        mov eax, dword [byte esp+06Ch]
        cmp eax, dword [dword esp+088h]
        jl near InputDialog.6
        cmp eax, edi
        jg near InputDialog.6
        jmp near .18
.12:
        mov edx, ebp
        lea eax, [byte esp+08h]
        call strcpy_
        mov edi, 1
.13:
        push byte 14h
        push byte 0
        push DlgReturnZero
        mov eax, dword [byte esp+070h]
        add eax, byte 2
        push eax
        mov ecx, dword [byte esp+070h]
        add ecx, byte 2
        mov ebx, dword [byte esp+06Ch]
        sub ebx, byte 8
        mov edx, dword [byte esp+078h]
        mov eax, ebp
        call EditTextField
        cmp eax, byte 1Bh
        je short .15
        mov esi, 1
        cmp dword [dword esp+090h], byte 0
        je short .14
        cmp byte [byte ebp+00h], 0
        jne short .14
        xor esi, esi
        jmp short .17
.14:
        mov dword [byte esp+06Ch], edi
        jmp short .17
.15:
        cmp dword [dword esp+090h], byte 0
        je short .16
        lea edx, [byte esp+08h]
        mov eax, ebp
        call strcpy_
        jmp short .17
.16:
        mov esi, 1
.17:
        test esi, esi
        je short InputDialog.13
.18:
        push byte 1
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short InputDialog.18
        push byte 1Ch
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short InputDialog.18
        call ClearInputQueue
        mov eax, dword [byte esp+04Ch]
        push eax
        mov edx, dword [byte esp+058h]
        push edx
        mov ebx, dword [byte esp+058h]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        mov ecx, dword [byte esp+050h]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, ebp
        call strlen_
        mov ebx, eax
        jmp short .20
.19:
        lea eax, [ebx+ebp]
        cmp byte [byte eax-01h], 20h
        jne short .21
        mov byte [byte eax-01h], 0
        dec ebx
.20:
        test ebx, ebx
        jg short InputDialog.19
.21:
        cmp byte [byte ebp+00h], 20h
        jne short .24
        mov eax, ebp
        call strlen_
        mov ebx, eax
        xor esi, esi
        jmp short .23
.22:
        mov dl, byte [byte esi+ebp+01h]
        mov byte [esi+ebp], dl
        inc esi
.23:
        cmp esi, ebx
        jl short InputDialog.22
        jmp short InputDialog.21
.24:
        mov eax, dword [byte esp+06Ch]
        add esp, byte 70h
        pop ebp
        pop edi
        pop esi
        ret 14h
%endif ; C
unk13_722FE:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; LoadDbDialogShapes                                              7230B  95 PC
; Loads db_but (once) and its button shapes none / del / open / can / noar /
; up / down / arro and the tab shapes dbno / dbcu / dbtm / dbor into the
; fdlg_* slots
;-----------------------------------------------------------------------------
; C: src/pc/database_dialogs/LoadDbDialogShapes.c
%ifdef CBUILD
%include "c/pc/database_dialogs/LoadDbDialogShapes.inc"
%else
LoadDbDialogShapes:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 20h
        mov edx, dword [fdlgshapes]
        test edx, edx
        jne near .2
        xor ecx, ecx
        mov ebx, str_DbBut
        cmp byte [fileoncd+01C7h], 1
        jne short .1
        mov edx, dword [cddriveptr]
.1:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [fdlgshapes], eax
        push str_None2
        push eax
        call FindShape
        add esp, byte 8
        mov dword [fdlg_none], eax
        push str_Del2
        mov ebx, dword [fdlgshapes]
        push ebx
        call FindShape
        add esp, byte 8
        mov dword [fdlg_del], eax
        push str_Open3
        mov ecx, dword [fdlgshapes]
        push ecx
        call FindShape
        add esp, byte 8
        mov dword [fdlg_open], eax
        push str_Can2
        mov esi, dword [fdlgshapes]
        push esi
        call FindShape
        add esp, byte 8
        mov dword [fdlg_cancel], eax
        push str_Noar2
        mov edi, dword [fdlgshapes]
        push edi
        call FindShape
        add esp, byte 8
        mov dword [fdlg_noarrow], eax
        push str_Up2
        mov ebp, dword [fdlgshapes]
        push ebp
        call FindShape
        add esp, byte 8
        mov dword [fdlg_up], eax
        push str_Down2
        mov eax, dword [fdlgshapes]
        push eax
        call FindShape
        add esp, byte 8
        mov dword [fdlg_down], eax
        push str_Arro2
        mov edx, dword [fdlgshapes]
        push edx
        call FindShape
        add esp, byte 8
        mov dword [fdlg_arrow], eax
        push str_Dbno
        mov ebx, dword [fdlgshapes]
        push ebx
        call FindShape
        add esp, byte 8
        mov dword [fdlg_tabnone], eax
        push str_Dbcu
        mov ecx, dword [fdlgshapes]
        push ecx
        call FindShape
        add esp, byte 8
        mov dword [fdlg_tabexh], eax
        push str_Dbtm
        mov esi, dword [fdlgshapes]
        push esi
        call FindShape
        add esp, byte 8
        mov dword [fdlg_tablp], eax
        push str_Dbor
        mov edi, dword [fdlgshapes]
        push edi
        call FindShape
        add esp, byte 8
        mov dword [fdlg_tabpo], eax
.2:
        add esp, byte 20h
;-----------------------------------------------------------------------------
; DbDialog_epilogue                                               72485  95 PC
; Shared epilogue (pop / ret) jumped to by the database dialog functions
;-----------------------------------------------------------------------------
DbDialog_epilogue:
        pop ebp
DbDialog_ret:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ScanDbFiles                                                     7248C  95 PC
; Fills the three database lists: *.db -> "CURRENT", *.org -> "ORIGINAL",
; *.dbx directories (max 16, qsort CmpFileNames) -> temporary list
;-----------------------------------------------------------------------------
; C: src/pc/database_dialogs/LoadDbDialogShapes.c (ScanDbFiles)
%ifdef CBUILD
%include "c/pc/database_dialogs/LoadDbDialogShapes.ScanDbFiles.inc"
%else
ScanDbFiles:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 2Ch
        xor ecx, ecx
        xor edx, edx
        mov dword [dblisttemp], ecx
        mov dword [dblistcur], ecx
        mov dword [dblistorig], ecx
        mov dword [dblisttemp+4], ecx
        mov dword [dblistcur+4], ecx
        mov dword [dblistorig+4], ecx
        mov dword [dblisttemp+8], ecx
        mov dword [dblistcur+8], ecx
        mov dword [dblistorig+8], ecx
        mov dword [dblisttemp+0Ch], ecx
        mov dword [dblistcur+0Ch], ecx
        mov dword [dblistorig+0Ch], ecx
        mov ebx, esp
        mov eax, str_Db3
        call unknown_libname_1
        test eax, eax
        jne short .1
        mov dword [dblistcur+10h], savefname
        mov edi, savefname
        mov esi, str_CURRENT
        movsd
        movsd
        inc dword [dblistcur]
        xor ah, ah
        mov byte [savefname+8], ah
        mov ecx, 9
.1:
        mov ebx, esp
        xor edx, edx
        mov eax, str_Org
        call unknown_libname_1
        test eax, eax
        jne short .2
        mov eax, savefname
        add eax, ecx
        mov dword [dblistorig+10h], eax
        lea edi, [dword ecx+savefname]
        mov esi, str_ORIGINAL
        movsd
        movsd
        movsb
        inc dword [dblistorig]
        add ecx, byte 8
        xor dl, dl
        mov byte [dword ecx+savefname], dl
        inc ecx
.2:
        mov ebx, esp
        mov edx, 10h
        mov eax, str_Dbx
        call unknown_libname_1
        test eax, eax
        jne near .9
.3:
        mov edx, savefname
        add edx, ecx
        mov eax, dword [dblisttemp]
        mov dword [nosplit eax*4+dblisttempnames], edx
        xor eax, eax
        inc dword [dblisttemp]
.4:
        mov dh, byte [byte esp+eax+01Eh]
        test dh, dh
        je short .5
        cmp dh, 2Eh
        je short .5
        mov byte [dword ecx+savefname], dh
        inc eax
        inc ecx
        cmp eax, byte 8
        jl short ScanDbFiles.4
.5:
        xor bh, bh
        mov byte [dword ecx+savefname], bh
        inc ecx
        cmp dword [dblisttemp], byte 10h
        jge short .6
        mov eax, esp
        call unknown_libname_2
        test eax, eax
        je short ScanDbFiles.3
.6:
        mov edx, dword [dblisttemp]
        mov ecx, CmpFileNames
        mov ebx, 4
        mov eax, dblisttempnames
        call qsort_
        mov eax, dword [dblisttemp]
        cmp eax, byte 6
        jge short .7
        dec eax
        jmp short .8
.7:
        mov eax, 5
.8:
        mov dword [dblisttemp+0Ch], eax
.9:
        add esp, byte 2Ch
        jmp near DbDialog_ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawDbDialogButtons                                             72605  95 PC
; Open / Delete / Done buttons and the Current / Original / Temporary tabs by
; fdlgtab / fdlgmask
;-----------------------------------------------------------------------------
; C: src/pc/database_dialogs/DrawDbDialogButtons.c
%ifdef CBUILD
%include "c/pc/database_dialogs/DrawDbDialogButtons.inc"
%else
DrawDbDialogButtons:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        push dword 0FFh
        push dword 0F8h
        call TextSetColors
        add esp, byte 8
        cmp dword [fdlgtab], byte 0
        jge near .1
        push dword 0C0h
        push byte 2Dh
        push str_Open4
        call PrintString
        add esp, byte 0Ch
        push dword 0C0h
        push byte 6Eh
        push str_Delete2
        call PrintString
        add esp, byte 0Ch
        push dword 0FFh
        push dword 0FAh
        call TextSetColors
        add esp, byte 8
        push dword 0C0h
        push dword 0B5h
        push str_Done2
        call PrintString
        add esp, byte 0Ch
        push dword 0FFh
        push dword 0F8h
        call TextSetColors
        add esp, byte 8
        push byte 4Ch
        push dword 0B1h
        push str_Current4
        call PrintString
        add esp, byte 0Ch
        push byte 64h
        push dword 0B1h
        push str_Original2
        call PrintString
        add esp, byte 0Ch
        push byte 7Ch
        push dword 0A7h
        push str_Temporary
        call PrintString
        add esp, byte 0Ch
        push byte 46h
        push byte 18h
        mov ebp, dword [fdlg_noarrow]
        push ebp
        call DrawArt
        add esp, byte 0Ch
        jmp near .x
.1:
        test byte [fdlgmask], 80h
        jne short .2
        push byte 7Ch
        push dword 0A7h
        push str_Temporary
        call PrintString
        add esp, byte 0Ch
.2:
        test byte [fdlgmask], 40h
        jne short .3
        push byte 64h
        push dword 0B1h
        push str_Original2
        call PrintString
        add esp, byte 0Ch
.3:
        test byte [fdlgmask], 20h
        jne short .4
        push byte 4Ch
        push dword 0B1h
        push str_Current4
        call TextPrintAt
        add esp, byte 0Ch
.4:
        mov eax, dword [fdlgtab]
        cmp eax, byte 1
        jb short .5
        jbe short .6
        cmp eax, byte 2
        je short .7
        jmp short .9
.5:
        test eax, eax
        jne short .9
        push byte 4Bh
        push dword 0A3h
        mov esi, dword [fdlg_tabexh]
        push esi
        jmp short .8
.6:
        push byte 4Bh
        push dword 0A3h
        mov ecx, dword [fdlg_tabpo]
        push ecx
        jmp short .8
.7:
        push byte 4Bh
        push dword 0A3h
        mov ebx, dword [fdlg_tablp]
        push ebx
.8:
        call DrawArt
        add esp, byte 0Ch
.9:
        cmp dword [fdlgtab], byte 2
        jne short .10
        push dword 0FFh
        push dword 0FAh
        call TextSetColors
        add esp, byte 8
.10:
        push dword 0C0h
        push byte 6Eh
        push str_Delete2
        call PrintString
        add esp, byte 0Ch
        push dword 0FFh
        push dword 0F8h
        call TextSetColors
        add esp, byte 8
.x:
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
        db 090h
DrawDbDialog_jt:
        dd DrawDbDialog_n1
        dd DrawDbDialog_n2
        dd DrawDbDialog_n3
        dd DrawDbDialog_n4
        dd DrawDbDialog_n5
        dd DrawDbDialog_n6
;-----------------------------------------------------------------------------
; DrawDbDialog                                 727EE  95 PC, medium confidence
; Draws the "dbdialog" box (pdbx palette), tabs and the selected list
;-----------------------------------------------------------------------------
; C: src/pc/database_dialogs/LoadDbDialogShapes.c (DrawDbDialog)
%ifdef CBUILD
%include "c/pc/database_dialogs/LoadDbDialogShapes.DrawDbDialog.inc"
%else
DrawDbDialog:
        push dword 54h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 24h
        call SetScreenTarget
        xor ecx, ecx
        mov ebx, str_Dbdialog
        cmp byte [fileoncd+01C8h], 1
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
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push byte 13h
        push byte 0Ah
        push str_Pdbx
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call DrawArtKeyFF
        add esp, byte 0Ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov dword [fdlgmask], 10h
        mov dword [fdlgtab], 0FFFFFFFFh
        cmp dword [dblisttemp], byte 0
        je short .3
        mov dword [fdlgmask], 90h
        mov dword [fdlgtab], 2
.3:
        cmp dword [dblistorig], byte 0
        je short .4
        or byte [fdlgmask], 40h
        mov dword [fdlgtab], 1
.4:
        cmp dword [dblistcur], byte 0
        je short .5
        or byte [fdlgmask], 20h
        xor ebx, ebx
        mov dword [fdlgtab], ebx
.5:
        cmp dword [fdlgtab], byte 0
        jl near DrawDbDialog_n1.1
        or word [fdlgmask], 204h
        push dword 0FFh
        push dword 0FAh
        call TextSetColors
        add esp, byte 8
        mov esi, dword [fdlgtab]
        mov esi, dword [nosplit esi*4+dbtablists]
        mov eax, dword [dbdlgrects+94h]
        add eax, byte 13h
        push eax
        mov eax, dword [dbdlgrects+90h]
        add eax, byte 0Dh
        push eax
        mov eax, dword [byte esi+04h]
        mov edi, dword [byte esi+eax*4+010h]
        push edi
        call PrintString
        add esp, byte 0Ch
        push dword 0F8h
        mov eax, dword [dbdlgrects+0ACh]
        mov ebp, dword [dbdlgrects+0A4h]
        sub eax, ebp
        inc eax
        push eax
        mov eax, dword [dbdlgrects+0A8h]
        mov edx, dword [dbdlgrects+0A0h]
        sub eax, edx
        inc eax
        push eax
        lea eax, [byte ebp+013h]
        push eax
        lea eax, [byte edx+0Ah]
        push eax
        call FillRect
        add esp, byte 14h
        mov edi, dword [byte esi+08h]
        mov ebp, 0Ah
        jmp short .7
.6:
        mov eax, ebp
        shl eax, 4
        mov edx, dword [dword eax+dbdlgrects+4]
        add edx, byte 10h
        push edx
        mov eax, dword [dword eax+dbdlgrects]
        add eax, byte 0Ah
        push eax
        mov eax, edi
        mov edx, dword [byte esi+eax*4+010h]
        push edx
        call PrintString
        add esp, byte 0Ch
        inc edi
        inc ebp
.7:
        cmp edi, dword [byte esi+0Ch]
        jle short DrawDbDialog.6
        mov ecx, dword [esi]
        cmp ecx, byte 6
        jle near .8
        or word [fdlgmask], 0FF03h
        mov ebp, dword [dbdlgrects+80h]
        add ebp, byte 0Ah
        mov edi, dword [dbdlgrects+84h]
        add edi, byte 13h
        mov eax, dword [dbdlgrects+88h]
        add eax, byte 0Ah
        mov dword [byte esp+020h], eax
        mov eax, 354h
        mov edx, eax
        sar edx, 1Fh
        idiv dword [esi]
        mov esi, dword [dbdlgrects+84h]
        add esi, byte 12h
        add esi, eax
        push byte 7Dh
        push edi
        mov eax, dword [dbdlgrects+88h]
        add eax, byte 9
        push eax
        push edi
        push ebp
        call FillRectColor
        add esp, byte 14h
        push byte 7Dh
        lea eax, [byte esi-01h]
        push eax
        push ebp
        push edi
        push ebp
        call FillRectColor
        add esp, byte 14h
        push byte 7Bh
        push esi
        mov ecx, dword [byte esp+028h]
        push ecx
        dec edi
        push edi
        mov edi, ecx
        push ecx
        call FillRectColor
        add esp, byte 14h
        push byte 7Bh
        push esi
        mov eax, edi
        push eax
        push esi
        dec ebp
        push ebp
        call FillRectColor
        add esp, byte 14h
        jmp short DrawDbDialog_n1.1
.8:
        lea eax, [byte ecx-01h]
        cmp eax, byte 5
        ja short DrawDbDialog_n1.1
        jmp dword [nosplit cs:eax*4+DrawDbDialog_jt]
DrawDbDialog_n6:
        or byte [fdlgmask+1], 80h
DrawDbDialog_n5:
        or byte [fdlgmask+1], 40h
DrawDbDialog_n4:
        or byte [fdlgmask+1], 20h
DrawDbDialog_n3:
        or byte [fdlgmask+1], 10h
DrawDbDialog_n2:
        or byte [fdlgmask+1], 8
DrawDbDialog_n1:
        or byte [fdlgmask+1], 4
.1:
        add esp, byte 24h
        jmp near DbDialog_epilogue
%endif ; C
;-----------------------------------------------------------------------------
; DbDialogHitTest                                                 72A5C  95 PC
; (x, y, out): index of the dbdlgrects rect (16) under the point
;-----------------------------------------------------------------------------
; C: src/pc/database_dialogs/DbDialogHitTest.c
%ifdef CBUILD
%include "c/pc/database_dialogs/DbDialogHitTest.inc"
%else
DbDialogHitTest:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        mov ecx, eax
        mov esi, edx
        xor edx, edx
        lea ecx, [byte eax-06h]
        sub esi, byte 13h
.1:
        mov eax, edx
        shl eax, 4
        cmp ecx, dword [dword eax+dbdlgrects]
        jl short .2
        cmp ecx, dword [dword eax+dbdlgrects+8]
        jg short .2
        cmp esi, dword [dword eax+dbdlgrects+4]
        jl short .2
        cmp esi, dword [dword eax+dbdlgrects+0Ch]
        jg short .2
        mov dword [ebx], edx
        mov eax, 1
        pop esi
        pop ecx
        ret
.2:
        inc edx
        cmp edx, byte 10h
        jl short DbDialogHitTest.1
        xor eax, eax
        pop esi
        pop ecx
        ret
%endif ; C
DrawDbList_jt:
        dd DrawDbList_n1
        dd DrawDbList_n2
        dd DrawDbList_n3
        dd DrawDbList_n4
        dd DrawDbList_n5
        dd DrawDbList_n6
;-----------------------------------------------------------------------------
; DrawDbList                                   72AC6  95 PC, medium confidence
; (list): clears and prints the 6 visible names (scrolled by list+8) and the
; scroll bar
;-----------------------------------------------------------------------------
; C: src/pc/database_dialogs/LoadDbDialogShapes.c (DrawDbList)
%ifdef CBUILD
%include "c/pc/database_dialogs/LoadDbDialogShapes.DrawDbList.inc"
%else
DrawDbList:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov edi, eax
        push dword 0FFh
        push dword 0FAh
        call TextSetColors
        add esp, byte 8
        xor esi, esi
.1:
        push dword 0F9h
        mov eax, esi
        shl eax, 4
        mov edx, dword [dword eax+dbdlgrects+0ACh]
        mov ebx, dword [dword eax+dbdlgrects+0A4h]
        sub edx, ebx
        inc edx
        push edx
        mov edx, dword [dword eax+dbdlgrects+0A8h]
        mov ecx, dword [dword eax+dbdlgrects+0A0h]
        sub edx, ecx
        inc edx
        push edx
        lea edx, [byte ebx+013h]
        push edx
        lea eax, [byte ecx+0Ah]
        push eax
        call FillRect
        add esp, byte 14h
        inc esi
        cmp esi, byte 6
        jl short DrawDbList.1
        test edi, edi
        jne short .2
        mov dword [byte esp+04h], edi
        jmp near DrawDbList_n1.7
.2:
        cmp dword [edi], byte 6
        jg short .5
        xor esi, esi
        jmp short .4
.3:
        mov eax, esi
        shl eax, 4
        mov ebx, dword [dword eax+dbdlgrects+0A4h]
        add ebx, byte 10h
        mov edx, dword [dword eax+dbdlgrects+0A0h]
        add edx, byte 0Ah
        mov eax, esi
        mov eax, dword [byte edi+eax*4+010h]
        call PrintTextCopy
        inc esi
.4:
        cmp esi, dword [edi]
        jl short DrawDbList.3
        jmp short .7
.5:
        xor esi, esi
.6:
        mov eax, esi
        shl eax, 4
        mov ebx, dword [dword eax+dbdlgrects+0A4h]
        add ebx, byte 10h
        mov edx, dword [dword eax+dbdlgrects+0A0h]
        add edx, byte 0Ah
        mov eax, dword [byte edi+08h]
        add eax, esi
        mov eax, dword [byte edi+eax*4+010h]
        call PrintTextCopy
        inc esi
        cmp esi, byte 6
        jl short DrawDbList.6
.7:
        cmp dword [edi], byte 0
        jle short .8
        push dword 0F8h
        mov eax, dword [dbdlgrects+9Ch]
        mov edx, dword [dbdlgrects+94h]
        sub eax, edx
        sub eax, byte 5
        push eax
        mov eax, dword [dbdlgrects+98h]
        mov ebx, dword [dbdlgrects+90h]
        sub eax, ebx
        sub eax, byte 5
        push eax
        lea eax, [byte edx+016h]
        push eax
        lea eax, [byte ebx+0Dh]
        push eax
        call FillRect
        add esp, byte 14h
        mov ebx, dword [dbdlgrects+94h]
        add ebx, byte 13h
        mov edx, dword [dbdlgrects+90h]
        add edx, byte 0Dh
        mov eax, dword [byte edi+04h]
        mov eax, dword [byte edi+eax*4+010h]
        call PrintTextCopy
.8:
        mov eax, dword [byte edi+04h]
        mov ecx, dword [byte edi+08h]
        cmp eax, ecx
        jl short .9
        cmp eax, dword [byte edi+0Ch]
        jg short .9
        mov esi, eax
        sub esi, ecx
        push dword 0F8h
        mov ebp, esi
        shl ebp, 4
        mov eax, dword [dword ebp+dbdlgrects+0ACh]
        mov edx, dword [dword ebp+dbdlgrects+0A4h]
        sub eax, edx
        push eax
        mov eax, dword [dword ebp+dbdlgrects+0A8h]
        mov ebx, dword [dword ebp+dbdlgrects+0A0h]
        sub eax, ebx
        push eax
        lea eax, [byte edx+013h]
        push eax
        lea eax, [byte ebx+0Ah]
        push eax
        call FillRect
        add esp, byte 14h
        mov ebx, dword [dword ebp+dbdlgrects+0A4h]
        add ebx, byte 10h
        mov edx, dword [dword ebp+dbdlgrects+0A0h]
        add edx, byte 0Ah
        mov eax, dword [byte edi+08h]
        add eax, esi
        mov eax, dword [byte edi+eax*4+010h]
        call PrintTextCopy
.9:
        push dword 0F9h
        mov eax, dword [dbdlgrects+8Ch]
        mov ecx, dword [dbdlgrects+84h]
        sub eax, ecx
        inc eax
        push eax
        mov eax, dword [dbdlgrects+88h]
        mov esi, dword [dbdlgrects+80h]
        sub eax, esi
        inc eax
        push eax
        lea eax, [byte ecx+013h]
        push eax
        lea eax, [byte esi+0Ah]
        push eax
        call FillRect
        add esp, byte 14h
        cmp dword [edi], byte 6
        jg short DrawDbList_n1.1
        and word [fdlgmask], 6FCh
        mov eax, dword [edi]
        dec eax
        cmp eax, byte 5
        ja near DrawDbList_n1.2
        jmp dword [nosplit cs:eax*4+DrawDbList_jt]
DrawDbList_n6:
        or byte [fdlgmask+1], 80h
DrawDbList_n5:
        or byte [fdlgmask+1], 40h
DrawDbList_n4:
        or byte [fdlgmask+1], 20h
DrawDbList_n3:
        or byte [fdlgmask+1], 10h
DrawDbList_n2:
        or byte [fdlgmask+1], 8
DrawDbList_n1:
        or byte [fdlgmask+1], 4
        jmp near .2
.1:
        or word [fdlgmask], 0F903h
        mov ebp, dword [dbdlgrects+80h]
        add ebp, byte 0Ah
        mov edx, dword [byte edi+08h]
        mov eax, edx
        shl eax, 3
        add eax, edx
        shl eax, 3
        sub eax, edx
        add eax, eax
        mov edx, eax
        sar edx, 1Fh
        idiv dword [edi]
        mov ebx, dword [dbdlgrects+84h]
        add ebx, byte 13h
        lea esi, [ebx+eax]
        mov eax, dword [dbdlgrects+88h]
        add eax, byte 0Ah
        mov dword [esp], eax
        mov edx, dword [byte edi+0Ch]
        inc edx
        mov eax, edx
        shl eax, 3
        add eax, edx
        shl eax, 3
        sub eax, edx
        add eax, eax
        mov edx, eax
        sar edx, 1Fh
        idiv dword [edi]
        lea edi, [ebx+eax]
        push byte 7Dh
        push esi
        mov eax, dword [dbdlgrects+88h]
        add eax, byte 9
        push eax
        push esi
        push ebp
        call FillRectColor
        add esp, byte 14h
        push byte 7Dh
        lea eax, [byte edi-01h]
        push eax
        push ebp
        push esi
        push ebp
        call FillRectColor
        add esp, byte 14h
        push byte 7Bh
        push edi
        mov eax, dword [byte esp+08h]
        push eax
        inc esi
        push esi
        push eax
        call FillRectColor
        add esp, byte 14h
        push byte 7Bh
        push edi
        mov ebx, dword [byte esp+08h]
        push ebx
        push edi
        inc ebp
        push ebp
        call FillRectColor
        add esp, byte 14h
.2:
        mov eax, dword [fdlgtab]
        cmp eax, byte 1
        jb short .3
        jbe short .4
        cmp eax, byte 2
        je short .5
        jmp short .7
.3:
        test eax, eax
        jne short .7
        push byte 4Bh
        push dword 0A3h
        mov edi, dword [fdlg_tabexh]
        push edi
        jmp short .6
.4:
        push byte 4Bh
        push dword 0A3h
        mov esi, dword [fdlg_tabpo]
        push esi
        jmp short .6
.5:
        push byte 4Bh
        push dword 0A3h
        mov ecx, dword [fdlg_tablp]
        push ecx
.6:
        call DrawArt
        add esp, byte 0Ch
.7:
        mov eax, dword [byte esp+04h]
        add esp, byte 8
        jmp near DbDialog_epilogue
%endif ; C
;-----------------------------------------------------------------------------
; DbDialogLoop                                 72DE7  95 PC, medium confidence
; Database dialog input loop: tabs, list selection / scrolling, Open
; (OpenSelectedDb, LoadBothRosterLists, DrawEditRosters), Delete
; (DeleteSelectedDb), Done
;-----------------------------------------------------------------------------
; C: src/pc/database_dialogs/LoadDbDialogShapes.c (DbDialogLoop)
%ifdef CBUILD
%include "c/pc/database_dialogs/LoadDbDialogShapes.DbDialogLoop.inc"
%else
DbDialogLoop:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 1Ch
        xor edx, edx
        mov dword [byte esp+018h], edx
        lea eax, [byte esp+010h]
        push eax
        lea eax, [byte esp+018h]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov eax, dword [byte esp+014h]
        mov dword [byte esp+0Ch], eax
        mov eax, dword [byte esp+010h]
        mov dword [byte esp+08h], eax
        call SetScreenTarget
        mov eax, dword [pointerspr]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        inc eax
        inc edx
        imul eax, edx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_Pointer12
        call AllocMemBlock
        add esp, byte 0Ch
        mov ebp, eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov edx, dword [pointerspr]
        mov dx, word [byte edx+04h]
        inc edx
        mov word [byte eax+04h], dx
        mov edx, dword [pointerspr]
        mov dx, word [byte edx+06h]
        inc edx
        mov word [byte eax+06h], dx
        mov ebx, dword [byte esp+08h]
        push ebx
        mov edx, dword [byte esp+010h]
        sub edx, byte 4
        push edx
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov ecx, dword [byte esp+08h]
        push ecx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        mov esi, dword [pointerspr]
        push esi
        call DrawArt
        add esp, byte 0Ch
        mov esi, dword [fdlgtab]
        mov esi, dword [nosplit esi*4+dbtablists]
        call ClearInputQueue
.1:
        xor edi, edi
        mov dword [byte esp+04h], edi
.2:
        call GetInputEvent
        test eax, eax
        je short .3
        lea ebx, [byte esp+08h]
        lea edx, [byte esp+0Ch]
        call dword [ptrupdatefn]
        mov dword [byte esp+04h], eax
        test eax, eax
        je short DbDialogLoop.2
.3:
        cmp dword [byte esp+04h], byte 0
        jne near .6
        mov eax, dword [byte esp+0Ch]
        cmp eax, dword [byte esp+014h]
        jne short .4
        mov eax, dword [byte esp+08h]
        cmp eax, dword [byte esp+010h]
        je short DbDialogLoop.1
.4:
        call SetScreenTarget
        mov ecx, dword [byte esp+010h]
        push ecx
        mov eax, dword [byte esp+018h]
        sub eax, byte 4
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [byte esp+08h]
        push edi
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [byte esp+08h]
        push eax
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        mov edx, dword [pointerspr]
        push edx
.5:
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+0Ch]
        mov dword [byte esp+014h], eax
        mov eax, dword [byte esp+08h]
        mov dword [byte esp+010h], eax
        jmp near DbDialogLoop.1
.6:
        mov edx, dword [byte esp+010h]
        push edx
        mov eax, dword [byte esp+018h]
        sub eax, byte 4
        push eax
        push ebp
        call DrawArtOpaque
        add esp, byte 0Ch
        test byte [byte esp+04h], 1
        je near .14
        test byte [fdlgmask+1], 1
        je near .14
        mov eax, dword [byte esp+014h]
        mov edi, dword [byte esp+08h]
        cmp eax, edi
        jne short .7
        cmp edi, dword [byte esp+010h]
        je near .42
.7:
        mov ebx, esp
        mov edx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        call DbDialogHitTest
        test eax, eax
        je near .13
        cmp dword [esp], byte 8
        jne near .13
        cmp dword [byte esp+018h], byte 0
        je near .12
        mov eax, dword [byte esp+010h]
        sub eax, byte 13h
        sub eax, dword [dbdlgrects+84h]
        mov edx, dword [esi]
        imul edx, eax
        mov eax, edx
        sar edx, 1Fh
        shl edx, 5
        LD sbb, eax, edx
        sar eax, 5
        mov edx, eax
        mov ebx, dword [byte esi+0Ch]
        mov eax, dword [byte esp+010h]
        mov ecx, dword [byte esp+08h]
        cmp eax, ecx
        je near .42
        mov edi, dword [byte esi+08h]
        cmp edx, edi
        jl near .42
        cmp edx, ebx
        jg near .42
        cmp eax, ecx
        jge short .9
        mov edx, ecx
        sub edx, eax
        mov eax, dword [esi]
        imul edx, eax
        mov eax, edx
        sar edx, 1Fh
        shl edx, 5
        LD sbb, eax, edx
        sar eax, 5
        mov edx, eax
        add eax, ebx
        mov ecx, dword [esi]
        cmp eax, ecx
        jge short .8
        add edi, edx
        mov dword [byte esi+08h], edi
        add dword [byte esi+0Ch], edx
        jmp short .11
.8:
        lea eax, [byte ecx-01h]
        mov dword [byte esi+0Ch], eax
        mov eax, dword [esi]
        sub eax, byte 6
        mov dword [byte esi+08h], eax
        jmp short .11
.9:
        jle short .11
        mov edx, eax
        sub edx, ecx
        mov eax, dword [esi]
        imul edx, eax
        mov eax, edx
        sar edx, 1Fh
        shl edx, 5
        LD sbb, eax, edx
        sar eax, 5
        mov edx, eax
        mov eax, edi
        sub eax, edx
        test eax, eax
        jl short .10
        mov dword [byte esi+08h], eax
        sub dword [byte esi+0Ch], edx
        jmp short .11
.10:
        mov dword [byte esi+08h], 0
        mov dword [byte esi+0Ch], 5
.11:
        cmp ebx, dword [byte esi+0Ch]
        je near .42
        jmp near .32
.12:
        mov dword [byte esp+018h], 1
        jmp near .42
.13:
        xor ecx, ecx
        mov dword [byte esp+018h], ecx
        jmp near .42
.14:
        mov dh, byte [byte esp+04h]
        test dh, 2
        je near .41
        xor ebx, ebx
        mov dword [byte esp+018h], ebx
        mov ebx, esp
        mov edx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        call DbDialogHitTest
        test eax, eax
        je near .42
        mov cl, byte [esp]
        mov eax, 1
        shl eax, cl
        mov dword [esp], eax
        mov ecx, dword [fdlgmask]
        test eax, ecx
        je near .42
        cmp eax, byte 10h
        jb short .16
        jbe near .18
        mov eax, ecx
        and al, 0F7h
        mov edx, dword [esp]
        cmp edx, byte 40h
        jb short .15
        jbe near .33
        cmp edx, 80h
        jb near .40
        jbe near .34
        cmp edx, 100h
        je near .25
        jmp near .40
.15:
        cmp edx, byte 20h
        je near .29
        jmp near .40
.16:
        cmp eax, byte 2
        jb short .17
        jbe near .23
        cmp eax, byte 4
        jb near .40
        jbe near .35
        cmp eax, byte 8
        je near .37
        jmp near .40
.17:
        cmp eax, byte 1
        je short .20
        jmp near .40
.18:
        push dword 0BFh
        push byte 23h
        mov ebx, dword [fdlg_cancel]
        push ebx
        call DrawArt
        add esp, byte 0Ch
.19:
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        jmp near .36
.20:
        push byte 46h
        push byte 18h
        mov edi, dword [fdlg_up]
        push edi
        call DrawArt
        add esp, byte 0Ch
        cmp dword [byte esi+08h], byte 0
        je short .21
        mov eax, esi
        dec dword [byte esi+08h]
        dec dword [byte esi+0Ch]
        call DrawDbList
.21:
        push byte 46h
        push byte 18h
        mov ecx, dword [fdlg_noarrow]
        push ecx
.22:
        call DrawArt
        add esp, byte 0Ch
        jmp near .42
.23:
        push byte 46h
        push byte 18h
        mov edx, dword [fdlg_down]
        push edx
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esi+0Ch]
        inc eax
        cmp eax, dword [esi]
        jge short .24
        mov eax, esi
        inc dword [byte esi+08h]
        inc dword [byte esi+0Ch]
        call DrawDbList
.24:
        push byte 46h
        push byte 18h
        mov eax, dword [fdlg_noarrow]
        push eax
        jmp short DbDialogLoop.22
.25:
        mov edx, dword [byte esp+08h]
        sub edx, byte 13h
        sub edx, dword [dbdlgrects+84h]
        mov ecx, dword [esi]
        imul edx, ecx
        mov eax, edx
        sar edx, 1Fh
        shl edx, 5
        LD sbb, eax, edx
        sar eax, 5
        mov edx, eax
        cmp eax, dword [byte esi+08h]
        jge short .27
        cmp eax, byte 3
        jge short .26
        mov dword [byte esi+08h], 0
        mov dword [byte esi+0Ch], 5
        jmp short .32
.26:
        sub eax, byte 3
        mov dword [byte esi+08h], eax
        add edx, byte 2
        mov dword [byte esi+0Ch], edx
        jmp short .32
.27:
        cmp edx, dword [byte esi+0Ch]
        jle near .42
        lea eax, [byte edx+03h]
        cmp eax, ecx
        jle short .28
        lea eax, [byte ecx-06h]
        mov dword [byte esi+08h], eax
        mov eax, dword [esi]
        dec eax
        mov dword [byte esi+0Ch], eax
        jmp short .32
.28:
        mov eax, edx
        jmp short DbDialogLoop.26
.29:
        xor edx, edx
        mov dword [fdlgtab], edx
.30:
        mov dword [fdlgmask], eax
.31:
        call DrawDbDialogButtons
        mov esi, dword [fdlgtab]
        mov esi, dword [nosplit esi*4+dbtablists]
.32:
        mov eax, esi
        call DrawDbList
        jmp near .42
.33:
        mov dword [fdlgtab], 1
        jmp short DbDialogLoop.30
.34:
        mov dword [fdlgtab], 2
        or byte [fdlgmask], 8
        jmp short DbDialogLoop.31
.35:
        push dword 0BFh
        push byte 23h
        mov eax, dword [fdlg_open]
        push eax
        call DrawArt
        add esp, byte 0Ch
        push ebp
        call FreeMemBlock
        add esp, byte 4
        call OpenSelectedDb
        call LoadBothRosterLists
        call DrawEditRosters
        mov eax, 1
.36:
        add esp, byte 1Ch
        jmp near DbDialog_epilogue
.37:
        push dword 0BFh
        push byte 23h
        mov ecx, dword [fdlg_del]
        push ecx
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [fdlgtab]
        mov eax, dword [nosplit eax*4+dbtablists]
        call DeleteSelectedDb
        mov esi, dword [fdlgtab]
        test esi, esi
        jge short .38
        xor esi, esi
        jmp short .39
.38:
        mov esi, dword [nosplit esi*4+dbtablists]
.39:
        mov eax, esi
        call DrawDbList
        push dword 0BFh
        push byte 23h
        mov edi, dword [fdlg_none]
        push edi
        jmp near DbDialogLoop.22
.40:
        mov ebx, esp
        mov edx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        call FileDlgHitTest
        mov ebx, dword [esp]
        cmp ebx, byte 9
        jle near DbDialogLoop.32
        mov eax, dword [byte esi+08h]
        add eax, ebx
        sub eax, byte 0Ah
        mov dword [byte esi+04h], eax
        jmp near DbDialogLoop.32
.41:
        test dh, 4
        jne near DbDialogLoop.19
.42:
        mov ebx, dword [byte esp+08h]
        push ebx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov ecx, dword [byte esp+08h]
        push ecx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        mov edi, dword [pointerspr]
        push edi
        jmp near DbDialogLoop.5
%endif ; C
;-----------------------------------------------------------------------------
; OpenSelectedDb                                                  733C4  95 PC
; By tab: "Current" (.DB), "Original" (.ORG) or <name>.DBX directory: sets
; curdbname and LoadDbsFromDir
;-----------------------------------------------------------------------------
; C: src/pc/database_dialogs/OpenSelectedDb.c
%ifdef CBUILD
%include "c/pc/database_dialogs/OpenSelectedDb.inc"
%else
OpenSelectedDb:
        push dword 20h
        call __CHK
        push edx
        push esi
        push edi
        sub esp, byte 10h
        mov edi, esp
        mov esi, unk13_722FE
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [fdlgtab]
        cmp eax, byte 1
        jb short .1
        jbe short .2
        cmp eax, byte 2
        je short .3
        jmp short .x
.1:
        test eax, eax
        jne short .x
        mov edi, curdbname
        mov esi, str_Current4
        movsd
        movsd
        mov edx, str_extDB
        jmp short .4
.2:
        mov edi, curdbname
        mov esi, str_Original2
        movsd
        movsd
        movsb
        mov edx, str_ORG
        jmp short .4
.3:
        mov eax, dword [dblisttemp+4]
        mov edx, dword [nosplit eax*4+dblisttempnames]
        mov eax, esp
        call strcpy_
        mov edx, esp
        mov eax, curdbname
        call strcpy_
        mov edx, str_DBX2
        mov eax, esp
        call strcat_
        mov edx, str_extDB
.4:
        mov eax, esp
        call LoadDbsFromDir
.x:
        add esp, byte 10h
        pop edi
        pop esi
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadDbsFromDir                                                  7345B  95 PC
; (dir, ext): FreeLeagueDbsMem then loads the six DBs into memory, dbdirty =
; 0
;-----------------------------------------------------------------------------
; C: src/pc/database_dialogs/LoadDbsFromDir.c
%ifdef CBUILD
%include "c/pc/database_dialogs/LoadDbsFromDir.inc"
%else
LoadDbsFromDir:
        push dword 3Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 20h
        mov edi, eax
        mov esi, edx
        call FreeLeagueDbsMem
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, edx
        mov edx, edi
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [seasondb], eax
        mov eax, esp
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [seasondb_size], eax
        mov ebx, dword [leaguedbnames+4]
        mov ecx, esi
        mov edx, edi
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [careerdb], eax
        mov eax, esp
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [careerdb_size], eax
        mov ebx, dword [leaguedbnames+0Ch]
        mov ecx, esi
        mov edx, edi
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [carteamsdb], eax
        mov eax, esp
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [carteamsdb_size], eax
        mov ebx, dword [leaguedbnames]
        mov ecx, esi
        mov edx, edi
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [keydb], eax
        mov eax, esp
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [keydb_size], eax
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, esi
        mov edx, edi
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [teamsdb], eax
        mov eax, esp
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [teamsdb_size], eax
        mov ebx, dword [leaguedbnames+8]
        mov ecx, esi
        mov edx, edi
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [attdb], eax
        mov eax, esp
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [attdb_size], eax
        xor edx, edx
        mov dword [dbdirty], edx
        add esp, byte 20h
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DeleteSelectedDb                                                735C3  95 PC
; (list): "Confirm deletion of the database:" <name>, DeleteDir of
; <name>.DBX, removes it from the list and fixes tab / scroll state
;-----------------------------------------------------------------------------
; C: src/pc/database_dialogs/LoadDbDialogShapes.c (DeleteSelectedDb)
%ifdef CBUILD
%include "c/pc/database_dialogs/LoadDbDialogShapes.DeleteSelectedDb.inc"
%else
DeleteSelectedDb:
        push dword 70h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 44h
        mov esi, eax
        mov dword [byte esp+040h], 140h
        mov dword [byte esp+03Ch], 0F0h
        mov eax, dword [byte eax+04h]
        mov eax, dword [byte esi+eax*4+010h]
        mov dword [deldbmsg+4], eax
        push byte 0FFFFFFFFh
        lea eax, [byte esp+040h]
        push eax
        lea eax, [byte esp+048h]
        push eax
        push byte 2
        push btn_POHumanOut
        mov ecx, 2
        mov ebx, deldbmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        cmp eax, byte 1
        jne near .10
        mov edx, dword [byte esi+04h]
        mov edx, dword [byte esi+edx*4+010h]
        lea eax, [byte esp+02Ch]
        call strcpy_
        mov edx, str_DBX2
        lea eax, [byte esp+02Ch]
        call strcat_
        mov ebx, esp
        mov edx, 10h
        lea eax, [byte esp+02Ch]
        call unknown_libname_1
        test eax, eax
        jne near .10
        test byte [byte esp+015h], 10h
        je short .1
        lea eax, [byte esp+01Eh]
        call DeleteDir
.1:
        mov ecx, dword [esi]
        dec ecx
        mov dword [esi], ecx
        je short .6
        mov edx, dword [byte esi+04h]
        jmp short .3
.2:
        mov eax, edx
        mov ebx, dword [byte esi+eax*4+014h]
        mov dword [byte esi+eax*4+010h], ebx
        inc edx
.3:
        mov edi, dword [esi]
        cmp edx, edi
        jl short DeleteSelectedDb.2
        cmp edi, byte 6
        jge short .4
        lea eax, [byte edi-01h]
        mov dword [byte esi+0Ch], eax
        mov dword [byte esi+08h], 0
        jmp short .5
.4:
        cmp edi, dword [byte esi+0Ch]
        jne short .5
        dec dword [byte esi+08h]
        dec dword [byte esi+0Ch]
.5:
        mov eax, dword [byte esi+04h]
        cmp eax, dword [esi]
        jne short .10
        dec dword [byte esi+04h]
        jmp short .10
.6:
        and byte [fdlgmask], 77h
        cmp dword [dblistcur], byte 0
        je short .7
        mov dword [fdlgtab], ecx
        jmp short .9
.7:
        cmp dword [dblistorig], byte 0
        je short .8
        mov dword [fdlgtab], 1
        jmp short .9
.8:
        mov dword [fdlgtab], 0FFFFFFFFh
        mov dword [fdlgmask], 10h
.9:
        call DrawDbDialogButtons
.10:
        xor eax, eax
        add esp, byte 44h
        jmp near DbDialog_ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuOpenDatabase                                                73703  95 PC
; Edit Rosters menu action: ScanDbFiles, pointer copy, LoadDbDialogShapes,
; DrawDbDialog, DbDialogLoop, frees the shapes
;-----------------------------------------------------------------------------
; C: src/pc/database_dialogs/LoadDbDialogShapes.c (MenuOpenDatabase)
%ifdef CBUILD
%include "c/pc/database_dialogs/LoadDbDialogShapes.MenuOpenDatabase.inc"
%else
MenuOpenDatabase:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        call ScanDbFiles
        push byte 20h
        push dword 0BC03h
        push str_Buf2
        call AllocMemBlock
        mov ebp, eax
        add esp, byte 0Ch
        mov dword [esp], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov word [byte eax+04h], 0F3h
        mov word [byte eax+06h], 0C6h
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        call LoadDbDialogShapes
        call DrawDbDialog
        call DrawDbDialogButtons
        call DbDialogLoop
        test eax, eax
        jne short .1
        push byte 13h
        push byte 0Ah
        push ebp
        call DrawArtOpaque
        add esp, byte 0Ch
.1:
        mov edx, dword [fdlgshapes]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [fdlgshapes], ebx
        mov ecx, dword [esp]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        add esp, byte 4
        jmp near DbDialog_epilogue
%endif ; C
