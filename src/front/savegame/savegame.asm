; Saving a game in progress, and the name dialog that asks what to call the file.
bits 32
%include "hockey.inc"
section s_85924 progbits alloc exec nowrite align=1
extern __CHK, cddriveptr, ClearInputQueue, CopyFile, curleague, demomode, DiskSpaceShort, deskptry
extern deskptrx, EditTextField, exhstate, FatalError, FileClose, FileCreate, fileoncd, FileWriteAt
extern FreeMemBlock, gamemode, gameopts, GetInputEvent, lgstate, LoadModeState, mainfont, MakePath
extern MessageBox, MouseSetPos, msg_NoSaveSpace, msg_SavingLeagueGame, msg_SavingPlayoffGame, othergames, otherperiod, otherscores
extern pointerspr, postate, ptrupdatefn, RestoreDialogBg, SaveGameState, SaveLeagueGameRef, SaveModeState, SetDialogColors
extern SetTickDeadline, sprintf_, str_AGameYouRequire, str_AGameYouRequire2, str_AGameYouRequire3, str_Db4, str_DemoNhl, str_Dialog
extern str_Err1, str_extDB, str_GameSav5, str_Gsummary3, str_GsummaryDb4, str_Nhl3, str_Pointer22, str_Prmt
extern str_Sav3, str_Savegame, strcat_, AllocMemBlock, LoadBank, OpenArtArchiveErr, TextSetColors, TextSaveState
extern TextRestoreState, TextSetFont, PutBlock, DrawArtOpaque, DrawArtKeyFF, DrawArt, GrabBlock, TextPrintAt
extern GetFileSize, MouseRead, FindShape, SetScreenTarget, str_H2, str_h3, str_H4, str_h5
extern str_h6, str_h7, str_H1, str_A32, _dos_findfirst_, ViewHilights, WaitTickDeadline, WriteModeState
global MenuSaveGame, SaveGameStub, SaveGameNameDlg, savenamedefault, MenuPlayNextGame, MenuReturnToSportsCentral, ViewPlayoffHilights
;-----------------------------------------------------------------------------
; MenuSaveGame                                 85924  95 PC, medium confidence
; Menu action "Save Game ...": disk-space check (msg_NoSaveSpace),
; SaveGameNameDlg, writes .nhl game file, game.sav / gsummary.db copies,
;
; league / playoff 'Saving Current ...' messages
;-----------------------------------------------------------------------------
; C: src/front/savegame/MenuSaveGame.c
%ifdef CBUILD
%include "c/front/savegame/MenuSaveGame.inc"
%else
MenuSaveGame:
        push dword 0CCh
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 9Ch
        mov eax, esp
        push eax
        call TextSaveState
        add esp, byte 4
        mov edx, dword [mainfont]
        push edx
        call TextSetFont
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_GsummaryDb4
        mov edx, curleague
        lea eax, [byte esp+06Ch]
        call MakePath
        lea ebx, [byte esp+040h]
        xor edx, edx
        lea eax, [byte esp+06Ch]
        call _dos_findfirst_
        mov eax, dword [byte esp+05Ah]
        mov dword [dword esp+08Ch], eax
        xor ebx, ebx
        mov dword [dword esp+094h], ebx
        cmp dword [gamemode], byte 0
        jne near .11
        lea edx, [dword eax+01328h]
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        mov dword [dword esp+08Ch], eax
        xor eax, eax
        mov dword [dword esp+090h], ebx
        lea edx, [dword esp+08Ch]
        call DiskSpaceShort
        mov esi, eax
        test eax, eax
        je short .2
        db 053h                                 ; insn: push ebx
        db 0B9h,0FAh,00h,00h,00h                ; insn: mov ecx,0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        push esi
        push str_AGameYouRequire
.1:
        push str_AGameYouRequire3
        call sprintf_
        add esp, byte 0Ch
        push dword 320h
        push deskptry
        push deskptrx
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msg_NoSaveSpace
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp near .17
.2:
        cmp dword [demomode], byte 0
        je short .3
        lea edi, [byte esp+06Ch]
        mov esi, str_DemoNhl
        movsd
        movsd
        movsb
        jmp short .4
.3:
        lea eax, [byte esp+06Ch]
        call SaveGameNameDlg
        test eax, eax
        je short .4
        mov eax, esp
        push eax
        call TextRestoreState
        add esp, byte 4
        xor ebp, ebp
        jmp near .18
.4:
        or byte [exhstate+5Ah], 80h
        or byte [gameopts+1], 80h
        mov eax, exhstate
        call WriteModeState
        lea edx, [dword esp+098h]
        lea eax, [byte esp+06Ch]
        call FileCreate
        test eax, eax
        je short .5
        push str_H2
        call FatalError
        add esp, byte 4
.5:
        mov ecx, 75h
        mov ebx, 0FFFFFFFFh
        mov edx, exhstate
        mov eax, dword [dword esp+098h]
        call FileWriteAt
        test eax, eax
        je short .6
        push str_h3
        call FatalError
        add esp, byte 4
.6:
        mov ecx, str_extDB
        mov ebx, str_Gsummary3
        xor edx, edx
        lea eax, [byte esp+06Ch]
        call MakePath
        push byte 0
        lea eax, [byte esp+070h]
        push eax
        call OpenArtArchiveErr
        mov esi, eax
        add esp, byte 8
        mov edi, eax
        lea eax, [byte esp+06Ch]
        push eax
        call GetFileSize
        add esp, byte 4
        mov ecx, eax
        mov ebx, 0FFFFFFFFh
        mov edx, esi
        mov eax, dword [dword esp+098h]
        call FileWriteAt
        test eax, eax
        je short .7
        push str_H4
        call FatalError
        add esp, byte 4
.7:
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ecx, 0Ch
        mov ebx, 0FFFFFFFFh
        mov edx, othergames
        mov eax, dword [dword esp+098h]
        call FileWriteAt
        test eax, eax
        je short .8
        push str_h5
        call FatalError
        add esp, byte 4
.8:
        mov ecx, 0Ch
        mov ebx, 0FFFFFFFFh
        mov edx, otherscores
        mov eax, dword [dword esp+098h]
        call FileWriteAt
        test eax, eax
        je short .9
        push str_h6
        call FatalError
        add esp, byte 4
.9:
        mov ecx, 18h
        mov ebx, 0FFFFFFFFh
        mov edx, otherperiod
        mov eax, dword [dword esp+098h]
        call FileWriteAt
        test eax, eax
        je short .10
        push str_h7
        call FatalError
        add esp, byte 4
.10:
        mov eax, dword [dword esp+098h]
        call SaveGameState
        lea eax, [dword esp+098h]
        call FileClose
        jmp near .17
.11:
        lea edx, [dword eax+03FFh]
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        mov dword [dword esp+08Ch], eax
        mov dword [dword esp+090h], 4
        lea edx, [dword esp+08Ch]
        xor eax, eax
        call DiskSpaceShort
        mov esi, eax
        test eax, eax
        je short .12
        push ebx
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        push esi
        push str_AGameYouRequire2
        jmp near MenuSaveGame.1
.12:
        push dword 0C8h
        call SetTickDeadline
        add esp, byte 4
        push esi
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        xor ecx, ecx
        mov ebx, str_GameSav5
        mov edx, curleague
        lea eax, [byte esp+06Ch]
        call MakePath
        lea edx, [dword esp+098h]
        lea eax, [byte esp+06Ch]
        call FileCreate
        test eax, eax
        je short .13
        push str_H1
        call FatalError
        add esp, byte 4
.13:
        mov edi, dword [gamemode]
        cmp edi, byte 2
        jne short .14
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        mov ecx, edi
        mov ebx, msg_SavingLeagueGame
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        or byte [lgstate+5Ah], 80h
        or byte [gameopts+1], 80h
        mov eax, lgstate
        call WriteModeState
        mov eax, dword [dword esp+098h]
        call SaveLeagueGameRef
        jmp short .15
.14:
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msg_SavingPlayoffGame
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        or byte [postate+5Ah], 80h
        or byte [gameopts+1], 80h
        mov eax, postate
        call WriteModeState
.15:
        mov eax, dword [dword esp+098h]
        call SaveGameState
        lea eax, [dword esp+098h]
        call FileClose
        push curleague
        mov ecx, curleague
        mov ebx, str_Sav3
        mov edx, str_Db4
        mov eax, str_Gsummary3
        call CopyFile
        test eax, eax
        je short .16
        push str_A32
        call FatalError
        add esp, byte 4
.16:
        call WaitTickDeadline
        call RestoreDialogBg
.17:
        mov eax, esp
        push eax
        call TextRestoreState
        add esp, byte 4
.18:
        mov eax, ebp
        add esp, 9Ch
;-----------------------------------------------------------------------------
; SaveGameStub                                                    85D65  95 PC
; Lone ret
;-----------------------------------------------------------------------------
SaveGameStub:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SaveGameNameDlg                              85D6C  95 PC, medium confidence
; 'savegame' dialog with prmt field (EditTextField), appends .nhl, 'err1' on
; bad name
;-----------------------------------------------------------------------------
; C: src/front/savegame/MenuSaveGame.c (SaveGameNameDlg)
%ifdef CBUILD
%include "c/front/savegame/MenuSaveGame.SaveGameNameDlg.inc"
%else
SaveGameNameDlg:
        push dword 0C0h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 90h
        push eax
        mov eax, dword [pointerspr]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        add edx, byte 8
        imul eax, edx
        add eax, byte 11h
        mov dword [byte esp+07Ch], eax
        push byte 20h
        push eax
        push str_Pointer22
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
        call SetScreenTarget
        lea eax, [byte esp+074h]
        push eax
        lea eax, [byte esp+07Ch]
        push eax
        lea eax, [dword esp+084h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov eax, dword [byte esp+078h]
        mov dword [byte esp+070h], eax
        mov eax, dword [byte esp+074h]
        mov dword [dword esp+080h], eax
        push eax
        mov ecx, dword [byte esp+07Ch]
        push ecx
        mov esi, ebp
        push esi
        call GrabBlock
        add esp, byte 0Ch
        mov edi, dword [byte esp+074h]
        push edi
        mov eax, dword [byte esp+07Ch]
        push eax
        mov edx, dword [pointerspr]
        push edx
        call DrawArtKeyFF
        add esp, byte 0Ch
        xor ecx, ecx
        mov ebx, str_Savegame
        cmp byte [fileoncd+0163h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [byte esp+04h]
        call MakePath
        push byte 0
        lea eax, [byte esp+08h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [dword esp+088h], eax
        push str_Prmt
        push eax
        call FindShape
        mov dword [dword esp+08Ch], eax
        add esp, byte 8
        mov dword [dword esp+090h], eax
        mov eax, dword [byte eax+02h]
        sar eax, 10h
        mov edx, dword [dword esp+084h]
        mov edx, dword [byte edx+04h]
        sar edx, 10h
        add eax, byte 8
        imul eax, edx
        add eax, byte 11h
        mov dword [byte esp+07Ch], eax
        push byte 20h
        push eax
        push str_Dialog
        call AllocMemBlock
        mov ebx, eax
        add esp, byte 0Ch
        mov dword [dword esp+08Ch], eax
        mov edi, eax
        mov esi, dword [dword esp+084h]
        movsd
        movsd
        movsd
        movsd
        movsb
        mov edx, dword [dword esp+084h]
        mov edx, dword [byte edx+02h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov esi, 140h
        sub esi, eax
        mov edx, dword [dword esp+084h]
        mov edx, dword [byte edx+04h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edi, 0F0h
        sub edi, eax
        push edi
        push esi
        push ebx
        call GrabBlock
        add esp, byte 0Ch
        push edi
        push esi
        mov ecx, dword [dword esp+08Ch]
        push ecx
        call DrawArtOpaque
        add esp, byte 0Ch
        push dword 0F8h
        push dword 0FAh
        call TextSetColors
        add esp, byte 8
        mov eax, dword [dword esp+084h]
        mov eax, dword [byte eax+06h]
        sar eax, 10h
        add esi, eax
        mov eax, dword [dword esp+084h]
        mov eax, dword [byte eax+08h]
        sar eax, 10h
        add edi, eax
        mov eax, dword [esp]
        mov byte [eax], 0
        push byte 1
        push byte 0
        push byte 0
        push edi
        mov ecx, esi
        mov ebx, 64h
        mov edx, 8
        call EditTextField
        mov edx, str_Nhl3
        mov eax, dword [esp]
        call strcat_
        mov eax, dword [byte esp+074h]
        push eax
        mov edx, dword [byte esp+07Ch]
        push edx
        push ebp
        call DrawArtOpaque
        add esp, byte 0Ch
.3:
        mov eax, dword [esp]
        cmp byte [eax], 2Eh
        je short .4
        lea ebx, [byte esp+044h]
        xor edx, edx
        call _dos_findfirst_
        test eax, eax
        jne near .21
.4:
        mov eax, dword [esp]
        cmp byte [eax], 2Eh
        je near .17
        mov edx, dword [dword esp+090h]
        mov edx, dword [byte edx+02h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov esi, 140h
        sub esi, eax
        mov edx, dword [dword esp+090h]
        mov edx, dword [byte edx+04h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edi, 0F0h
        sub edi, eax
        push edi
        push esi
        mov eax, dword [dword esp+094h]
        push eax
        call DrawArtOpaque
        add esp, byte 0Ch
        mov edx, dword [dword esp+08Ch]
        push edx
        call FreeMemBlock
        add esp, byte 4
        push str_Err1
        mov ebx, dword [dword esp+08Ch]
        push ebx
        call FindShape
        mov dword [dword esp+08Ch], eax
        add esp, byte 8
        mov dword [dword esp+090h], eax
        mov eax, dword [byte eax+02h]
        sar eax, 10h
        mov edx, dword [dword esp+084h]
        mov edx, dword [byte edx+04h]
        sar edx, 10h
        add eax, byte 8
        imul eax, edx
        add eax, byte 11h
        mov dword [byte esp+07Ch], eax
        push byte 20h
        push eax
        push str_Dialog
        call AllocMemBlock
        mov ebx, eax
        add esp, byte 0Ch
        mov dword [dword esp+08Ch], eax
        mov edi, eax
        mov esi, dword [dword esp+084h]
        movsd
        movsd
        movsd
        movsd
        movsb
        mov edx, dword [dword esp+084h]
        mov edx, dword [byte edx+02h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov esi, 140h
        sub esi, eax
        mov edx, dword [dword esp+084h]
        mov edx, dword [byte edx+04h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edi, 0F0h
        sub edi, eax
        push edi
        push esi
        push ebx
        call GrabBlock
        add esp, byte 0Ch
        push edi
        push esi
        mov eax, dword [dword esp+08Ch]
        push eax
        call DrawArtKeyFF
        add esp, byte 0Ch
        mov eax, dword [dword esp+084h]
        mov eax, dword [byte eax+06h]
        sar eax, 10h
        add esi, eax
        mov eax, dword [dword esp+084h]
        mov eax, dword [byte eax+08h]
        sar eax, 10h
        add edi, eax
        xor eax, eax
        jmp short .6
.5:
        inc eax
.6:
        mov edx, dword [esp]
        add edx, eax
        cmp byte [edx], 2Eh
        jne short SaveGameNameDlg.5
        mov byte [edx], 0
        push dword 0F9h
        push dword 0FAh
        call TextSetColors
        add esp, byte 8
        push edi
        push esi
        mov edx, dword [byte esp+08h]
        push edx
        call TextPrintAt
        add esp, byte 0Ch
        call ClearInputQueue
        push dword 0FEh
        push dword 181h
        call MouseSetPos
        add esp, byte 8
        push dword 0FEh
        push dword 181h
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        push dword 0FEh
        push dword 181h
        mov ebx, dword [pointerspr]
        push ebx
        call DrawArtKeyFF
        add esp, byte 0Ch
        mov ecx, 181h
        mov dword [byte esp+070h], ecx
        mov dword [byte esp+078h], ecx
        mov edi, 0FEh
        mov dword [dword esp+080h], edi
        mov dword [byte esp+074h], edi
        call ClearInputQueue
.7:
        xor ecx, ecx
.8:
        call GetInputEvent
        test eax, eax
        je short .9
        lea ebx, [dword esp+080h]
        lea edx, [byte esp+070h]
        call dword [ptrupdatefn]
        mov ecx, eax
        test al, 2
        je short SaveGameNameDlg.8
.9:
        test cl, 2
        jne short .12
        mov eax, dword [byte esp+070h]
        cmp eax, dword [byte esp+078h]
        jne short .10
        mov eax, dword [dword esp+080h]
        cmp eax, dword [byte esp+074h]
        je short SaveGameNameDlg.7
.10:
        mov ecx, dword [byte esp+074h]
        push ecx
        mov esi, dword [byte esp+07Ch]
        push esi
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [dword esp+080h]
        push edi
        mov eax, dword [byte esp+074h]
        push eax
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+080h]
        push edx
        mov ebx, dword [byte esp+074h]
        push ebx
        mov ecx, dword [pointerspr]
        push ecx
.11:
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+070h]
        mov dword [byte esp+078h], eax
        mov eax, dword [dword esp+080h]
        mov dword [byte esp+074h], eax
        jmp near SaveGameNameDlg.7
.12:
        mov edx, dword [dword esp+080h]
        cmp edx, 109h
        jge short SaveGameNameDlg.10
        cmp edx, 0F8h
        jl short SaveGameNameDlg.10
        mov esi, dword [byte esp+070h]
        cmp esi, 0DAh
        jle near .13
        cmp esi, 107h
        jge near .13
        mov ebx, dword [byte esp+074h]
        push ebx
        mov ecx, dword [byte esp+07Ch]
        push ecx
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+090h]
        mov edx, dword [byte edx+02h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov esi, 140h
        sub esi, eax
        mov edx, dword [dword esp+090h]
        mov edx, dword [byte edx+04h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edi, 0F0h
        sub edi, eax
        push edi
        push esi
        mov esi, dword [dword esp+094h]
        push esi
        call DrawArtOpaque
        add esp, byte 0Ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [dword esp+088h]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov edx, str_Nhl3
        mov eax, dword [esp]
        call strcat_
        jmp near .22
.13:
        mov eax, dword [byte esp+070h]
        cmp eax, 114h
        jle near .14
        cmp eax, 148h
        jge near .14
        mov ecx, dword [byte esp+074h]
        push ecx
        mov esi, dword [byte esp+07Ch]
        push esi
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+090h]
        mov edx, dword [byte edx+02h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov esi, 140h
        sub esi, eax
        mov edx, dword [dword esp+090h]
        mov edx, dword [byte edx+04h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edi, 0F0h
        sub edi, eax
        push edi
        push esi
        mov edi, dword [dword esp+094h]
        push edi
        call DrawArtOpaque
        add esp, byte 0Ch
        push edi
        call FreeMemBlock
        add esp, byte 4
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [dword esp+088h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 1
        jmp near .23
.14:
        mov ebx, dword [byte esp+070h]
        cmp ebx, 15Dh
        jle short .15
        cmp ebx, 1A2h
        jl short .16
.15:
        mov esi, dword [byte esp+074h]
        push esi
        mov edi, dword [byte esp+07Ch]
        push edi
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+080h]
        push eax
        mov edx, dword [byte esp+074h]
        push edx
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [dword esp+080h]
        push ebx
        mov ecx, dword [byte esp+074h]
        push ecx
        mov esi, dword [pointerspr]
        push esi
        jmp near SaveGameNameDlg.11
.16:
        mov edi, dword [byte esp+074h]
        push edi
        mov eax, dword [byte esp+07Ch]
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+090h]
        mov edx, dword [byte edx+02h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov esi, 140h
        sub esi, eax
        mov edx, dword [dword esp+090h]
        mov edx, dword [byte edx+04h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edi, 0F0h
        sub edi, eax
        push edi
        push esi
        mov edx, dword [dword esp+094h]
        push edx
        call DrawArtOpaque
        add esp, byte 0Ch
        mov ebx, dword [dword esp+08Ch]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        push str_Prmt
        mov ecx, dword [dword esp+08Ch]
        push ecx
        call FindShape
        mov dword [dword esp+08Ch], eax
        add esp, byte 8
        mov dword [dword esp+090h], eax
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        add edx, byte 8
        imul eax, edx
        add eax, byte 11h
        mov dword [byte esp+07Ch], eax
        push byte 20h
        push eax
        push str_Dialog
        call AllocMemBlock
        mov ebx, eax
        add esp, byte 0Ch
        mov dword [dword esp+08Ch], eax
        mov edi, eax
        mov esi, dword [dword esp+084h]
        movsd
        movsd
        movsd
        movsd
        movsb
        mov edx, dword [dword esp+084h]
        mov edx, dword [byte edx+02h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov esi, 140h
        sub esi, eax
        mov edx, dword [dword esp+084h]
        mov edx, dword [byte edx+04h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edi, 0F0h
        sub edi, eax
        push edi
        push esi
        push ebx
        call GrabBlock
        add esp, byte 0Ch
        push edi
        push esi
        mov eax, dword [dword esp+08Ch]
        push eax
        call DrawArtOpaque
        add esp, byte 0Ch
        mov eax, dword [dword esp+084h]
        mov eax, dword [byte eax+06h]
        sar eax, 10h
        add esi, eax
        mov eax, dword [dword esp+084h]
        mov eax, dword [byte eax+08h]
        sar eax, 10h
        add edi, eax
        mov edx, dword [byte esp+074h]
        push edx
        mov ebx, dword [byte esp+07Ch]
        push ebx
        push ebp
        call GrabBlock
        add esp, byte 0Ch
.17:
        xor eax, eax
        jmp short .19
.18:
        inc eax
.19:
        mov edx, dword [esp]
        add edx, eax
        mov bh, byte [edx]
        cmp bh, 2Eh
        je short .20
        test bh, bh
        jne short SaveGameNameDlg.18
.20:
        add eax, dword [esp]
        mov byte [eax], 0
        push dword 0F8h
        push dword 0FAh
        call TextSetColors
        add esp, byte 8
        push byte 1
        push byte 0
        push byte 0
        push edi
        mov ecx, esi
        mov ebx, 64h
        mov edx, 8
        mov eax, dword [byte esp+010h]
        call EditTextField
        mov edx, str_Nhl3
        mov eax, dword [esp]
        call strcat_
        jmp near SaveGameNameDlg.3
.21:
        mov ebx, dword [byte esp+074h]
        push ebx
        mov ecx, dword [byte esp+07Ch]
        push ecx
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+090h]
        mov edx, dword [byte edx+02h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov esi, 140h
        sub esi, eax
        mov edx, dword [dword esp+090h]
        mov edx, dword [byte edx+04h]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edi, 0F0h
        sub edi, eax
        push edi
        push esi
        mov esi, dword [dword esp+094h]
        push esi
        call DrawArtOpaque
        add esp, byte 0Ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [dword esp+088h]
        push ebp
        call FreeMemBlock
        add esp, byte 4
.22:
        xor eax, eax
.23:
        add esp, 94h
        jmp near SaveGameStub
%endif ; C
savenamedefault:                                ; used by CreatePlayoffs
        db 02Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h
;-----------------------------------------------------------------------------
; MenuPlayNextGame                             86627  95 PC, medium confidence
; Menu action "Play Next Game ...": returns 4
;-----------------------------------------------------------------------------
; C: src/front/savegame/MenuPlayNextGame.c
%ifdef CBUILD
%include "c/front/savegame/MenuPlayNextGame.inc"
%else
MenuPlayNextGame:
        push dword 4
        call __CHK
        mov eax, 4
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuReturnToSportsCentral                    86637  95 PC, medium confidence
; Menu action "Return To Sports Central": returns 1
;-----------------------------------------------------------------------------
; C: src/front/savegame/MenuReturnToSportsCentral.c
%ifdef CBUILD
%include "c/front/savegame/MenuReturnToSportsCentral.inc"
%else
MenuReturnToSportsCentral:
        push dword 4
        call __CHK
        mov eax, 1
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ViewPlayoffHilights                          86647  95 PC, medium confidence
; Loads postate, gamemode 0, ViewHilights, restores exhstate; from
; SelectSavedFile / CreatePlayoffs
;-----------------------------------------------------------------------------
; C: src/front/savegame/ViewPlayoffHilights.c
%ifdef CBUILD
%include "c/front/savegame/ViewPlayoffHilights.inc"
%else
ViewPlayoffHilights:
        push dword 8
        call __CHK
        push edx
        mov eax, exhstate
        call SaveModeState
        mov eax, postate
        call LoadModeState
        xor edx, edx
        mov dword [gamemode], edx
        call ViewHilights
        test eax, eax
        jne short .1
        mov eax, exhstate
        call LoadModeState
        mov eax, 2
        pop edx
        ret
.1:
        mov eax, exhstate
        call LoadModeState
        xor eax, eax
        pop edx
        ret
%endif ; C
