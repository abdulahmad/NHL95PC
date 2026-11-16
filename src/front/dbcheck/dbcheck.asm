; Database checks and their error screens (PC only).
bits 32
%include "hockey.inc"
section s_6EAB5 progbits alloc exec nowrite align=1
extern __CHK, btn_DBError, ClearInputQueue, ClearScreen, DrawArt, DrawButtons, DrawMenuBar, PosBitMasks
extern editptrspr, editrostersmenubar, FillRect, fullscrbmp, GetInputEvent, GrabBlock, KeyDbPtr, KeyDown
extern MouseSetPos, pointerspr, PrintCenteredText, ptrupdatefn, PutBlock, SetDrawBitmap, str_ErrorsFoundInDatabases, str_NotEnoughDefence
extern str_NotEnoughForwards, str_NotEnoughGoalies, str_NotEnoughPlayers, str_TheDefenceLinesAre, str_TheExtraAttackerLines, str_TheForwardLinesAre, str_TheGoalieLinesAre, str_ThePenaltyKillingLines
extern str_ThePowerPlayLines, strcat_, DrawArtOpaqueAtOwnPos, SetScreenTarget, TeamRecPtr, TrackButtons
global ErrorScreenWait, DrawDBErrorsScreen, ShowDBError, CheckTeamLines, CheckDatabases
;-----------------------------------------------------------------------------
; ErrorScreenWait                                 6EAB5  95 PC, low confidence
; Mouse/keyboard wait loop used by ShowDBError
;-----------------------------------------------------------------------------
; C: src/front/dbcheck/ErrorScreenWait.c
%ifdef CBUILD
%include "c/front/dbcheck/ErrorScreenWait.inc"
%else
ErrorScreenWait:
        push dword 3Ch
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        push eax
        push edx
        push ebx
        push ecx
        mov dword [byte esp+018h], 0FFFFFFFFh
        mov esi, dword [eax]
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
        mov ebx, dword [editptrspr]
        push ebx
        call GrabBlock
        add esp, byte 0Ch
        push edi
        push esi
        mov ecx, dword [pointerspr]
        push ecx
        call DrawArt
        add esp, byte 0Ch
.1:
        push byte 1
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short ErrorScreenWait.1
        push byte 1Ch
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short ErrorScreenWait.1
        call ClearInputQueue
        xor ebp, ebp
.2:
        call GetInputEvent
        test eax, eax
        je near .9
        lea ebx, [byte esp+010h]
        lea edx, [byte esp+014h]
        call dword [ptrupdatefn]
        mov dword [byte esp+01Ch], eax
        mov ah, byte [byte esp+01Ch]
        test ah, 4
        je short .3
        mov edx, 0FFFFFFFFh
        mov dword [byte esp+018h], edx
        mov ebp, edx
        jmp short .7
.3:
        test ah, 3
        je short .7
        push edi
        push esi
        mov eax, dword [editptrspr]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [esp]
        test edx, edx
        jle short .4
        mov ebx, dword [byte esp+01Ch]
        push ebx
        mov ecx, dword [byte esp+014h]
        mov ebx, dword [byte esp+018h]
        mov eax, dword [byte esp+08h]
        call TrackButtons
        mov dword [byte esp+018h], eax
        test eax, eax
        jl short .6
        jmp short .5
.4:
        test byte [byte esp+01Ch], 2
        je short .6
.5:
        mov ebp, 0FFFFFFFFh
.6:
        push edi
        push esi
        mov ecx, dword [editptrspr]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
        push edi
        push esi
        mov eax, dword [pointerspr]
        push eax
        call DrawArt
        add esp, byte 0Ch
.7:
        cmp esi, dword [byte esp+014h]
        jne short .8
        cmp edi, dword [byte esp+010h]
        je short .9
.8:
        push edi
        push esi
        mov esi, dword [editptrspr]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [byte esp+010h]
        push edi
        mov eax, dword [byte esp+018h]
        push eax
        mov edx, dword [editptrspr]
        push edx
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
.9:
        test ebp, ebp
        je near ErrorScreenWait.2
.10:
        push byte 1
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short ErrorScreenWait.10
        push byte 1Ch
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short ErrorScreenWait.10
        call ClearInputQueue
        push edi
        push esi
        mov edi, dword [editptrspr]
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
        mov eax, dword [byte esp+018h]
        add esp, byte 20h
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawDBErrorsScreen                           6EC95  95 PC, medium confidence
; Draws the 'Errors found in databases!' screen
;-----------------------------------------------------------------------------
; C: src/front/dbcheck/DrawDBErrorsScreen.c
%ifdef CBUILD
%include "c/front/dbcheck/DrawDBErrorsScreen.inc"
%else
DrawDBErrorsScreen:
        push dword 28h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, eax
        mov esi, edx
        mov edi, ebx
        mov edx, dword [fullscrbmp]
        push edx
        call SetDrawBitmap
        add esp, byte 4
        push byte 41h
        call ClearScreen
        add esp, byte 4
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 5
        mov eax, editrostersmenubar
        call DrawMenuBar
        push byte 41h
        push dword 1CDh
        push dword 280h
        push byte 13h
        push byte 0
        call FillRect
        add esp, byte 14h
        mov edx, 2
        mov eax, btn_DBError
        call DrawButtons
        mov dword [byte ebp+00h], 0
        cmp dword [edi], byte 0
        je short .x
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add eax, byte 1Fh
        mov edx, str_ErrorsFoundInDatabases
        call PrintCenteredText
        add dword [esi], byte 2
        mov dword [edi], 0
.x:
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ShowDBError                                  6ED39  95 PC, medium confidence
; Prints one error line on the database-errors screen and waits
; (ErrorScreenWait)
;-----------------------------------------------------------------------------
; C: src/front/dbcheck/ShowDBError.c
%ifdef CBUILD
%include "c/front/dbcheck/ShowDBError.inc"
%else
ShowDBError:
        push dword 18h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov esi, edx
        mov dword [esp], ebx
        mov ebp, ecx
        call SetScreenTarget
        mov eax, dword [fullscrbmp]
        mov edx, dword [byte eax+02Ch]
        push edx
        call DrawArtOpaqueAtOwnPos
        add esp, byte 4
        mov dword [edi], 0FFFFFFFFh
        mov dword [esi], 0
        mov ecx, 2
        mov ebx, btn_DBError
        mov edx, ebp
        mov eax, dword [esp]
        call ErrorScreenWait
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CheckTeamLines                                                  6ED8F  95 PC
; Checks one team: 'The forward/defence/power play/penalty
; killing/goalie/extra attacker lines are not complete on', 'There are not
; enough players/goalies/forwards/defence on' + team name
;-----------------------------------------------------------------------------
; C: src/front/dbcheck/CheckTeamLines.c
%ifdef CBUILD
%include "c/front/dbcheck/CheckTeamLines.inc"
%else
CheckTeamLines:
        push dword 78h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 68h
        mov ebp, edx
        mov dword [byte esp+05Ch], ebx
        mov dword [byte esp+054h], ecx
        mov dword [byte esp+064h], 0FFFFFFFEh
        call TeamRecPtr
        mov dword [byte esp+058h], eax
        xor ebx, ebx
        mov dword [byte esp+060h], ebx
        jmp near .20
.1:
        mov dword [byte esp+064h], 0FFFFFFFEh
        mov eax, dword [byte esp+05Ch]
        cmp dword [eax], byte 0
        je short .2
        mov ebx, dword [byte esp+054h]
        mov edx, ebp
        call DrawDBErrorsScreen
.2:
        mov eax, dword [byte esp+060h]
        mov ecx, dword [byte esp+078h]
        and ecx, dword [nosplit eax*4+PosBitMasks]
        je near .19
        cmp ecx, byte 10h
        jb short .4
        jbe near .11
        cmp ecx, 80h
        jb short .3
        jbe near .14
        cmp ecx, 100h
        jb near .18
        jbe near .15
        cmp ecx, 200h
        je near .16
        jmp near .18
.3:
        cmp ecx, byte 20h
        jb near .18
        jbe near .12
        cmp ecx, byte 40h
        je near .13
        jmp near .18
.4:
        cmp ecx, byte 2
        jb short .5
        jbe short .7
        cmp ecx, byte 4
        jb near .18
        jbe short .8
        cmp ecx, byte 8
        je short .10
        jmp near .18
.5:
        cmp ecx, byte 1
        jne near .18
        mov ecx, 9
        mov edi, esp
        mov esi, str_TheForwardLinesAre
.6:
        rep movsd
        movsw
        movsb
        jmp near .18
.7:
        mov ecx, 9
        mov edi, esp
        mov esi, str_TheDefenceLinesAre
        jmp short CheckTeamLines.6
.8:
        mov ecx, 0Ah
        mov edi, esp
        mov esi, str_ThePowerPlayLines
.9:
        rep movsd
        movsw
        jmp short .18
.10:
        mov ecx, 0Bh
        mov edi, esp
        mov esi, str_ThePenaltyKillingLines
        jmp short CheckTeamLines.6
.11:
        mov ecx, 9
        mov edi, esp
        mov esi, str_TheGoalieLinesAre
        jmp short CheckTeamLines.9
.12:
        mov ecx, 0Bh
        mov edi, esp
        mov esi, str_TheExtraAttackerLines
        jmp short CheckTeamLines.9
.13:
        mov ecx, 8
        mov edi, esp
        mov esi, str_NotEnoughPlayers
        jmp short .17
.14:
        mov ecx, 8
        mov edi, esp
        mov esi, str_NotEnoughGoalies
        jmp short .17
.15:
        mov ecx, 8
        mov edi, esp
        mov esi, str_NotEnoughForwards
        jmp short CheckTeamLines.9
.16:
        mov ecx, 8
        mov edi, esp
        mov esi, str_NotEnoughDefence
.17:
        rep movsd
        movsb
.18:
        mov edx, dword [byte esp+058h]
        add edx, byte 1Ah
        mov eax, esp
        call strcat_
        mov eax, dword [byte ebp+00h]
        mov ecx, eax
        shl ecx, 2
        sub ecx, eax
        shl ecx, 2
        add ecx, eax
        lea eax, [byte ecx+01Fh]
        mov edx, esp
        call PrintCenteredText
        mov ecx, dword [byte ebp+00h]
        inc ecx
        mov dword [byte ebp+00h], ecx
        cmp ecx, byte 1Eh
        jl short .19
        mov ecx, dword [dword esp+080h]
        mov ebx, dword [byte esp+07Ch]
        mov edx, ebp
        mov eax, dword [byte esp+05Ch]
        call ShowDBError
        mov dword [byte esp+064h], eax
.19:
        inc dword [byte esp+060h]
.20:
        cmp dword [byte esp+060h], byte 0Ah
        jge short .21
        mov esi, dword [byte esp+064h]
        cmp esi, byte 1
        je short .21
        cmp esi, byte 0FFFFFFFFh
        jne near CheckTeamLines.1
.21:
        mov eax, dword [byte esp+064h]
        add esp, byte 68h
        pop ebp
        pop edi
        pop esi
        ret 0Ch
%endif ; C
;-----------------------------------------------------------------------------
; CheckDatabases                               6EF84  95 PC, medium confidence
; Database_save 6C353: runs CheckTeamLines over the teams and shows the
; errors before saving
;-----------------------------------------------------------------------------
; C: src/front/dbcheck/CheckDatabases.c
%ifdef CBUILD
%include "c/front/dbcheck/CheckDatabases.inc"
%else
CheckDatabases:
        push dword 48h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 1Ch
        push eax
        push edx
        xor edx, edx
        mov dword [byte esp+010h], edx
        mov ebx, 0FFFFFFFFh
        mov dword [byte esp+014h], ebx
        mov dword [byte esp+0Ch], ebx
        mov dword [byte esp+08h], ebx
        mov dword [byte esp+018h], edx
.1:
        xor ebx, ebx
        xor ebp, ebp
        mov dword [byte esp+020h], ebx
        xor edx, edx
        mov dword [byte esp+01Ch], ebx
        xor edi, edi
        mov eax, dword [byte esp+018h]
        call TeamRecPtr
        mov esi, eax
.2:
        mov eax, edx
        shl eax, 2
        add eax, esi
        mov ecx, dword [byte eax+04Ch]
        cmp ecx, byte 0FFFFFFFFh
        je short .4
        inc ebp
        mov eax, ecx
        call KeyDbPtr
        cmp byte [byte eax+02h], 44h
        jne short .3
        inc edi
        jmp short .4
.3:
        inc dword [byte esp+01Ch]
.4:
        inc edx
        cmp edx, byte 19h
        jl short CheckDatabases.2
        xor edx, edx
.5:
        mov eax, edx
        cmp dword [dword esi+eax*4+0B0h], byte 0FFFFFFFFh
        je short .6
        inc dword [byte esp+020h]
.6:
        inc edx
        cmp edx, byte 3
        jl short CheckDatabases.5
        lea eax, [dword esi+0BCh]
        xor edx, edx
.7:
        cmp byte [edx+eax], 64h
        jne short .8
        or bl, 1
.8:
        inc edx
        cmp edx, byte 0Ch
        jl short CheckDatabases.7
        lea eax, [dword esi+0C8h]
        xor edx, edx
.9:
        cmp byte [edx+eax], 64h
        jne short .10
        or bl, 2
.10:
        inc edx
        cmp edx, byte 6
        jl short CheckDatabases.9
        lea eax, [dword esi+0CEh]
        xor edx, edx
.11:
        cmp byte [edx+eax], 64h
        jne short .12
        or bl, 4
.12:
        inc edx
        cmp edx, byte 0Ah
        jl short CheckDatabases.11
        lea eax, [dword esi+0D8h]
        xor edx, edx
.13:
        cmp byte [edx+eax], 64h
        jne short .14
        or bl, 8
.14:
        inc edx
        cmp edx, byte 8
        jl short CheckDatabases.13
        lea eax, [dword esi+0E0h]
        xor edx, edx
.15:
        cmp byte [edx+eax], 64h
        jne short .16
        or bl, 10h
.16:
        inc edx
        cmp edx, byte 2
        jl short CheckDatabases.15
        lea eax, [dword esi+0E2h]
        xor edx, edx
.17:
        cmp byte [edx+eax], 64h
        jne short .18
        or bl, 20h
.18:
        inc edx
        cmp edx, byte 2
        jl short CheckDatabases.17
        cmp ebp, byte 5
        jge short .19
        or bl, 40h
.19:
        cmp dword [byte esp+01Ch], byte 3
        jge short .20
        or bh, 1
.20:
        cmp edi, byte 2
        jge short .21
        or bh, 2
.21:
        cmp dword [byte esp+020h], byte 2
        jge short .22
        or bl, 80h
.22:
        mov eax, 0FFFFFFFEh
        test ebx, ebx
        je short .23
        xor esi, esi
        mov dword [byte esp+014h], esi
        mov edi, dword [esp]
        push edi
        mov ebp, dword [byte esp+08h]
        push ebp
        push ebx
        lea ecx, [byte esp+014h]
        lea ebx, [byte esp+018h]
        lea edx, [byte esp+01Ch]
        mov eax, dword [byte esp+024h]
        call CheckTeamLines
        mov edx, dword [byte esp+010h]
        test edx, edx
        je short .23
        lea ebx, [byte edx+01h]
        mov dword [byte esp+010h], ebx
.23:
        cmp eax, byte 0FFFFFFFEh
        jne short .25
        mov ecx, dword [byte esp+010h]
        cmp ecx, byte 1Eh
        jge short .24
        test ecx, ecx
        jle short .25
        cmp dword [byte esp+018h], byte 1Bh
        jne short .25
.24:
        mov ecx, dword [esp]
        mov ebx, dword [byte esp+04h]
        lea edx, [byte esp+010h]
        lea eax, [byte esp+0Ch]
        call ShowDBError
.25:
        cmp eax, byte 0FFFFFFFFh
        je short .26
        cmp eax, byte 1
        jne short .27
.26:
        mov dword [byte esp+018h], 1Ch
.27:
        mov eax, dword [byte esp+018h]
        inc eax
        mov dword [byte esp+018h], eax
        cmp eax, byte 1Ch
        jl near CheckDatabases.1
        mov eax, dword [byte esp+014h]
        add esp, byte 24h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
