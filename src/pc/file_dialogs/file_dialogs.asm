; The Open and Delete dialogs for a saved game.
bits 32
%include "hockey.inc"
section s_2B7B7 progbits alloc exec nowrite align=1
extern __CHK, btn_POHumanOut, BuildSavedGameLabels, cddriveptr, ClearInputQueue, CopyFile, DeleteDir, delmsgbox
extern EditPlayoffSettings, exhfilenames, exhfiles, exhstate, FatalError, fdlg_arrow, fdlg_cancel, fdlg_del
extern fdlg_down, fdlg_noarrow, fdlg_none, fdlg_open, fdlg_tabexh, fdlg_tablp, fdlg_tabnone, fdlg_tabpo
extern fdlg_up, fdlgmask, fdlgrects, fdlgshapes, fdlgtab, FileClose, FileCreate, fileoncd
extern FileOpenRead, FileReadAt, FileWriteAt, FreeMemBlock, gameresult, GetInputEvent, j_unlink_, leaguemgrmenu
extern lgfilenames, lgfiles, lgstate, LoadModeState, MakePath, menuact_export, menuact_nextlg, menuact_nextpo
extern menuact_pohilights, menuact_posettings, MenuExportDbs, MenuNewExhibition, MenuNextLeagueGame, menusub_lgmgr, MessageBox, MouseSetPos
extern musicon, off_C5441, fdlgfilelists, fdlgfilelists_e01, fdlgfilelists_e02, othergames, otherperiod, otherscores
extern PlayoffModeLoop, pofilenames, pofiles, pointerspr, postate, ptrupdatefn, qsort_, savefname
extern seriesgameno, SetDialogColors, SetupStatsSourceMenu, str_Arro, str_Buf, str_Can, str_Db2, str_Dbox
extern str_Del, str_Delete, str_Dialogbx, str_Done, str_Down, str_Exhibition, str_ExhibitionGameCalled, str_feA1
extern str_feA2, str_fec6, str_fed2, str_fed3, str_fed4, str_fedd2, str_feh7, str_fek1
extern str_fek2, str_fek3, str_fek4, str_fek5, str_fek6, str_fek7, str_fek8, str_fel1
extern str_fel2, str_GameSav3, str_GameSet3, str_Gsummary, str_GsummaryDb3, str_Gtex, str_Gtlp, str_Gtno
extern str_Gtpo, str_LAAtMTL, str_League, str_LeagueCalled, str_LP, str_Lp, str_Lp2, str_LpGameSav
extern str_Nhl, str_NHL, str_Nhl2, str_Noar, str_None, str_Open, str_Open2, str_OpenBut
extern str_Playoffs, str_PlayOffSeriesCalled, str_Po, str_PO2, str_Po2, str_PoGameSav, str_Pointer5, str_Sav
extern str_ScheduleDb2, str_Up, strcat_, strcmp_, strcpy_, stricmp_, strncpy_, AllocMemBlock
extern LoadBank, OpenArtArchiveErr, TextSetColors, PutBlock, FillRect, DrawArtOpaque, DrawArtKeyFF, DrawArt
extern GrabBlock, PrintString, TextPrintAt, MouseRead, FindShape, FindFirstFile, SetScreenTarget, FillRectColor
extern teamabbrevs, _dos_findfirst_, _dos_findnext_, unlink_, ViewPlayoffHilights
global savefileexts, LoadFileDlgShapes, LoadFileDlgShapes_x, MenuOpenSaved, DrawFileDlgTabs, CmpFileNames, ScanSavedGames, PrintTextCopy
global DrawFileDlg_jt, DrawFileDlg, DrawFileDlg_n6, DrawFileDlg_n5, DrawFileDlg_n4, DrawFileDlg_n3, DrawFileDlg_n2, DrawFileDlg_n1
global DrawFileDlg_x, FileDlgHitTest, DrawFileDlgList_jt, DrawFileDlgList, DrawFileDlgList_n6, DrawFileDlgList_n5, DrawFileDlgList_n4, DrawFileDlgList_n3
global DrawFileDlgList_n2, DrawFileDlgList_n1, RunFileDlg, DeleteSavedGame, SelectSavedFile, ReadGameSettings, gsuminitff
savefileexts:
        dd str_NHL
        dd str_PO2
        dd str_LP
;-----------------------------------------------------------------------------
; LoadFileDlgShapes                                               2B7C3  95 PC
; Opens open_but and fetches the dialog button / tab shapes (none, del, open,
; can, noar, up, down, arro, gtno, gtex, gtlp, gtpo)
;-----------------------------------------------------------------------------
; C: src/pc/file_dialogs/LoadFileDlgShapes.c
%ifdef CBUILD
%include "c/pc/file_dialogs/LoadFileDlgShapes.inc"
%else
LoadFileDlgShapes:
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
        mov ebx, str_OpenBut
        cmp byte [fileoncd+01C6h], 1
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
        push str_None
        push eax
        call FindShape
        add esp, byte 8
        mov dword [fdlg_none], eax
        push str_Del
        mov ebx, dword [fdlgshapes]
        push ebx
        call FindShape
        add esp, byte 8
        mov dword [fdlg_del], eax
        push str_Open
        mov ecx, dword [fdlgshapes]
        push ecx
        call FindShape
        add esp, byte 8
        mov dword [fdlg_open], eax
        push str_Can
        mov esi, dword [fdlgshapes]
        push esi
        call FindShape
        add esp, byte 8
        mov dword [fdlg_cancel], eax
        push str_Noar
        mov edi, dword [fdlgshapes]
        push edi
        call FindShape
        add esp, byte 8
        mov dword [fdlg_noarrow], eax
        push str_Up
        mov ebp, dword [fdlgshapes]
        push ebp
        call FindShape
        add esp, byte 8
        mov dword [fdlg_up], eax
        push str_Down
        mov eax, dword [fdlgshapes]
        push eax
        call FindShape
        add esp, byte 8
        mov dword [fdlg_down], eax
        push str_Arro
        mov edx, dword [fdlgshapes]
        push edx
        call FindShape
        add esp, byte 8
        mov dword [fdlg_arrow], eax
        push str_Gtno
        mov ebx, dword [fdlgshapes]
        push ebx
        call FindShape
        add esp, byte 8
        mov dword [fdlg_tabnone], eax
        push str_Gtex
        mov ecx, dword [fdlgshapes]
        push ecx
        call FindShape
        add esp, byte 8
        mov dword [fdlg_tabexh], eax
        push str_Gtlp
        mov esi, dword [fdlgshapes]
        push esi
        call FindShape
        add esp, byte 8
        mov dword [fdlg_tablp], eax
        push str_Gtpo
        mov edi, dword [fdlgshapes]
        push edi
        call FindShape
        add esp, byte 8
        mov dword [fdlg_tabpo], eax
.2:
        add esp, byte 20h
LoadFileDlgShapes_x:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuOpenSaved                                                   2B944  95 PC
; "Open ..." menu action: scans saves, runs the file dialog, then resumes the
; chosen Exhibition (MenuNewExhibition), Play-Off (PlayoffModeLoop) or League
; (MenuNextLeagueGame) save
;-----------------------------------------------------------------------------
; C: src/pc/file_dialogs/MenuOpenSaved.c
%ifdef CBUILD
%include "c/pc/file_dialogs/MenuOpenSaved.inc"
%else
MenuOpenSaved:
        push dword 58h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 34h
        call ScanSavedGames
        push byte 20h
        push dword 0B825h
        push str_Buf
        call AllocMemBlock
        mov ebp, eax
        add esp, byte 0Ch
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov word [byte eax+04h], 0EEh
        mov word [byte eax+06h], 0C6h
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        call LoadFileDlgShapes
        call DrawFileDlg
        call DrawFileDlgTabs
        call RunFileDlg
        mov esi, eax
        push byte 13h
        push byte 0Ah
        push ebp
        call DrawArtOpaque
        add esp, byte 0Ch
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [fdlgshapes]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [fdlgshapes], ebx
        call BuildSavedGameLabels
        xor eax, eax
        call SetupStatsSourceMenu
        test esi, esi
        je near .21
        mov eax, dword [fdlgtab]
        cmp eax, byte 1
        jb short .1
        jbe near .13
        cmp eax, byte 2
        je near .18
        jmp near .21
.1:
        test eax, eax
        jne near .21
        mov eax, 1
        call SetupStatsSourceMenu
        mov eax, dword [lgfiles+4]
        mov edx, dword [nosplit eax*4+lgfilenames]
        mov eax, esp
        call strcpy_
        mov edx, str_Nhl
        mov eax, esp
        call strcat_
        lea edx, [byte esp+030h]
        mov eax, esp
        call FileOpenRead
        test eax, eax
        je short .2
        push str_fek1
        call FatalError
        add esp, byte 4
.2:
        lea edx, [byte esp+02Ch]
        mov eax, str_GsummaryDb3
        call FileCreate
        test eax, eax
        je short .3
        push str_fek2
        call FatalError
        add esp, byte 4
.3:
        mov ecx, 0Bh
        mov ebx, 75h
        lea edx, [byte esp+020h]
        mov eax, dword [byte esp+030h]
        call FileReadAt
        test eax, eax
        je short .4
        push str_fek3
        call FatalError
        add esp, byte 4
.4:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        lea edx, [byte esp+020h]
        mov eax, dword [byte esp+02Ch]
        call FileWriteAt
        test eax, eax
        je short .5
        push str_fek4
        call FatalError
        add esp, byte 4
.5:
        mov edi, dword [byte esp+023h]
        sar edi, 10h
        xor esi, esi
        jmp short .9
.6:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        lea edx, [byte esp+020h]
        mov eax, dword [byte esp+030h]
        call FileReadAt
        test eax, eax
        je short .7
        push str_fek5
        call FatalError
        add esp, byte 4
.7:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        lea edx, [byte esp+020h]
        mov eax, dword [byte esp+02Ch]
        call FileWriteAt
        test eax, eax
        je short .8
        push str_fek6
        call FatalError
        add esp, byte 4
.8:
        inc esi
.9:
        cmp esi, edi
        jl short MenuOpenSaved.6
        lea eax, [byte esp+02Ch]
        call FileClose
        mov ecx, 0Ch
        mov ebx, 0FFFFFFFFh
        mov edx, othergames
        mov eax, dword [byte esp+030h]
        call FileReadAt
        test eax, eax
        je short .10
        push str_fek7
        call FatalError
        add esp, byte 4
.10:
        mov ecx, 0Ch
        mov ebx, 0FFFFFFFFh
        mov edx, otherscores
        mov eax, dword [byte esp+030h]
        call FileReadAt
        test eax, eax
        je short .11
        push str_fek8
        call FatalError
        add esp, byte 4
.11:
        mov ecx, 18h
        mov ebx, 0FFFFFFFFh
        mov edx, otherperiod
        mov eax, dword [byte esp+030h]
        call FileReadAt
        test eax, eax
        je short .12
        push str_feh7
        call FatalError
        add esp, byte 4
.12:
        and byte [exhstate+5Ah], 7Fh
        lea eax, [byte esp+030h]
        call MenuNewExhibition
        mov edx, eax
        xor eax, eax
        call SetupStatsSourceMenu
        mov eax, edx
        jmp near .x
.13:
        push postate+4
        mov ecx, postate+4
        mov ebx, str_Db2
        mov edx, str_Sav
        mov eax, str_Gsummary
        call CopyFile
        test eax, eax
        je short .14
        push str_feA1
        call FatalError
        add esp, byte 4
.14:
        mov eax, 2
        call SetupStatsSourceMenu
        mov eax, dword [pofiles+4]
        mov edx, dword [nosplit eax*4+pofilenames]
        mov eax, esp
        call strcpy_
        mov edx, str_PoGameSav
        mov eax, esp
        call strcat_
        lea edx, [byte esp+030h]
        mov eax, esp
        call FileOpenRead
        test eax, eax
        je short .15
        push str_fel1
        call FatalError
        add esp, byte 4
.15:
        and byte [postate+5Ah], 7Fh
        lea eax, [byte esp+030h]
        call PlayoffModeLoop
        mov edi, eax
        test byte [postate+5Ah], 80h
.16:
        jne short .17
        cmp dword [gameresult], byte 1
        jne short .17
        mov eax, esp
        call j_unlink_
.17:
        xor eax, eax
        call SetupStatsSourceMenu
        mov eax, edi
        jmp near .x
.18:
        push lgstate+4
        mov ecx, lgstate+4
        mov ebx, str_Db2
        mov edx, str_Sav
        mov eax, str_Gsummary
        call CopyFile
        test eax, eax
        je short .19
        push str_feA2
        call FatalError
        add esp, byte 4
.19:
        mov eax, 3
        call SetupStatsSourceMenu
        mov eax, dword [exhfiles+4]
        mov edx, dword [nosplit eax*4+exhfilenames]
        mov eax, esp
        call strcpy_
        mov edx, str_LpGameSav
        mov eax, esp
        call strcat_
        lea edx, [byte esp+030h]
        mov eax, esp
        call FileOpenRead
        test eax, eax
        je short .20
        push str_fel2
        call FatalError
        add esp, byte 4
.20:
        and byte [lgstate+5Ah], 7Fh
        lea eax, [byte esp+030h]
        call MenuNextLeagueGame
        mov edi, eax
        test byte [lgstate+5Ah], 80h
        jmp near MenuOpenSaved.16
.21:
        xor eax, eax
.x:
        add esp, byte 34h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawFileDlgTabs                              2BD16  95 PC, medium confidence
; Draws Open / Delete / Done and the Exhibition / Playoffs / League tab
; labels for the current tab
;-----------------------------------------------------------------------------
; C: src/pc/file_dialogs/LoadFileDlgShapes.c (DrawFileDlgTabs)
%ifdef CBUILD
%include "c/pc/file_dialogs/LoadFileDlgShapes.DrawFileDlgTabs.inc"
%else
DrawFileDlgTabs:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        push dword 0FFh
        push dword 0F8h
        call TextSetColors
        add esp, byte 8
        cmp dword [fdlgtab], byte 0
        jge near .1
        push dword 0C0h
        push byte 2Ah
        push str_Open2
        call PrintString
        add esp, byte 0Ch
        push dword 0C0h
        push byte 6Bh
        push str_Delete
        call PrintString
        add esp, byte 0Ch
        push dword 0FFh
        push dword 0FAh
        call TextSetColors
        add esp, byte 8
        push dword 0C0h
        push dword 0B8h
        push str_Done
        call PrintString
        add esp, byte 0Ch
        push dword 0FFh
        push dword 0F8h
        call TextSetColors
        add esp, byte 8
        push byte 4Ch
        push dword 0A7h
        push str_Exhibition
        call PrintString
        add esp, byte 0Ch
        push byte 64h
        push dword 0ABh
        push str_Playoffs
        call PrintString
        add esp, byte 0Ch
        push byte 7Ch
        push dword 0B0h
        push str_League
        call PrintString
        add esp, byte 0Ch
        push byte 46h
        push byte 18h
        mov edx, dword [fdlg_noarrow]
        push edx
        call DrawArt
        add esp, byte 0Ch
        push byte 4Bh
        push dword 0A3h
        mov ebx, dword [fdlg_tabnone]
        push ebx
        jmp near .10
.1:
        test byte [fdlgmask], 80h
        jne short .2
        push byte 7Ch
        push dword 0B0h
        push str_League
        call PrintString
        add esp, byte 0Ch
.2:
        test byte [fdlgmask], 40h
        jne short .3
        push byte 64h
        push dword 0ABh
        push str_Playoffs
        call PrintString
        add esp, byte 0Ch
.3:
        test byte [fdlgmask], 20h
        jne short .4
        push byte 4Ch
        push dword 0A7h
        push str_Exhibition
        call TextPrintAt
        add esp, byte 0Ch
.4:
        mov eax, dword [fdlgtab]
        mov eax, dword [nosplit eax*4+fdlgfilelists]
        cmp dword [eax], byte 6
        jg short .5
        push byte 46h
        push byte 18h
        mov esi, dword [fdlg_noarrow]
        push esi
        jmp short .6
.5:
        push byte 46h
        push byte 18h
        mov ecx, dword [fdlg_arrow]
        push ecx
.6:
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [fdlgtab]
        cmp eax, byte 1
        jb short .7
        jbe short .8
        cmp eax, byte 2
        je short .9
        jmp near LoadFileDlgShapes_x
.7:
        test eax, eax
        jne near LoadFileDlgShapes_x
        push byte 4Bh
        push dword 0A3h
        mov eax, dword [fdlg_tabexh]
        push eax
        jmp short .10
.8:
        push byte 4Bh
        push dword 0A3h
        mov ebp, dword [fdlg_tabpo]
        push ebp
        jmp short .10
.9:
        push byte 4Bh
        push dword 0A3h
        mov edi, dword [fdlg_tablp]
        push edi
.10:
        call DrawArt
        add esp, byte 0Ch
        jmp near LoadFileDlgShapes_x
%endif ; C
;-----------------------------------------------------------------------------
; CmpFileNames                                                    2BEEA  95 PC
; Qsort comparator: strcmp(*a, *b); also used by database_dialogs
;-----------------------------------------------------------------------------
; C: src/pc/file_dialogs/CmpFileNames.c
%ifdef CBUILD
%include "c/pc/file_dialogs/CmpFileNames.inc"
%else
CmpFileNames:
        push dword 4
        call __CHK
        mov edx, dword [edx]
        mov eax, dword [eax]
        jmp near strcmp_
%endif ; C
;-----------------------------------------------------------------------------
; ScanSavedGames                                                  2BEFD  95 PC
; Findfirst / findnext over *.lp, *.po, *.nhl into the three per-tab file
; lists, qsort CmpFileNames
;-----------------------------------------------------------------------------
; C: src/pc/file_dialogs/LoadFileDlgShapes.c (ScanSavedGames)
%ifdef CBUILD
%include "c/pc/file_dialogs/LoadFileDlgShapes.ScanSavedGames.inc"
%else
ScanSavedGames:
        push dword 48h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 2Ch
        xor esi, esi
        mov dword [exhfiles], esi
        mov ebx, esp
        mov edx, 10h
        mov eax, str_Lp
        call _dos_findfirst_
        test eax, eax
        jne near .7
.1:
        mov edx, savefname
        add edx, esi
        mov eax, dword [exhfiles]
        mov dword [nosplit eax*4+exhfilenames], edx
        xor eax, eax
.2:
        mov dl, byte [byte esp+eax+01Eh]
        test dl, dl
        je short .3
        cmp dl, 2Eh
        je short .3
        mov byte [dword esi+savefname], dl
        inc eax
        inc esi
        cmp eax, byte 8
        jl short ScanSavedGames.2
.3:
        xor bl, bl
        mov byte [dword esi+savefname], bl
        inc esi
        mov ebx, dword [exhfiles]
        inc ebx
        mov dword [exhfiles], ebx
        cmp ebx, byte 20h
        jge short .4
        mov eax, esp
        call _dos_findnext_
        test eax, eax
        je short ScanSavedGames.1
.4:
        mov edx, dword [exhfiles]
        mov ecx, CmpFileNames
        mov ebx, 4
        mov eax, exhfilenames
        call qsort_
        xor edi, edi
        mov dword [exhfiles+8], edi
        mov dword [exhfiles+4], edi
        mov eax, dword [exhfiles]
        cmp eax, byte 6
        jge short .5
        dec eax
        jmp short .6
.5:
        mov eax, 5
.6:
        mov dword [exhfiles+0Ch], eax
.7:
        xor edx, edx
        mov dword [pofiles], edx
        mov ebx, esp
        mov edx, 10h
        mov eax, str_Po
        call _dos_findfirst_
        test eax, eax
        jne near .14
.8:
        mov edx, savefname
        add edx, esi
        mov eax, dword [pofiles]
        mov dword [nosplit eax*4+pofilenames], edx
        xor eax, eax
.9:
        mov bh, byte [byte esp+eax+01Eh]
        test bh, bh
        je short .10
        cmp bh, 2Eh
        je short .10
        mov byte [dword esi+savefname], bh
        inc eax
        inc esi
        cmp eax, byte 8
        jl short ScanSavedGames.9
.10:
        xor ch, ch
        mov byte [dword esi+savefname], ch
        inc esi
        mov ebx, dword [pofiles]
        inc ebx
        mov dword [pofiles], ebx
        cmp ebx, byte 20h
        jge short .11
        mov eax, esp
        call _dos_findnext_
        test eax, eax
        je short ScanSavedGames.8
.11:
        mov edx, dword [pofiles]
        mov ecx, CmpFileNames
        mov ebx, 4
        mov eax, pofilenames
        call qsort_
        xor edi, edi
        mov dword [pofiles+8], edi
        mov dword [pofiles+4], edi
        mov eax, dword [pofiles]
        cmp eax, byte 6
        jge short .12
        dec eax
        jmp short .13
.12:
        mov eax, 5
.13:
        mov dword [pofiles+0Ch], eax
.14:
        xor edx, edx
        mov dword [lgfiles], edx
        mov ebx, esp
        mov eax, str_Nhl2
        call _dos_findfirst_
        test eax, eax
        jne near .21
.15:
        mov edx, savefname
        add edx, esi
        mov eax, dword [lgfiles]
        mov dword [nosplit eax*4+lgfilenames], edx
        xor eax, eax
.16:
        mov dl, byte [byte esp+eax+01Eh]
        test dl, dl
        je short .17
        cmp dl, 2Eh
        je short .17
        mov byte [dword esi+savefname], dl
        inc eax
        inc esi
        cmp eax, byte 8
        jl short ScanSavedGames.16
.17:
        xor bl, bl
        mov byte [dword esi+savefname], bl
        inc esi
        mov ebx, dword [lgfiles]
        inc ebx
        mov dword [lgfiles], ebx
        cmp ebx, byte 20h
        jge short .18
        mov eax, esp
        call _dos_findnext_
        test eax, eax
        je short ScanSavedGames.15
.18:
        mov edx, dword [lgfiles]
        mov ecx, CmpFileNames
        mov ebx, 4
        mov eax, lgfilenames
        call qsort_
        xor esi, esi
        mov dword [lgfiles+8], esi
        mov dword [lgfiles+4], esi
        mov ebp, dword [lgfiles]
        cmp ebp, byte 6
        jge short .19
        lea eax, [byte ebp-01h]
        jmp short .20
.19:
        mov eax, 5
.20:
        mov dword [lgfiles+0Ch], eax
.21:
        add esp, byte 2Ch
        jmp near LoadFileDlgShapes_x
%endif ; C
;-----------------------------------------------------------------------------
; PrintTextCopy                                2C135  95 PC, medium confidence
; Copies the string to a local buffer and draws it with PrintString; also
; used by database_dialogs
;-----------------------------------------------------------------------------
; C: src/pc/file_dialogs/PrintTextCopy.c
%ifdef CBUILD
%include "c/pc/file_dialogs/PrintTextCopy.inc"
%else
PrintTextCopy:
        push dword 58h
        call __CHK
        push ecx
        push esi
        sub esp, byte 40h
        mov ecx, eax
        mov esi, edx
        xor eax, eax
        jmp short .2
.1:
        mov dl, byte [edx]
        mov byte [esp+eax], dl
        inc eax
.2:
        lea edx, [ecx+eax]
        cmp byte [edx], 0
        jne short PrintTextCopy.1
        xor dl, dl
        mov byte [esp+eax], dl
        push ebx
        push esi
        lea eax, [byte esp+08h]
        push eax
        call PrintString
        add esp, byte 0Ch
        add esp, byte 40h
        pop esi
        pop ecx
        ret
%endif ; C
        db 08Dh,040h,00h
DrawFileDlg_jt:
        dd DrawFileDlg_n1
        dd DrawFileDlg_n2
        dd DrawFileDlg_n3
        dd DrawFileDlg_n4
        dd DrawFileDlg_n5
        dd DrawFileDlg_n6
;-----------------------------------------------------------------------------
; DrawFileDlg                                  2C18F  95 PC, medium confidence
; Dialogbx / dbox frame, file list rows, sets the item mask fdlgmask (bits
; per visible row, _jt cases)
;-----------------------------------------------------------------------------
; C: src/pc/file_dialogs/LoadFileDlgShapes.c (DrawFileDlg)
%ifdef CBUILD
%include "c/pc/file_dialogs/LoadFileDlgShapes.DrawFileDlg.inc"
%else
DrawFileDlg:
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
        mov ebx, str_Dialogbx
        cmp byte [fileoncd+063h], 1
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
        push str_Dbox
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
        cmp dword [exhfiles], byte 0
        je short .3
        mov dword [fdlgmask], 90h
        mov dword [fdlgtab], 2
.3:
        cmp dword [pofiles], byte 0
        je short .4
        or byte [fdlgmask], 40h
        mov dword [fdlgtab], 1
.4:
        cmp dword [lgfiles], byte 0
        je short .5
        or byte [fdlgmask], 20h
        xor ebx, ebx
        mov dword [fdlgtab], ebx
.5:
        cmp dword [fdlgtab], byte 0
        jl near DrawFileDlg_x
        or word [fdlgmask], 20Ch
        push dword 0FFh
        push dword 0FAh
        call TextSetColors
        add esp, byte 8
        mov esi, dword [fdlgtab]
        mov esi, dword [nosplit esi*4+fdlgfilelists]
        mov ebx, dword [fdlgrects+94h]
        add ebx, byte 13h
        mov edx, dword [fdlgrects+90h]
        add edx, byte 0Dh
        mov eax, dword [byte esi+04h]
        mov eax, dword [byte esi+eax*4+010h]
        call PrintTextCopy
        push dword 0F8h
        mov eax, dword [fdlgrects+0ACh]
        mov edi, dword [fdlgrects+0A4h]
        sub eax, edi
        inc eax
        push eax
        mov eax, dword [fdlgrects+0A8h]
        mov ebp, dword [fdlgrects+0A0h]
        sub eax, ebp
        inc eax
        push eax
        lea eax, [byte edi+013h]
        push eax
        lea eax, [byte ebp+0Ah]
        push eax
        call FillRect
        add esp, byte 14h
        mov ecx, dword [byte esi+08h]
        mov edi, 0Ah
        jmp short .7
.6:
        mov eax, edi
        shl eax, 4
        mov ebx, dword [dword eax+fdlgrects+4]
        add ebx, byte 10h
        mov edx, dword [dword eax+fdlgrects]
        add edx, byte 0Ah
        mov eax, ecx
        mov eax, dword [byte esi+eax*4+010h]
        call PrintTextCopy
        inc ecx
        inc edi
.7:
        cmp ecx, dword [byte esi+0Ch]
        jle short DrawFileDlg.6
        mov edx, dword [esi]
        cmp edx, byte 6
        jle near .8
        or word [fdlgmask], 0FF03h
        mov ebp, dword [fdlgrects+80h]
        add ebp, byte 0Ah
        mov edi, dword [fdlgrects+84h]
        add edi, byte 13h
        mov eax, dword [fdlgrects+88h]
        add eax, byte 0Ah
        mov dword [byte esp+020h], eax
        mov eax, 1E0h
        mov edx, eax
        sar edx, 1Fh
        idiv dword [esi]
        mov esi, dword [fdlgrects+84h]
        add esi, byte 11h
        add esi, eax
        push dword 0FAh
        push edi
        mov eax, dword [fdlgrects+88h]
        add eax, byte 9
        push eax
        push edi
        push ebp
        call FillRectColor
        add esp, byte 14h
        push dword 0FAh
        lea eax, [byte esi-01h]
        push eax
        push ebp
        push edi
        push ebp
        call FillRectColor
        add esp, byte 14h
        push dword 0F8h
        push esi
        mov ecx, dword [byte esp+028h]
        push ecx
        dec edi
        push edi
        mov edi, ecx
        push ecx
        call FillRectColor
        add esp, byte 14h
        push dword 0F8h
        push esi
        mov eax, edi
        push eax
        push esi
        dec ebp
        push ebp
        call FillRectColor
        add esp, byte 14h
        jmp short DrawFileDlg_x
.8:
        lea eax, [byte edx-01h]
        cmp eax, byte 5
        ja short DrawFileDlg_x
        jmp dword [nosplit cs:eax*4+DrawFileDlg_jt]
DrawFileDlg_n6:
        or byte [fdlgmask+1], 80h
DrawFileDlg_n5:
        or byte [fdlgmask+1], 40h
DrawFileDlg_n4:
        or byte [fdlgmask+1], 20h
DrawFileDlg_n3:
        or byte [fdlgmask+1], 10h
DrawFileDlg_n2:
        or byte [fdlgmask+1], 8
DrawFileDlg_n1:
        or byte [fdlgmask+1], 4
DrawFileDlg_x:
        add esp, byte 24h
        jmp near LoadFileDlgShapes_x
%endif ; C
;-----------------------------------------------------------------------------
; FileDlgHitTest                                                  2C3FF  95 PC
; (x, y, out*): finds which of the 16 fdlgrects contains the point
;-----------------------------------------------------------------------------
; C: src/pc/file_dialogs/FileDlgHitTest.c
%ifdef CBUILD
%include "c/pc/file_dialogs/FileDlgHitTest.inc"
%else
FileDlgHitTest:
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
        cmp ecx, dword [dword eax+fdlgrects]
        jl short .2
        cmp ecx, dword [dword eax+fdlgrects+8]
        jg short .2
        cmp esi, dword [dword eax+fdlgrects+4]
        jl short .2
        cmp esi, dword [dword eax+fdlgrects+0Ch]
        jg short .2
        mov dword [ebx], edx
        mov eax, 1
        pop esi
        pop ecx
        ret
.2:
        inc edx
        cmp edx, byte 10h
        jl short FileDlgHitTest.1
        xor eax, eax
        pop esi
        pop ecx
        ret
%endif ; C
        db 08Bh,0C0h
DrawFileDlgList_jt:
        dd DrawFileDlgList_n1
        dd DrawFileDlgList_n2
        dd DrawFileDlgList_n3
        dd DrawFileDlgList_n4
        dd DrawFileDlgList_n5
        dd DrawFileDlgList_n6
;-----------------------------------------------------------------------------
; DrawFileDlgList                              2C46B  95 PC, medium confidence
; Redraws the file name rows and the up / down arrows for the scroll position
;-----------------------------------------------------------------------------
; C: src/pc/file_dialogs/LoadFileDlgShapes.c (DrawFileDlgList)
%ifdef CBUILD
%include "c/pc/file_dialogs/LoadFileDlgShapes.DrawFileDlgList.inc"
%else
DrawFileDlgList:
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
        mov edx, dword [dword eax+fdlgrects+0ACh]
        mov ebx, dword [dword eax+fdlgrects+0A4h]
        sub edx, ebx
        inc edx
        push edx
        mov edx, dword [dword eax+fdlgrects+0A8h]
        mov ecx, dword [dword eax+fdlgrects+0A0h]
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
        jl short DrawFileDlgList.1
        test edi, edi
        jne short .2
        push dword 0F8h
        mov eax, dword [fdlgrects+9Ch]
        mov edi, dword [fdlgrects+94h]
        sub eax, edi
        sub eax, byte 5
        push eax
        mov eax, dword [fdlgrects+98h]
        mov ebp, dword [fdlgrects+90h]
        sub eax, ebp
        sub eax, byte 5
        push eax
        lea eax, [byte edi+016h]
        push eax
        lea eax, [byte ebp+0Dh]
        push eax
        call FillRect
        add esp, byte 14h
        xor eax, eax
        mov dword [byte esp+04h], eax
        jmp near DrawFileDlgList_n1.9
.2:
        cmp dword [edi], byte 6
        jg short .5
        xor esi, esi
        jmp short .4
.3:
        mov eax, esi
        shl eax, 4
        mov ebx, dword [dword eax+fdlgrects+0A4h]
        add ebx, byte 10h
        mov edx, dword [dword eax+fdlgrects+0A0h]
        add edx, byte 0Ah
        mov eax, esi
        mov eax, dword [byte edi+eax*4+010h]
        call PrintTextCopy
        inc esi
.4:
        cmp esi, dword [edi]
        jl short DrawFileDlgList.3
        jmp short .7
.5:
        xor esi, esi
.6:
        mov eax, esi
        shl eax, 4
        mov ebx, dword [dword eax+fdlgrects+0A4h]
        add ebx, byte 10h
        mov edx, dword [dword eax+fdlgrects+0A0h]
        add edx, byte 0Ah
        mov eax, dword [byte edi+08h]
        add eax, esi
        mov eax, dword [byte edi+eax*4+010h]
        call PrintTextCopy
        inc esi
        cmp esi, byte 6
        jl short DrawFileDlgList.6
.7:
        cmp dword [edi], byte 0
        jle short .8
        push dword 0F8h
        mov eax, dword [fdlgrects+9Ch]
        mov ecx, dword [fdlgrects+94h]
        sub eax, ecx
        sub eax, byte 5
        push eax
        mov eax, dword [fdlgrects+98h]
        mov esi, dword [fdlgrects+90h]
        sub eax, esi
        sub eax, byte 5
        push eax
        lea eax, [byte ecx+016h]
        push eax
        lea eax, [byte esi+0Dh]
        push eax
        call FillRect
        add esp, byte 14h
        mov ebx, dword [fdlgrects+94h]
        add ebx, byte 13h
        mov edx, dword [fdlgrects+90h]
        add edx, byte 0Dh
        mov eax, dword [byte edi+04h]
        mov eax, dword [byte edi+eax*4+010h]
        call PrintTextCopy
.8:
        mov eax, dword [byte edi+04h]
        mov ebp, dword [byte edi+08h]
        cmp eax, ebp
        jl short .9
        cmp eax, dword [byte edi+0Ch]
        jg short .9
        mov esi, eax
        sub esi, ebp
        push dword 0F8h
        mov ebp, esi
        shl ebp, 4
        mov eax, dword [dword ebp+fdlgrects+0ACh]
        mov ecx, dword [dword ebp+fdlgrects+0A4h]
        sub eax, ecx
        push eax
        mov eax, dword [dword ebp+fdlgrects+0A8h]
        mov edx, dword [dword ebp+fdlgrects+0A0h]
        sub eax, edx
        push eax
        lea eax, [byte ecx+013h]
        push eax
        lea eax, [byte edx+0Ah]
        push eax
        call FillRect
        add esp, byte 14h
        mov ebx, dword [dword ebp+fdlgrects+0A4h]
        add ebx, byte 10h
        mov edx, dword [dword ebp+fdlgrects+0A0h]
        add edx, byte 0Ah
        mov eax, dword [byte edi+08h]
        add eax, esi
        mov eax, dword [byte edi+eax*4+010h]
        call PrintTextCopy
.9:
        push dword 0F9h
        mov eax, dword [fdlgrects+8Ch]
        mov ebx, dword [fdlgrects+84h]
        sub eax, ebx
        inc eax
        push eax
        mov eax, dword [fdlgrects+88h]
        mov ecx, dword [fdlgrects+80h]
        sub eax, ecx
        inc eax
        push eax
        lea eax, [byte ebx+013h]
        push eax
        lea eax, [byte ecx+0Ah]
        push eax
        call FillRect
        add esp, byte 14h
        cmp dword [edi], byte 6
        jg short DrawFileDlgList_n1.1
        and word [fdlgmask], 6FCh
        mov eax, dword [edi]
        dec eax
        cmp eax, byte 5
        ja near DrawFileDlgList_n1.2
        jmp dword [nosplit cs:eax*4+DrawFileDlgList_jt]
DrawFileDlgList_n6:
        or byte [fdlgmask+1], 80h
DrawFileDlgList_n5:
        or byte [fdlgmask+1], 40h
DrawFileDlgList_n4:
        or byte [fdlgmask+1], 20h
DrawFileDlgList_n3:
        or byte [fdlgmask+1], 10h
DrawFileDlgList_n2:
        or byte [fdlgmask+1], 8
DrawFileDlgList_n1:
        or byte [fdlgmask+1], 4
        jmp near .2
.1:
        or word [fdlgmask], 0F903h
        mov esi, dword [fdlgrects+80h]
        add esi, byte 0Ah
        mov edx, dword [byte edi+08h]
        mov eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 4
        mov eax, edx
        sar edx, 1Fh
        idiv dword [edi]
        mov ebp, dword [fdlgrects+84h]
        add ebp, byte 13h
        add ebp, eax
        mov eax, dword [fdlgrects+88h]
        add eax, byte 0Ah
        mov dword [esp], eax
        mov edx, dword [byte edi+0Ch]
        inc edx
        mov eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 4
        mov eax, edx
        sar edx, 1Fh
        idiv dword [edi]
        mov edi, dword [fdlgrects+84h]
        add edi, byte 12h
        add edi, eax
        push dword 0FAh
        push ebp
        mov eax, dword [fdlgrects+88h]
        add eax, byte 9
        push eax
        push ebp
        push esi
        call FillRectColor
        add esp, byte 14h
        push dword 0FAh
        lea eax, [byte edi-01h]
        push eax
        push esi
        push ebp
        push esi
        call FillRectColor
        add esp, byte 14h
        push dword 0F8h
        push edi
        mov ecx, dword [byte esp+08h]
        push ecx
        inc ebp
        push ebp
        mov ebp, ecx
        push ecx
        call FillRectColor
        add esp, byte 14h
        push dword 0F8h
        push edi
        mov eax, ebp
        push eax
        push edi
        inc esi
        push esi
        call FillRectColor
        add esp, byte 14h
.2:
        mov eax, dword [fdlgtab]
        mov eax, dword [nosplit eax*4+fdlgfilelists]
        cmp dword [eax], byte 6
        jg short .3
        push byte 46h
        push byte 18h
        mov ecx, dword [fdlg_noarrow]
        push ecx
        jmp short .4
.3:
        push byte 46h
        push byte 18h
        mov ebx, dword [fdlg_arrow]
        push ebx
.4:
        call DrawArt
        add esp, byte 0Ch
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
        mov ebp, dword [fdlg_tabexh]
        push ebp
        jmp short .8
.6:
        push byte 4Bh
        push dword 0A3h
        mov edi, dword [fdlg_tabpo]
        push edi
        jmp short .8
.7:
        push byte 4Bh
        push dword 0A3h
        mov esi, dword [fdlg_tablp]
        push esi
.8:
        call DrawArt
        add esp, byte 0Ch
.9:
        mov eax, dword [byte esp+04h]
        add esp, byte 8
        jmp near LoadFileDlgShapes_x
%endif ; C
;-----------------------------------------------------------------------------
; RunFileDlg                                   2C801  95 PC, medium confidence
; Mouse loop of the file dialog: tabs, scroll, select, Open / Delete / Done;
; returns nonzero when a save was opened
;-----------------------------------------------------------------------------
; C: src/pc/file_dialogs/LoadFileDlgShapes.c (RunFileDlg)
%ifdef CBUILD
%include "c/pc/file_dialogs/LoadFileDlgShapes.RunFileDlg.inc"
%else
RunFileDlg:
        push dword 4Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 24h
        xor edx, edx
        mov dword [byte esp+018h], edx
        xor ebp, ebp
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
        push str_Pointer5
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte esp+01Ch], eax
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
        mov esi, dword [nosplit esi*4+fdlgfilelists]
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
        je short RunFileDlg.2
.3:
        cmp dword [byte esp+04h], byte 0
        jne near .6
        mov eax, dword [byte esp+0Ch]
        cmp eax, dword [byte esp+014h]
        jne short .4
        mov eax, dword [byte esp+08h]
        cmp eax, dword [byte esp+010h]
        je short RunFileDlg.1
.4:
        call SetScreenTarget
        mov ebx, dword [byte esp+010h]
        push ebx
        mov eax, dword [byte esp+018h]
        sub eax, byte 4
        push eax
        mov ecx, dword [byte esp+024h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [byte esp+08h]
        push edi
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        mov eax, dword [byte esp+024h]
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov edx, dword [byte esp+08h]
        push edx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        mov ebx, dword [pointerspr]
        push ebx
.5:
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+0Ch]
        mov dword [byte esp+014h], eax
        mov eax, dword [byte esp+08h]
        mov dword [byte esp+010h], eax
        jmp near RunFileDlg.1
.6:
        mov edx, dword [byte esp+010h]
        push edx
        mov eax, dword [byte esp+018h]
        sub eax, byte 4
        push eax
        mov ebx, dword [byte esp+024h]
        push ebx
        call DrawArtOpaque
        add esp, byte 0Ch
        test byte [byte esp+04h], 1
        je near .28
        test byte [fdlgmask+1], 1
        je near .28
        mov eax, dword [byte esp+014h]
        cmp eax, dword [byte esp+0Ch]
        jne short .7
        mov eax, dword [byte esp+010h]
        cmp eax, dword [byte esp+08h]
        je near .26
.7:
        mov ebx, esp
        mov edx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        call FileDlgHitTest
        test eax, eax
        je near .27
        cmp dword [esp], byte 8
        jne near .27
        cmp dword [byte esp+018h], byte 0
        je near .25
        mov eax, dword [byte esp+010h]
        sub eax, byte 13h
        sub eax, dword [fdlgrects+84h]
        mov edx, dword [esi]
        imul edx, eax
        mov ebx, 50h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, eax
        mov ebx, dword [byte esi+0Ch]
        mov eax, dword [byte esp+010h]
        cmp eax, dword [byte esp+08h]
        je near .26
        cmp edx, dword [byte esi+08h]
        jl near .26
        cmp edx, ebx
        jg near .26
        test ebp, ebp
        je short .8
        mov eax, dword [byte esp+020h]
.8:
        cmp eax, dword [byte esp+08h]
        jge short .15
        test ebp, ebp
        je short .9
        mov eax, dword [byte esp+020h]
        jmp short .10
.9:
        mov eax, dword [byte esp+010h]
.10:
        mov edx, dword [byte esp+08h]
        sub edx, eax
        imul edx, dword [esi]
        mov ecx, 50h
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov edx, eax
        test eax, eax
        jne short .12
        test ebp, ebp
        jne short .11
        mov eax, dword [byte esp+010h]
        mov dword [byte esp+020h], eax
.11:
        mov ebp, 1
        jmp short .13
.12:
        xor ebp, ebp
.13:
        mov eax, dword [byte esi+0Ch]
        add eax, edx
        mov edi, dword [esi]
        cmp eax, edi
        jge short .14
        add dword [byte esi+08h], edx
        add dword [byte esi+0Ch], edx
        jmp near .24
.14:
        lea eax, [byte edi-01h]
        mov dword [byte esi+0Ch], eax
        mov eax, dword [esi]
        sub eax, byte 6
        mov dword [byte esi+08h], eax
        jmp near .24
.15:
        test ebp, ebp
        je short .16
        mov eax, dword [byte esp+020h]
        jmp short .17
.16:
        mov eax, dword [byte esp+010h]
.17:
        cmp eax, dword [byte esp+08h]
        jle short .24
        test ebp, ebp
        je short .18
        mov eax, dword [byte esp+020h]
        jmp short .19
.18:
        mov eax, dword [byte esp+010h]
.19:
        sub eax, dword [byte esp+08h]
        mov edx, dword [esi]
        imul edx, eax
        mov ecx, 50h
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov edx, eax
        test eax, eax
        jne short .21
        test ebp, ebp
        jne short .20
        mov eax, dword [byte esp+010h]
        mov dword [byte esp+020h], eax
.20:
        mov ebp, 1
        jmp short .22
.21:
        xor ebp, ebp
.22:
        mov eax, dword [byte esi+08h]
        sub eax, edx
        test eax, eax
        jl short .23
        mov dword [byte esi+08h], eax
        sub dword [byte esi+0Ch], edx
        jmp short .24
.23:
        mov dword [byte esi+08h], 0
        mov dword [byte esi+0Ch], 5
.24:
        cmp ebx, dword [byte esi+0Ch]
        je near .26
        jmp near .38
.25:
        mov dword [byte esp+018h], 1
.26:
        mov eax, dword [byte esp+08h]
        push eax
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        mov edx, dword [byte esp+024h]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+08h]
        push ebx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        mov ecx, dword [pointerspr]
        push ecx
        jmp near RunFileDlg.5
.27:
        xor edx, edx
        mov dword [byte esp+018h], edx
        jmp short RunFileDlg.26
.28:
        mov dh, byte [byte esp+04h]
        test dh, 2
        je near .50
        xor ebp, ebp
        mov dword [byte esp+018h], ebp
        mov ebx, esp
        mov edx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        call FileDlgHitTest
        test eax, eax
        je short RunFileDlg.26
        mov cl, byte [esp]
        mov eax, 1
        shl eax, cl
        mov dword [esp], eax
        test dword [fdlgmask], eax
        je short RunFileDlg.26
        cmp eax, byte 10h
        jb short .30
        jbe short .32
        cmp eax, byte 40h
        jb short .29
        jbe near .43
        cmp eax, 80h
        jb near .49
        jbe near .44
        cmp eax, 100h
        je near .36
        jmp near .49
.29:
        cmp eax, byte 20h
        je near .42
        jmp near .49
.30:
        cmp eax, byte 2
        jb short .31
        jbe near .35
        cmp eax, byte 4
        jb near .49
        jbe near .45
        cmp eax, byte 8
        je near .46
        jmp near .49
.31:
        cmp eax, byte 1
        je short .34
        jmp near .49
.32:
        push dword 0BFh
        push byte 20h
        mov esi, dword [fdlg_cancel]
        push esi
        call DrawArt
        add esp, byte 0Ch
        mov edi, dword [byte esp+01Ch]
        push edi
.33:
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        jmp near DrawFileDlg_x
.34:
        push byte 46h
        push byte 18h
        mov ecx, dword [fdlg_up]
        push ecx
        call DrawArt
        add esp, byte 0Ch
        mov edi, dword [byte esi+08h]
        test edi, edi
        je near RunFileDlg.26
        mov eax, esi
        lea edx, [byte edi-01h]
        mov dword [byte esi+08h], edx
        dec dword [byte esi+0Ch]
        jmp short .39
.35:
        push byte 46h
        push byte 18h
        mov edx, dword [fdlg_down]
        push edx
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esi+0Ch]
        inc eax
        cmp eax, dword [esi]
        jge near RunFileDlg.26
        mov eax, esi
        inc dword [byte esi+08h]
        inc dword [byte esi+0Ch]
        jmp short .39
.36:
        mov edx, dword [byte esp+08h]
        sub edx, byte 13h
        sub edx, dword [fdlgrects+84h]
        imul edx, dword [esi]
        mov ebx, 50h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, eax
        cmp eax, dword [byte esi+08h]
        jge short .40
        cmp eax, byte 3
        jge short .37
        mov dword [byte esi+08h], ebp
        mov dword [byte esi+0Ch], 5
        jmp short .38
.37:
        sub eax, byte 3
        mov dword [byte esi+08h], eax
        add edx, byte 2
        mov dword [byte esi+0Ch], edx
.38:
        mov eax, esi
.39:
        call DrawFileDlgList
        jmp near RunFileDlg.26
.40:
        cmp eax, dword [byte esi+0Ch]
        jle near RunFileDlg.26
        add eax, byte 3
        mov edi, dword [esi]
        cmp eax, edi
        jle short .41
        lea eax, [byte edi-06h]
        mov dword [byte esi+08h], eax
        mov eax, dword [esi]
        dec eax
        mov dword [byte esi+0Ch], eax
        jmp short RunFileDlg.38
.41:
        mov eax, edx
        jmp short RunFileDlg.37
.42:
        mov dword [fdlgtab], ebp
        mov esi, dword [fdlgfilelists]
        jmp short RunFileDlg.38
.43:
        mov dword [fdlgtab], 1
        mov esi, dword [fdlgfilelists_e01]
        jmp short RunFileDlg.38
.44:
        mov dword [fdlgtab], 2
        mov esi, dword [fdlgfilelists_e02]
        jmp short RunFileDlg.38
.45:
        push dword 0BFh
        push byte 20h
        mov ebp, dword [fdlg_open]
        push ebp
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+01Ch]
        push eax
        call FreeMemBlock
        add esp, byte 4
        call SelectSavedFile
        jmp near DrawFileDlg_x
.46:
        push dword 0BFh
        push byte 20h
        mov eax, dword [fdlg_del]
        push eax
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [fdlgtab]
        mov eax, dword [nosplit eax*4+fdlgfilelists]
        call DeleteSavedGame
        mov edx, dword [byte esp+08h]
        push edx
        mov ebx, dword [byte esp+010h]
        push ebx
        call MouseSetPos
        add esp, byte 8
        mov ecx, dword [fdlgtab]
        test ecx, ecx
        jge short .47
        xor esi, esi
        jmp short .48
.47:
        mov esi, dword [nosplit ecx*4+fdlgfilelists]
.48:
        mov eax, esi
        call DrawFileDlgList
        push dword 0BFh
        push byte 20h
        mov edi, dword [fdlg_none]
        push edi
        call DrawArt
        add esp, byte 0Ch
        jmp near RunFileDlg.26
.49:
        mov ebx, esp
        mov edx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        call FileDlgHitTest
        mov edx, dword [esp]
        cmp edx, byte 9
        jle near RunFileDlg.38
        mov eax, dword [byte esi+08h]
        add eax, edx
        sub eax, byte 0Ah
        mov dword [byte esi+04h], eax
        jmp near RunFileDlg.38
.50:
        test dh, 4
        je near RunFileDlg.26
        mov ecx, dword [byte esp+01Ch]
        push ecx
        jmp near RunFileDlg.33
%endif ; C
;-----------------------------------------------------------------------------
; DeleteSavedGame                                                 2CE29  95 PC
; MessageBox "Exhibition Game Called: / Play-Off Series Called: / League
; Called:" confirm, then unlink / DeleteDir and rescan
;-----------------------------------------------------------------------------
; C: src/pc/file_dialogs/LoadFileDlgShapes.c (DeleteSavedGame)
%ifdef CBUILD
%include "c/pc/file_dialogs/LoadFileDlgShapes.DeleteSavedGame.inc"
%else
DeleteSavedGame:
        push dword 84h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 54h
        mov ebp, eax
        lea edi, [byte esp+03Ch]
        mov esi, savefileexts
        movsd
        movsd
        movsd
        mov dword [byte esp+04Ch], 140h
        mov dword [byte esp+048h], 0F0h
        mov ecx, dword [fdlgtab]
        test ecx, ecx
        jne short .1
        mov dword [delmsgbox+4], str_ExhibitionGameCalled
        jmp short .3
.1:
        cmp ecx, byte 1
        jne short .2
        mov dword [delmsgbox+4], str_PlayOffSeriesCalled
        jmp short .3
.2:
        mov dword [delmsgbox+4], str_LeagueCalled
.3:
        mov eax, dword [byte ebp+04h]
        mov eax, dword [byte ebp+eax*4+010h]
        mov dword [delmsgbox+8], eax
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        push byte 0FFFFFFFFh
        lea eax, [byte esp+04Ch]
        push eax
        lea eax, [byte esp+054h]
        push eax
        push byte 2
        push btn_POHumanOut
        mov ecx, 3
        mov ebx, delmsgbox
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        cmp eax, byte 1
        je short .4
        xor ebx, ebx
        mov dword [byte esp+050h], ebx
        jmp near .24
.4:
        mov edx, dword [byte ebp+04h]
        mov edx, dword [byte ebp+edx*4+010h]
        lea eax, [byte esp+02Ch]
        call strcpy_
        mov edx, dword [fdlgtab]
        mov edx, dword [byte esp+edx*4+03Ch]
        lea eax, [byte esp+02Ch]
        call strcat_
        mov ebx, esp
        mov edx, 10h
        lea eax, [byte esp+02Ch]
        call _dos_findfirst_
        test eax, eax
        je short .5
        xor edx, edx
        mov dword [byte esp+050h], edx
        jmp near .24
.5:
        test byte [byte esp+015h], 10h
        je short .8
        mov edx, lgstate+4
        lea eax, [byte esp+02Ch]
        call stricmp_
        test eax, eax
        jne short .6
        xor dh, dh
        mov byte [lgstate+4], dh
        mov dword [menuact_export], eax
        mov dword [menuact_nextlg], eax
        mov dword [menusub_lgmgr], eax
        jmp short .7
.6:
        mov edx, postate+4
        lea eax, [byte esp+02Ch]
        call stricmp_
        test eax, eax
        jne short .7
        xor dl, dl
        mov byte [postate+4], dl
        mov dword [menuact_nextpo], eax
        mov dword [menuact_posettings], eax
        mov dword [menuact_pohilights], eax
.7:
        lea eax, [byte esp+01Eh]
        call DeleteDir
        jmp short .9
.8:
        lea eax, [byte esp+01Eh]
        call unlink_
        test eax, eax
        je short .9
        push str_fec6
        call FatalError
        add esp, byte 4
.9:
        mov ebx, dword [byte ebp+00h]
        dec ebx
        mov dword [byte ebp+00h], ebx
        je short .14
        mov edx, dword [byte ebp+04h]
        jmp short .11
.10:
        mov eax, edx
        mov ebx, dword [byte ebp+eax*4+014h]
        mov dword [byte ebp+eax*4+010h], ebx
        inc edx
.11:
        mov ecx, dword [byte ebp+00h]
        cmp edx, ecx
        jl short DeleteSavedGame.10
        cmp ecx, byte 6
        jge short .12
        lea eax, [byte ecx-01h]
        mov dword [byte ebp+0Ch], eax
        mov dword [byte ebp+08h], 0
        jmp short .13
.12:
        cmp ecx, dword [byte ebp+0Ch]
        jne short .13
        dec dword [byte ebp+08h]
        dec dword [byte ebp+0Ch]
.13:
        mov eax, dword [byte ebp+04h]
        cmp eax, dword [byte ebp+00h]
        jne near .24
        dec dword [byte ebp+04h]
        jmp near .24
.14:
        mov eax, dword [fdlgtab]
        cmp eax, byte 1
        jb short .15
        jbe short .17
        cmp eax, byte 2
        je short .16
        jmp short .19
.15:
        test eax, eax
        je short .18
        jmp short .19
.16:
        and dword [fdlgmask], 0FF7Fh
        jmp short .19
.17:
        and dword [fdlgmask], 0FFBFh
        jmp short .19
.18:
        and dword [fdlgmask], 0FFDFh
.19:
        cmp dword [lgfiles], byte 0
        je short .20
        xor eax, eax
        mov dword [fdlgtab], eax
        jmp short .23
.20:
        cmp dword [pofiles], byte 0
        je short .21
        mov dword [fdlgtab], 1
        jmp short .23
.21:
        cmp dword [exhfiles], byte 0
        je short .22
        mov dword [fdlgtab], 2
        jmp short .23
.22:
        mov dword [fdlgtab], 0FFFFFFFFh
        mov dword [fdlgmask], 10h
.23:
        call DrawFileDlgTabs
.24:
        mov eax, dword [byte esp+050h]
        add esp, byte 54h
        jmp near LoadFileDlgShapes_x
%endif ; C
;-----------------------------------------------------------------------------
; SelectSavedFile                              2D099  95 PC, medium confidence
; Sets up the chosen save: .nhl (LoadModeState, "LA  at MTL" label), .po
; (schedule.db, seriesgameno, PlayoffModeLoop menu actions), .lp (league menu
; actions); ReadGameSettings for each
;-----------------------------------------------------------------------------
SelectSavedFile:
        push dword 4Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 30h
        mov edx, dword [fdlgtab]
        cmp edx, byte 1
        jb short .1
        jbe near .6
        cmp edx, byte 2
        je near .7
        jmp near .x
.1:
        test edx, edx
        jne near .x
        mov eax, dword [lgfiles+4]
        mov edx, dword [nosplit eax*4+lgfilenames]
        lea eax, [byte esp+020h]
        call strcpy_
        mov edx, str_Nhl
        lea eax, [byte esp+020h]
        call strcat_
        mov ebx, 1
        lea edx, [byte esp+020h]
        mov eax, exhstate
        call ReadGameSettings
        mov eax, exhstate
        call LoadModeState
        mov edx, dword [exhstate+51h]
        cmp edx, byte 18h
        jge short .2
        mov edx, dword [nosplit edx*4+teamabbrevs]
        jmp short .3
.2:
        mov edx, dword [nosplit edx*4+off_C5441]
.3:
        mov ebx, 3
        mov eax, str_LAAtMTL
        call strncpy_
        mov ebx, dword [exhstate+55h]
        cmp ebx, byte 18h
        jge short .4
        mov edx, dword [nosplit ebx*4+teamabbrevs]
        jmp short .5
.4:
        mov edx, dword [nosplit ebx*4+off_C5441]
.5:
        mov ebx, 3
        mov eax, str_LAAtMTL+7
        call strncpy_
        mov eax, 1
        jmp near .x
.6:
        mov eax, dword [pofiles+4]
        mov edx, dword [nosplit eax*4+pofilenames]
        lea eax, [byte esp+020h]
        call strcpy_
        mov edx, str_Po2
        lea eax, [byte esp+020h]
        call strcat_
        xor ebx, ebx
        lea edx, [byte esp+020h]
        mov eax, postate
        call ReadGameSettings
        mov esi, eax
        mov dword [menuact_nextpo], PlayoffModeLoop
        mov dword [menuact_posettings], EditPlayoffSettings
        mov dword [menuact_pohilights], ViewPlayoffHilights
        xor ecx, ecx
        mov ebx, str_ScheduleDb2
        lea edx, [byte esp+020h]
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        mov ebx, eax
        add esp, byte 8
        mov edx, dword [byte eax+042h]
        mov ecx, 7
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [seriesgameno], edx
        push ebx
        call FreeMemBlock
        add esp, byte 4
        mov eax, esi
        jmp short .x
.7:
        mov eax, dword [exhfiles+4]
        mov edx, dword [nosplit eax*4+exhfilenames]
        lea eax, [byte esp+020h]
        call strcpy_
        mov edx, str_Lp2
        lea eax, [byte esp+020h]
        call strcat_
        xor ebx, ebx
        lea edx, [byte esp+020h]
        mov eax, lgstate
        call ReadGameSettings
        mov dword [menuact_export], MenuExportDbs
        mov dword [menuact_nextlg], MenuNextLeagueGame
        mov dword [menusub_lgmgr], leaguemgrmenu
.x:
        add esp, byte 30h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; ReadGameSettings                             2D260  95 PC, medium confidence
; Reads 75h bytes of game.set (default or from the save dir), FatalError d2 /
; dd2 / d3 / d4; returns whether game.sav exists (FindFirstFile)
;-----------------------------------------------------------------------------
; C: src/pc/file_dialogs/ReadGameSettings.c
%ifdef CBUILD
%include "c/pc/file_dialogs/ReadGameSettings.inc"
%else
ReadGameSettings:
        push dword 5Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 44h
        mov edi, eax
        mov esi, edx
        mov ebp, ebx
        test ebx, ebx
        jne short .1
        xor ecx, ecx
        mov ebx, str_GameSet3
        mov eax, esp
        call MakePath
        lea edx, [byte esp+040h]
        mov eax, esp
        call FileOpenRead
        test eax, eax
        je short .3
        push str_fed2
        jmp short .2
.1:
        lea edx, [byte esp+040h]
        mov eax, esi
        call FileOpenRead
        test eax, eax
        je short .3
        push str_fedd2
.2:
        call FatalError
        add esp, byte 4
.3:
        mov ecx, 75h
        mov ebx, 0FFFFFFFFh
        mov edx, edi
        mov eax, dword [byte esp+040h]
        call FileReadAt
        test eax, eax
        je short .4
        push str_fed3
        call FatalError
        add esp, byte 4
.4:
        lea eax, [byte esp+040h]
        call FileClose
        test eax, eax
        je short .5
        push str_fed4
        call FatalError
        add esp, byte 4
.5:
        test ebp, ebp
        jne short .6
        xor ecx, ecx
        mov ebx, str_GameSav3
        mov edx, esi
        mov eax, esp
        call MakePath
        mov eax, esp
        push eax
        call FindFirstFile
        add esp, byte 4
        mov esi, eax
.6:
        test esi, esi
        je short .8
        cmp byte [musicon], 0
        jne short .7
        and byte [byte edi+05Ah], 0FEh
.7:
        mov eax, 1
        jmp short .x
.8:
        xor eax, eax
.x:
        add esp, byte 44h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
gsuminitff:
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
