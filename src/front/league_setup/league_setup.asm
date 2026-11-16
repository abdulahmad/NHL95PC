; Setting a league up: who controls it, the master password, and writing the season and team records.
bits 32
%include "hockey.inc"
section s_380E9 progbits alloc exec nowrite align=1
extern __CHK, cddriveptr, ClearInputQueue, divisionteams, DrawMenuBar, DrawMenuDropdown, DrawMenuItemNorm, DrawMenuItemSel
extern DrawTeamGrid, DrawTeamGridName, exportmsg, FadePalStep, FileClose, fileoncd, FileOpenRead, FileReadAt
extern FileWriteAt, FreeMemBlock, gameopts, GetInputEvent, HighlightGridCell, leaguedbnames, leagueflags, leaguemaster
extern leaguesaved, lgsetmenu, lgsetshowmenu, ListDialog, mainfont, MakePath, masterpw, memcpy_
extern memset_, MenuHitTest, MessageBox, MouseSetPos, musichandle, musicon, musicslot, passkey
extern passkey_m1, pointerspr, ptrupdatefn, pwmismatchmsg, ReadTeamRec, removeteambtns, removeteammsg, RestoreGridCellBg
extern savedname, SaveGridCellBg, SetDialogColors, SetTextColors, songdata, str_Bkgd8, str_Embnhl, str_EnterMasterControllerPasswor
extern str_EnterMasterPassword, str_EnterPasswordFor, str_extDB, str_Iff10, str_Leaguetm2, str_Menubuff6, str_MightyDucksOfAnaheim3, str_Pal19
extern str_Pal20, str_PLST, str_Pointer9, str_PTLS, str_TPI, str_Tspal, str_VerifyMasterControllerPasswo, str_VerifyPasswordFor
extern str_WhoWillControlThe, str_WhoWillPlayThe, strcat_, strcmp_, strcpy_, stricmp_, strlen_, AllocMemBlock
extern PushMemDescriptorLocked, LoadBank, TextSaveState, TextRestoreState, TextSetFont, LoadDigiFile, PlayDigiBlockLoop, SndQuery
extern SetDigiChannelVolume, SetPalette, PutBlock, DrawArt, GrabBlock, MouseRead, FindShape, ClearScreen
extern SetScreenTarget, SetColorRemap, TeamGridHitTest, teamselmenubar, teamselresult, teamselsetslot, TextInputDialog, str_qmark
extern msg_NameTaken, msg_WrongPassword, yesnobtns
global ChooseLeagueController, AskExportToFloppy, BuildStandingsGrid, TeamSelDone, TeamSelCancel, LeagueTeamSelect, WriteSeasonRec, WriteSeasonRec_common
global ReadGoalieSeasonRec, ReadGoalieSeasonRec_common, WriteGoalieSeasonRec, WriteSchedGame, WriteSchedGame_common, WriteTeamRec, ReadDbRec4Ch, ReadLeagueTeamEntry
global WriteLeagueTeamEntry, ReadDbRec28h, ReadDbRec2Ch, AskTeamPassword, AskTeamPassword_ret, AskMasterPassword, EncryptPassword, MergeTeamRecDelta
global MergeSeasonRecDelta, MergeGoalieRecDelta
;-----------------------------------------------------------------------------
; ChooseLeagueController                                          380E9  95 PC
; New league: "Who will control the league?" ListDialog of the human teams,
; then master controller password entry + verify
;
; (re-asks on "The password was entered differently the second time!"), stored
; EncryptPassword'ed
;-----------------------------------------------------------------------------
; C: src/front/league_setup/ChooseLeagueController.c
%ifdef CBUILD
%include "c/front/league_setup/ChooseLeagueController.inc"
%else
ChooseLeagueController:
        push dword 110h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 0ECh
        mov ebp, eax
        mov dword [dword esp+0D4h], edx
        mov dword [dword esp+0DCh], ebx
        mov dword [dword esp+0D8h], ecx
        mov esi, edx
        shl esi, 2
        push byte 20h
        push esi
        push str_PLST
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+0E4h], eax
        mov ebx, esi
        xor edx, edx
        call memset_
        mov edx, dword [dword esp+0D4h]
        mov esi, edx
        shl esi, 2
        sub esi, edx
        shl esi, 2
        sub esi, edx
        push byte 20h
        push esi
        push str_PTLS
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+0E0h], eax
        mov ebx, esi
        xor edx, edx
        call memset_
        xor esi, esi
        xor ebx, ebx
.1:
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        lea edx, [eax+ebp]
        cmp byte [byte edx+017h], 1
        jne short .2
        lea eax, [byte esp+068h]
        call strcpy_
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        sub eax, esi
        mov edi, dword [dword esp+0E0h]
        add edi, eax
        lea edx, [byte esp+068h]
        mov eax, edi
        call strcpy_
        mov eax, esi
        shl eax, 2
        mov dword [esp+eax], ebx
        add eax, dword [dword esp+0E4h]
        mov dword [eax], edi
        inc esi
.2:
        inc ebx
        cmp ebx, byte 1Ah
        jl short ChooseLeagueController.1
        cmp dword [dword esp+0D4h], byte 1
        jle short .3
        push byte 0
        push byte 0
        xor ecx, ecx
        mov ebx, str_WhoWillControlThe
        mov edx, dword [dword esp+0DCh]
        mov eax, dword [dword esp+0ECh]
        call ListDialog
        mov esi, eax
        jmp short .6
.3:
        xor esi, esi
        xor ebx, ebx
.4:
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        cmp byte [byte ebp+eax*2+017h], 1
        jne short .5
        mov dword [esp], ebx
        mov ebx, 1Ah
.5:
        inc ebx
        cmp ebx, byte 1Ah
        jl short ChooseLeagueController.4
.6:
        mov ebx, dword [esp+esi*4]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        mov byte [byte ebp+eax*2+018h], 1
        mov ebx, dword [esp+esi*4]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        mov byte [byte ebp+eax*2+019h], 1
        mov eax, dword [esp+esi*4]
        mov dword [leaguemaster], eax
        mov edi, dword [dword esp+0D8h]
.7:
        xor ecx, ecx
        mov dword [dword esp+0E8h], ecx
        mov edx, str_EnterMasterControllerPasswor
        lea eax, [byte esp+068h]
        call strcpy_
        mov edx, dword [esp+esi*4]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        lea eax, [byte esp+068h]
        call strcat_
        push byte 2
        push ecx
        push ecx
        push ecx
        push ecx
        mov ecx, 3Ch
        mov ebx, 0Ah
        lea edx, [dword esp+0D0h]
        lea eax, [byte esp+07Ch]
        call TextInputDialog
        mov edx, str_VerifyMasterControllerPasswo
        lea eax, [byte esp+068h]
        call strcpy_
        mov edx, dword [esp+esi*4]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        lea eax, [byte esp+068h]
        call strcat_
        push byte 2
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        mov ecx, 3Ch
        mov ebx, 0Ah
        lea edx, [dword esp+0DCh]
        lea eax, [byte esp+07Ch]
        call TextInputDialog
        lea edx, [dword esp+0C8h]
        lea eax, [dword esp+0BCh]
        call strcmp_
        test eax, eax
        je short .8
        push byte 0FFFFFFFFh
        push edi
        mov eax, dword [dword esp+0E4h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, pwmismatchmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [dword esp+0E8h], 0FFFFFFFFh
.8:
        mov ebx, dword [dword esp+0E8h]
        test ebx, ebx
        jne near ChooseLeagueController.7
        lea edx, [dword esp+0BCh]
        mov eax, masterpw
        call strcpy_
        mov edx, dword [esp+esi*4]
        mov eax, masterpw
        call EncryptPassword
        mov dword [leagueflags], ebx
        mov dword [leaguesaved], ebx
        xor dh, dh
        mov byte [savedname], dh
        mov edi, dword [dword esp+0E4h]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [dword esp+0E0h]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        add esp, 0ECh
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; AskExportToFloppy                            38386  95 PC, medium confidence
; For human teams kept on floppy: MessageBox "Do you want to export <team> to
; a floppy disk?" (Yes / No)
;-----------------------------------------------------------------------------
; C: src/front/league_setup/AskExportToFloppy.c
%ifdef CBUILD
%include "c/front/league_setup/AskExportToFloppy.inc"
%else
AskExportToFloppy:
        push dword 34h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov esi, eax
        mov ebp, edx
        mov dword [byte esp+0Ch], ebx
        mov edi, ecx
        mov eax, esp
        push eax
        lea eax, [byte esp+08h]
        push eax
        lea eax, [byte esp+010h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        xor edx, edx
        mov dword [byte esp+08h], edx
.1:
        test byte [byte esp+0Ch], 1
        je short .2
        mov edx, dword [byte esp+08h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, esi
        cmp byte [byte eax+017h], 1
        jne short .2
        cmp byte [byte eax+018h], 2
        je short .3
.2:
        test byte [byte esp+0Ch], 2
        je near .4
        mov edx, dword [byte esp+08h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        lea edx, [eax+eax]
        cmp byte [byte edx+esi+017h], 1
        jne near .4
        cmp byte [byte edx+ebp+017h], 0
        jne short .4
.3:
        mov edx, dword [byte esp+08h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, esi
        cmp edi, byte 1
        jle short .5
        mov dword [exportmsg+4], eax
        push byte 0FFFFFFFFh
        lea eax, [byte esp+04h]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        push byte 2
        push yesnobtns
        mov ecx, 3
        mov ebx, exportmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov edx, eax
        mov ebx, dword [byte esp+08h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, esi
        cmp edx, byte 1
        je short .5
        mov byte [byte eax+018h], 2
        mov edx, dword [byte esp+08h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        mov byte [byte esi+eax*2+016h], 2
        jmp short .6
.4:
        mov edx, dword [byte esp+08h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, esi
        cmp byte [byte eax+017h], 0
        jne short .6
.5:
        mov byte [byte eax+018h], 1
        mov edx, dword [byte esp+08h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        mov byte [byte esi+eax*2+016h], 1
.6:
        mov ebx, dword [byte esp+08h]
        inc ebx
        mov dword [byte esp+08h], ebx
        cmp ebx, byte 1Ah
        jl near AskExportToFloppy.1
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; BuildStandingsGrid                           384B8  95 PC, medium confidence
; Reads the 26 team records and orders each division (divisionteams) by points
; (2 x rec+29h + rec+2Bh, then the +2Ch/+2Eh words) into the 4 x 7 grid
;-----------------------------------------------------------------------------
BuildStandingsGrid:
        push dword 7A8h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 790h
        mov ecx, eax
        mov ebp, edx
        xor esi, esi
.1:
        mov ebx, esi
        mov edx, esp
        mov eax, ecx
        call ReadTeamRec
        mov dword [dword esp+078Ch], eax
        xor edx, edx
        mov dl, byte [byte esp+028h]
        mov dword [dword esp+esi*4+0720h], edx
        xor edx, edx
        mov dl, byte [byte esp+029h]
        mov dword [dword esp+esi*4+0518h], edx
        xor edx, edx
        mov dl, byte [byte esp+02Ah]
        mov dword [dword esp+esi*4+05E8h], edx
        xor edx, edx
        mov dl, byte [byte esp+02Bh]
        mov dword [dword esp+esi*4+0580h], edx
        xor edx, edx
        mov dx, word [byte esp+02Ch]
        mov dword [dword esp+esi*4+0650h], edx
        xor edx, edx
        mov dx, word [byte esp+02Eh]
        mov dword [dword esp+esi*4+06B8h], edx
        inc esi
        cmp esi, byte 1Ah
        jl short BuildStandingsGrid.1
        xor esi, esi
.2:
        xor ecx, ecx
.3:
        mov eax, esi
        shl eax, 3
        sub eax, esi
        mov ebx, eax
        xor eax, eax
        mov al, byte [dword ecx+ebx+divisionteams]
        mov edx, dword [dword esp+eax*4+0518h]
        add edx, edx
        mov edi, dword [dword esp+eax*4+0580h]
        add edi, edx
        mov dword [dword esp+0788h], edi
        mov edx, esi
        shl edx, 3
        sub edx, esi
        shl edx, 2
        mov edi, ecx
        shl edi, 2
        add edx, edi
        mov edi, dword [dword esp+0788h]
        mov dword [dword esp+edx+02E8h], edi
        mov edi, dword [dword esp+eax*4+0720h]
        mov dword [dword esp+edx+0358h], edi
        mov edi, dword [dword esp+eax*4+0518h]
        mov dword [dword esp+edx+03C8h], edi
        mov edi, dword [dword esp+eax*4+0650h]
        mov dword [dword esp+edx+04A8h], edi
        mov eax, dword [dword esp+eax*4+06B8h]
        mov dword [dword esp+edx+0438h], eax
        mov eax, ebx
        add eax, ebp
        mov dl, byte [dword ecx+ebx+divisionteams]
        mov byte [ecx+eax], dl
        inc ecx
        cmp ecx, byte 7
        jl near BuildStandingsGrid.3
        inc esi
        cmp esi, byte 4
        jl near BuildStandingsGrid.2
        xor esi, esi
.4:
        xor ecx, ecx
.5:
        lea ebx, [byte ecx+01h]
        jmp near .12
.6:
        mov edx, esi
        shl edx, 3
        sub edx, esi
        shl edx, 2
        mov eax, ebx
        shl eax, 2
        add eax, edx
        mov edi, ecx
        shl edi, 2
        add edx, edi
        mov edi, dword [dword esp+eax+02E8h]
        cmp edi, dword [dword esp+edx+02E8h]
        jg near .10
        jne short .7
        mov eax, dword [dword esp+eax+0358h]
        cmp eax, dword [dword esp+edx+0358h]
        jl near .10
.7:
        mov eax, esi
        shl eax, 3
        sub eax, esi
        shl eax, 2
        mov edx, ebx
        shl edx, 2
        add edx, eax
        mov edi, ecx
        shl edi, 2
        add eax, edi
        mov edi, dword [dword esp+edx+02E8h]
        cmp edi, dword [dword esp+eax+02E8h]
        jne short .8
        mov edi, dword [dword esp+edx+0358h]
        cmp edi, dword [dword esp+eax+0358h]
        jne short .8
        mov edx, dword [dword esp+edx+03C8h]
        cmp edx, dword [dword esp+eax+03C8h]
        jg near .10
.8:
        mov edx, esi
        shl edx, 3
        sub edx, esi
        shl edx, 2
        mov eax, ebx
        shl eax, 2
        add eax, edx
        mov edi, ecx
        shl edi, 2
        add edx, edi
        mov edi, dword [dword esp+eax+02E8h]
        cmp edi, dword [dword esp+edx+02E8h]
        jne short .9
        mov edi, dword [dword esp+eax+0358h]
        cmp edi, dword [dword esp+edx+0358h]
        jne short .9
        mov edi, dword [dword esp+eax+03C8h]
        cmp edi, dword [dword esp+edx+03C8h]
        jne short .9
        mov eax, dword [dword esp+eax+04A8h]
        cmp eax, dword [dword esp+edx+04A8h]
        jg short .10
.9:
        mov eax, esi
        shl eax, 3
        sub eax, esi
        shl eax, 2
        mov edx, ebx
        shl edx, 2
        add edx, eax
        mov edi, ecx
        shl edi, 2
        add eax, edi
        mov edi, dword [dword esp+edx+02E8h]
        cmp edi, dword [dword esp+eax+02E8h]
        jne near .11
        mov edi, dword [dword esp+edx+0358h]
        cmp edi, dword [dword esp+eax+0358h]
        jne near .11
        mov edi, dword [dword esp+edx+03C8h]
        cmp edi, dword [dword esp+eax+03C8h]
        jne near .11
        mov edi, dword [dword esp+edx+04A8h]
        cmp edi, dword [dword esp+eax+04A8h]
        jne near .11
        mov edx, dword [dword esp+edx+0438h]
        cmp edx, dword [dword esp+eax+0438h]
        jge near .11
.10:
        mov edx, esi
        shl edx, 3
        sub edx, esi
        shl edx, 2
        mov eax, ebx
        shl eax, 2
        add eax, edx
        mov edi, ecx
        shl edi, 2
        add edx, edi
        mov edi, dword [dword esp+edx+02E8h]
        xor dword [dword esp+eax+02E8h], edi
        mov edi, dword [dword esp+eax+02E8h]
        xor dword [dword esp+edx+02E8h], edi
        mov edi, dword [dword esp+edx+02E8h]
        xor dword [dword esp+eax+02E8h], edi
        mov edi, dword [dword esp+edx+0358h]
        xor dword [dword esp+eax+0358h], edi
        mov edi, dword [dword esp+eax+0358h]
        xor dword [dword esp+edx+0358h], edi
        mov edi, dword [dword esp+edx+0358h]
        xor dword [dword esp+eax+0358h], edi
        mov edi, dword [dword esp+edx+03C8h]
        xor dword [dword esp+eax+03C8h], edi
        mov edi, dword [dword esp+eax+03C8h]
        xor dword [dword esp+edx+03C8h], edi
        mov edi, dword [dword esp+edx+03C8h]
        xor dword [dword esp+eax+03C8h], edi
        mov edi, dword [dword esp+edx+04A8h]
        xor dword [dword esp+eax+04A8h], edi
        mov edi, dword [dword esp+eax+04A8h]
        xor dword [dword esp+edx+04A8h], edi
        mov edi, dword [dword esp+edx+04A8h]
        xor dword [dword esp+eax+04A8h], edi
        mov edi, dword [dword esp+edx+0438h]
        xor dword [dword esp+eax+0438h], edi
        mov edi, dword [dword esp+eax+0438h]
        xor dword [dword esp+edx+0438h], edi
        mov edx, dword [dword esp+edx+0438h]
        xor dword [dword esp+eax+0438h], edx
        mov eax, esi
        shl eax, 3
        sub eax, esi
        lea edi, [eax+ebp]
        mov dl, byte [ecx+edi]
        mov ah, byte [edi+ebx]
        xor ah, dl
        mov byte [edi+ebx], ah
        mov dh, byte [ecx+edi]
        xor dh, ah
        mov byte [ecx+edi], dh
        xor byte [edi+ebx], dh
.11:
        inc ebx
.12:
        cmp ebx, byte 6
        jl near BuildStandingsGrid.6
        inc ecx
        cmp ecx, byte 5
        jl near BuildStandingsGrid.5
        inc esi
        cmp esi, byte 2
        jl near BuildStandingsGrid.4
        jmp near .22
.13:
        xor ecx, ecx
.14:
        lea ebx, [byte ecx+01h]
        jmp near .21
.15:
        mov edx, esi
        shl edx, 3
        sub edx, esi
        shl edx, 2
        mov eax, ebx
        shl eax, 2
        add eax, edx
        mov edi, ecx
        shl edi, 2
        add edx, edi
        mov edi, dword [dword esp+eax+02E8h]
        cmp edi, dword [dword esp+edx+02E8h]
        jg near .19
        jne short .16
        mov eax, dword [dword esp+eax+0358h]
        cmp eax, dword [dword esp+edx+0358h]
        jl near .19
.16:
        mov edx, esi
        shl edx, 3
        sub edx, esi
        shl edx, 2
        mov eax, ebx
        shl eax, 2
        add eax, edx
        mov edi, ecx
        shl edi, 2
        add edx, edi
        mov edi, dword [dword esp+eax+02E8h]
        cmp edi, dword [dword esp+edx+02E8h]
        jne short .17
        mov edi, dword [dword esp+eax+0358h]
        cmp edi, dword [dword esp+edx+0358h]
        jne short .17
        mov eax, dword [dword esp+eax+03C8h]
        cmp eax, dword [dword esp+edx+03C8h]
        jg near .19
.17:
        mov eax, esi
        shl eax, 3
        sub eax, esi
        shl eax, 2
        mov edx, ebx
        shl edx, 2
        add edx, eax
        mov edi, ecx
        shl edi, 2
        add eax, edi
        mov edi, dword [dword esp+edx+02E8h]
        cmp edi, dword [dword esp+eax+02E8h]
        jne short .18
        mov edi, dword [dword esp+edx+0358h]
        cmp edi, dword [dword esp+eax+0358h]
        jne short .18
        mov edi, dword [dword esp+edx+03C8h]
        cmp edi, dword [dword esp+eax+03C8h]
        jne short .18
        mov edx, dword [dword esp+edx+04A8h]
        cmp edx, dword [dword esp+eax+04A8h]
        jg short .19
.18:
        mov edx, esi
        shl edx, 3
        sub edx, esi
        shl edx, 2
        mov eax, ebx
        shl eax, 2
        add eax, edx
        mov edi, ecx
        shl edi, 2
        add edx, edi
        mov edi, dword [dword esp+eax+02E8h]
        cmp edi, dword [dword esp+edx+02E8h]
        jne near .20
        mov edi, dword [dword esp+eax+0358h]
        cmp edi, dword [dword esp+edx+0358h]
        jne near .20
        mov edi, dword [dword esp+eax+03C8h]
        cmp edi, dword [dword esp+edx+03C8h]
        jne near .20
        mov edi, dword [dword esp+eax+04A8h]
        cmp edi, dword [dword esp+edx+04A8h]
        jne near .20
        mov eax, dword [dword esp+eax+0438h]
        cmp eax, dword [dword esp+edx+0438h]
        jge near .20
.19:
        mov edx, esi
        shl edx, 3
        sub edx, esi
        shl edx, 2
        mov eax, ebx
        shl eax, 2
        add eax, edx
        mov edi, ecx
        shl edi, 2
        add edx, edi
        mov edi, dword [dword esp+edx+02E8h]
        xor dword [dword esp+eax+02E8h], edi
        mov edi, dword [dword esp+eax+02E8h]
        xor dword [dword esp+edx+02E8h], edi
        mov edi, dword [dword esp+edx+02E8h]
        xor dword [dword esp+eax+02E8h], edi
        mov edi, dword [dword esp+edx+0358h]
        xor dword [dword esp+eax+0358h], edi
        mov edi, dword [dword esp+eax+0358h]
        xor dword [dword esp+edx+0358h], edi
        mov edi, dword [dword esp+edx+0358h]
        xor dword [dword esp+eax+0358h], edi
        mov edi, dword [dword esp+edx+03C8h]
        xor dword [dword esp+eax+03C8h], edi
        mov edi, dword [dword esp+eax+03C8h]
        xor dword [dword esp+edx+03C8h], edi
        mov edi, dword [dword esp+edx+03C8h]
        xor dword [dword esp+eax+03C8h], edi
        mov edi, dword [dword esp+edx+04A8h]
        xor dword [dword esp+eax+04A8h], edi
        mov edi, dword [dword esp+eax+04A8h]
        xor dword [dword esp+edx+04A8h], edi
        mov edi, dword [dword esp+edx+04A8h]
        xor dword [dword esp+eax+04A8h], edi
        mov edi, dword [dword esp+edx+0438h]
        xor dword [dword esp+eax+0438h], edi
        mov edi, dword [dword esp+eax+0438h]
        xor dword [dword esp+edx+0438h], edi
        mov edx, dword [dword esp+edx+0438h]
        xor dword [dword esp+eax+0438h], edx
        mov eax, esi
        shl eax, 3
        sub eax, esi
        lea edi, [eax+ebp]
        mov dl, byte [ecx+edi]
        mov ah, byte [edi+ebx]
        xor ah, dl
        mov byte [edi+ebx], ah
        mov dh, byte [ecx+edi]
        xor dh, ah
        mov byte [ecx+edi], dh
        xor byte [edi+ebx], dh
.20:
        inc ebx
.21:
        cmp ebx, byte 7
        jl near BuildStandingsGrid.15
        inc ecx
        cmp ecx, byte 6
        jl near BuildStandingsGrid.14
        inc esi
.22:
        cmp esi, byte 4
        jl near BuildStandingsGrid.13
        mov eax, dword [dword esp+078Ch]
        add esp, 790h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; TeamSelDone                                                     38B25  95 PC
; Team select menu "Done": teamselresult = 1
;-----------------------------------------------------------------------------
; C: src/front/league_setup/TeamSelDone.c
%ifdef CBUILD
%include "c/front/league_setup/TeamSelDone.inc"
%else
TeamSelDone:
        push dword 4
        call __CHK
        mov dword [teamselresult], 1
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TeamSelCancel                                                   38B3A  95 PC
; Team select menu "Cancel": teamselresult = -1
;-----------------------------------------------------------------------------
; C: src/front/league_setup/TeamSelCancel.c
%ifdef CBUILD
%include "c/front/league_setup/TeamSelCancel.inc"
%else
TeamSelCancel:
        push dword 4
        call __CHK
        mov dword [teamselresult], 0FFFFFFFFh
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LeagueTeamSelect                                                38B4F  95 PC
; League team grid screen (TPI / embnhl / leaguetm): standings-ordered
; division grid, pick a team ("Select a team to play.",
;
; "Who will play the <team>?"), remove confirmation, Settings menu; used by
; PlayLeagueGame, schedule and trades
;-----------------------------------------------------------------------------
LeagueTeamSelect:
        push dword 2B4h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 290h
        mov esi, eax
        mov dword [dword esp+0250h], edx
        mov dword [dword esp+0254h], ebx
        mov dword [dword esp+0258h], ecx
        mov dword [dword esp+0268h], 40h
        mov dword [dword esp+0270h], 41h
        mov dword [dword esp+026Ch], 42h
        xor edi, edi
        mov dword [dword esp+0284h], edi
        lea eax, [dword esp+0154h]
        push eax
        call TextSaveState
        add esp, byte 4
        mov ebp, dword [mainfont]
        push ebp
        call TextSetFont
        add esp, byte 4
        call SetScreenTarget
        mov dword [dword esp+028Ch], edi
.1:
        mov eax, dword [dword esp+028Ch]
        mov dl, byte [dword esp+028Ch]
        mov byte [esp+eax], dl
        lea edx, [byte eax+01h]
        mov dword [dword esp+028Ch], edx
        cmp edx, 100h
        jl short LeagueTeamSelect.1
        mov eax, esp
        push eax
        call SetColorRemap
        add esp, byte 4
        push byte 0
        mov ecx, 40h
        mov ebx, 42h
        mov edx, ecx
        mov eax, 41h
        call SetDialogColors
        test byte [dword esp+02A0h], 1
        je short .2
        xor ecx, ecx
        mov ebx, 1Ch
        mov edx, divisionteams
        lea eax, [dword esp+01B4h]
        call memcpy_
        jmp short .4
.2:
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, esi
        lea eax, [dword esp+0194h]
        call MakePath
        lea edx, [dword esp+0244h]
        lea eax, [dword esp+0194h]
        call FileOpenRead
        mov ecx, eax
        test eax, eax
        jne short .3
        lea edx, [dword esp+01B4h]
        mov eax, dword [dword esp+0244h]
        call BuildStandingsGrid
        mov ecx, eax
.3:
        lea eax, [dword esp+0244h]
        call FileClose
.4:
        test ecx, ecx
        jne near .81
        cmp dword [dword esp+02A0h], byte 8
        jne short .5
        mov eax, dword [dword esp+0250h]
        cmp dword [eax], byte 1
        je short .6
.5:
        mov eax, 1
        jmp short .7
.6:
        xor eax, eax
.7:
        test eax, eax
        je near .81
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
        push byte 20h
        push dword 300h
        push str_Pal19
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
        je short .9
        cmp dword [songdata], byte 0
        je short .9
.8:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short LeagueTeamSelect.8
        mov edi, dword [songdata]
        push edi
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ebp, ebp
        mov dword [songdata], ebp
.9:
        push byte 20h
        push dword 30Ch
        push str_TPI
        call AllocMemBlock
        add esp, byte 0Ch
        mov ebp, eax
        mov ebx, 30Ch
        mov edx, dword [dword esp+0258h]
        call memcpy_
        xor ecx, ecx
        mov ebx, str_Embnhl
        cmp byte [fileoncd+08Ch], 1
        jne short .10
        mov edx, dword [cddriveptr]
        jmp short .11
.10:
        xor edx, edx
.11:
        lea eax, [dword esp+0194h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0198h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [dword esp+024Ch], eax
        push str_Bkgd8
        push eax
        call FindShape
        mov esi, eax
        add esp, byte 8
        mov dword [dword esp+025Ch], eax
        call SetScreenTarget
        push byte 0
        call ClearScreen
        add esp, byte 4
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        push byte 0
        push byte 0
        push esi
        call DrawArt
        add esp, byte 0Ch
        mov ecx, esi
        lea ebx, [dword esp+01B4h]
        mov edx, dword [dword esp+02A4h]
        mov eax, ebp
        call DrawTeamGrid
        mov ah, byte [dword esp+02A0h]
        test ah, 1
        je short .13
        mov dword [teamselsetslot], lgsetmenu
.12:
        mov dword [dword esp+0218h], 2
        jmp short .15
.13:
        test ah, 8
        je short .14
        mov dword [teamselsetslot], lgsetshowmenu
        jmp short LeagueTeamSelect.12
.14:
        xor eax, eax
        mov dword [teamselsetslot], eax
        mov dword [dword esp+0218h], 1
.15:
        mov eax, teamselmenubar
        mov dword [dword esp+0208h], eax
        xor edx, edx
        mov dword [dword esp+020Ch], edx
        mov dword [dword esp+0210h], edx
        mov dword [dword esp+0214h], edx
        mov dword [dword esp+01E0h], edx
        mov dword [dword esp+01E4h], edx
        mov dword [dword esp+01D0h], edx
        mov dword [dword esp+01D4h], edx
        mov ebx, dword [dword esp+026Ch]
        push ebx
        mov ecx, dword [dword esp+0274h]
        mov ebx, dword [dword esp+026Ch]
        mov edx, dword [dword esp+021Ch]
        call DrawMenuBar
        xor ecx, ecx
        mov dword [dword esp+0288h], ecx
        xor eax, eax
        mov al, byte [dword esp+01B4h]
        mov edx, dword [dword esp+02A8h]
        mov dword [edx], eax
        mov ebx, 0FFFFFFFFh
        lea edx, [dword esp+01B4h]
        call HighlightGridCell
        cmp dword [dword esp+02A0h], byte 1
        jne short .16
        mov dword [dword esp+0264h], ecx
        jmp short .17
.16:
        mov eax, dword [dword esp+0250h]
        mov eax, dword [eax]
        mov dword [dword esp+0264h], eax
.17:
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
        push str_Pointer9
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+0280h], eax
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
        cmp byte [musicon], 0
        je short .20
        cmp dword [songdata], byte 0
        jne short .20
        mov ecx, str_Iff10
        mov ebx, str_Leaguetm2
        cmp byte [fileoncd+01E0h], 1
        jne short .18
        mov edx, dword [cddriveptr]
        jmp short .19
.18:
        xor edx, edx
.19:
        lea eax, [dword esp+0194h]
        call MakePath
        lea eax, [dword esp+0194h]
        call LoadDigiFile
        mov dword [songdata], eax
        test eax, eax
        je short .20
        test byte [gameopts], 40h
        je short .20
        mov edx, dword [musichandle]
        mov ecx, 4Ch
        mov ebx, 3
        call PlayDigiBlockLoop
.20:
        xor ecx, ecx
        mov ebx, str_Tspal
        cmp byte [fileoncd+01ADh], 1
        jne short .21
        mov edx, dword [cddriveptr]
        jmp short .22
.21:
        xor edx, edx
.22:
        lea eax, [dword esp+0194h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0198h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push str_Pal20
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
        lea eax, [dword esp+0238h]
        push eax
        lea eax, [dword esp+0240h]
        push eax
        lea eax, [dword esp+0248h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov eax, dword [dword esp+023Ch]
        mov dword [dword esp+0234h], eax
        mov eax, dword [dword esp+0238h]
        mov dword [dword esp+0230h], eax
        push eax
        mov eax, dword [dword esp+0240h]
        sub eax, byte 4
        push eax
        mov ebx, dword [dword esp+0288h]
        push ebx
        call GrabBlock
        add esp, byte 0Ch
        mov ecx, dword [dword esp+0238h]
        push ecx
        mov eax, dword [dword esp+0240h]
        sub eax, byte 4
        push eax
        mov esi, dword [pointerspr]
        push esi
        call DrawArt
        add esp, byte 0Ch
        call ClearInputQueue
        xor edi, edi
        mov dword [dword esp+0260h], edi
        mov dword [teamselresult], edi
.23:
        xor ecx, ecx
.24:
        call GetInputEvent
        mov esi, eax
        test eax, eax
        je short .25
        lea ebx, [dword esp+0230h]
        lea edx, [dword esp+0234h]
        call dword [ptrupdatefn]
        mov ecx, eax
.25:
        test esi, esi
        je short .26
        test cl, 2
        je short LeagueTeamSelect.24
.26:
        test cl, 2
        jne short .28
        mov eax, dword [dword esp+0234h]
        cmp eax, dword [dword esp+023Ch]
        jne short .27
        mov eax, dword [dword esp+0230h]
        cmp eax, dword [dword esp+0238h]
        je near .78
.27:
        mov ecx, dword [dword esp+0238h]
        push ecx
        mov eax, dword [dword esp+0240h]
        sub eax, byte 4
        push eax
        mov esi, dword [dword esp+0288h]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [dword esp+0230h]
        push edi
        mov eax, dword [dword esp+0238h]
        sub eax, byte 4
        push eax
        push esi
        call GrabBlock
        add esp, byte 0Ch
        jmp near .76
.28:
        lea eax, [dword esp+0224h]
        push eax
        lea eax, [dword esp+022Ch]
        push eax
        lea eax, [dword esp+01D8h]
        push eax
        lea eax, [dword esp+0224h]
        push eax
        mov ecx, dword [dword esp+0294h]
        lea ebx, [dword esp+0218h]
        mov edx, dword [dword esp+0240h]
        mov eax, dword [dword esp+0244h]
        call MenuHitTest
        mov edx, dword [dword esp+023Ch]
        sub edx, byte 4
        test eax, eax
        je near .50
        mov ebx, dword [dword esp+0228h]
        shl ebx, 2
        mov ecx, dword [dword esp+0224h]
        shl ecx, 5
        mov eax, dword [dword esp+ebx+0208h]
        add eax, ecx
        cmp dword [byte eax+014h], byte 0
        je near .39
        mov eax, dword [dword esp+0224h]
        cmp eax, dword [dword esp+ebx+01E0h]
        jne near .38
        mov esi, dword [dword esp+0238h]
        push esi
        push edx
        mov edi, dword [dword esp+0288h]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov dword [dword esp+028Ch], 1
        jmp short .31
.29:
        mov edi, ebx
        shl edi, 2
        mov ebx, dword [dword esp+edi+0210h]
        test ebx, ebx
        je short .30
        mov esi, dword [dword esp+028Ch]
        mov ecx, dword [dword esp+esi*8+01D4h]
        push ecx
        mov eax, dword [dword esp+esi*8+01D4h]
        push eax
        push ebx
        call PutBlock
        add esp, byte 0Ch
        xor ebx, ebx
        mov dword [dword esp+esi*8+01D0h], ebx
        mov dword [dword esp+esi*8+01D4h], ebx
        mov esi, dword [dword esp+edi+0210h]
        push esi
        call FreeMemBlock
        add esp, byte 4
.30:
        dec dword [dword esp+028Ch]
.31:
        mov ebx, dword [dword esp+028Ch]
        test ebx, ebx
        jge short LeagueTeamSelect.29
        xor ecx, ecx
        mov dword [dword esp+0284h], ecx
        mov eax, dword [dword esp+0228h]
        mov edx, dword [dword esp+0224h]
        shl edx, 5
        mov eax, dword [dword esp+eax*4+0208h]
        call dword [byte edx+eax+014h]
        mov esi, dword [teamselresult]
        cmp esi, byte 0FFFFFFFFh
        jne near .33
        mov eax, dword [dword esp+0288h]
        shl eax, 2
        add eax, dword [dword esp+02A8h]
        mov dword [eax], 0FFFFFFFFh
        push byte 20h
        push dword 300h
        push str_Pal19
        call AllocMemBlock
        add esp, byte 0Ch
        mov esi, eax
        cmp byte [musicon], 0
        je short .32
        cmp dword [songdata], byte 0
        je short .32
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.32:
        push esi
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
        jmp near .36
.33:
        cmp esi, byte 1
        jne near .37
        test byte [dword esp+02A0h], 7
        je short .34
        cmp esi, dword [dword esp+0264h]
        jle near .36
.34:
        test byte [dword esp+02A0h], 8
        je short .35
        mov eax, dword [dword esp+0288h]
        shl eax, 2
        add eax, dword [dword esp+02A8h]
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [byte ebp+eax*2+017h], 1
        je short .36
.35:
        test byte [dword esp+02A0h], 10h
        je short .37
        cmp dword [dword esp+0288h], byte 1
        jne short .37
        mov edx, dword [dword esp+02A8h]
        mov edx, dword [edx]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        mov bl, byte [byte ebp+eax*2+017h]
        cmp bl, 1
        jne short .37
        mov edx, dword [dword esp+02A8h]
        mov edx, dword [byte edx+04h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp bl, byte [byte ebp+eax*2+017h]
        jne short .37
.36:
        mov dword [dword esp+0260h], 0FFFFFFFFh
.37:
        xor edx, edx
        mov dword [dword esp+020Ch], edx
        mov dword [dword esp+0210h], edx
        mov dword [dword esp+0214h], edx
        mov dword [dword esp+01E4h], edx
        mov dword [dword esp+021Ch], edx
        mov eax, dword [dword esp+0238h]
        push eax
        mov edx, dword [dword esp+0240h]
        push edx
        call MouseSetPos
        add esp, byte 8
        mov eax, dword [dword esp+023Ch]
        mov dword [dword esp+0234h], eax
        mov eax, dword [dword esp+0238h]
        mov dword [dword esp+0230h], eax
        call ClearInputQueue
        jmp near .75
.38:
        mov esi, dword [dword esp+0238h]
        push esi
        push edx
        mov edi, dword [dword esp+0288h]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+026Ch]
        push eax
        mov edx, dword [dword esp+0274h]
        push edx
        mov eax, dword [dword esp+0230h]
        mov ebx, dword [dword esp+eax*8+01DCh]
        mov edx, dword [dword esp+eax*8+01D8h]
        mov ecx, dword [dword esp+eax*4+01E8h]
        shl ecx, 5
        mov eax, dword [dword esp+eax*4+0210h]
        add eax, ecx
        mov ecx, dword [dword esp+0270h]
        call DrawMenuItemSel
        mov edx, dword [dword esp+0228h]
        mov eax, dword [dword esp+0224h]
        mov dword [dword esp+edx*4+01E0h], eax
        mov ebx, dword [dword esp+026Ch]
        push ebx
        mov ecx, dword [dword esp+0274h]
        push ecx
        mov ebx, dword [dword esp+edx*8+01DCh]
        mov esi, dword [dword esp+edx*8+01D8h]
        shl eax, 5
        mov edx, dword [dword esp+edx*4+0210h]
        add eax, edx
        mov ecx, dword [dword esp+0270h]
        mov edx, esi
        jmp near .49
.39:
        cmp dword [byte eax+018h], byte 0
        je near .48
        mov edi, dword [dword esp+0238h]
        push edi
        push edx
        mov eax, dword [dword esp+0288h]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+0284h]
        cmp eax, dword [dword esp+0228h]
        je near .43
        mov dword [dword esp+028Ch], eax
        jmp short .42
.40:
        mov esi, eax
        shl esi, 2
        xor edi, edi
        mov dword [dword esp+esi+01E0h], edi
        mov eax, dword [dword esp+esi+0210h]
        test eax, eax
        je short .41
        mov edi, dword [dword esp+028Ch]
        mov edx, dword [dword esp+edi*8+01D4h]
        push edx
        mov ebx, dword [dword esp+edi*8+01D4h]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [dword esp+edi*8+01D0h], eax
        mov dword [dword esp+edi*8+01D4h], eax
        mov ebx, dword [dword esp+esi+0210h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [dword esp+esi+0210h], ecx
        mov dword [dword esp+esi+0208h], ecx
        mov dword [dword esp+esi+0218h], ecx
.41:
        dec dword [dword esp+028Ch]
.42:
        mov eax, dword [dword esp+028Ch]
        mov ecx, dword [dword esp+0228h]
        cmp eax, ecx
        jg near LeagueTeamSelect.40
        mov dword [dword esp+0284h], ecx
.43:
        mov ebx, dword [dword esp+026Ch]
        push ebx
        mov ecx, dword [dword esp+0274h]
        push ecx
        mov esi, dword [dword esp+028Ch]
        mov ebx, dword [dword esp+esi*8+01DCh]
        mov edx, dword [dword esp+esi*8+01D8h]
        mov eax, dword [dword esp+esi*4+01E8h]
        shl eax, 5
        mov dword [dword esp+0250h], eax
        mov eax, dword [dword esp+esi*4+0210h]
        add eax, dword [dword esp+0250h]
        mov ecx, dword [dword esp+0270h]
        call DrawMenuItemSel
        mov eax, dword [dword esp+0224h]
        mov dword [dword esp+esi*4+01E0h], eax
        mov eax, dword [dword esp+026Ch]
        push eax
        mov edx, dword [dword esp+0274h]
        push edx
        mov ebx, dword [dword esp+esi*8+01DCh]
        mov edx, dword [dword esp+esi*8+01D8h]
        mov ecx, dword [dword esp+022Ch]
        shl ecx, 5
        mov eax, dword [dword esp+esi*4+0210h]
        add eax, ecx
        mov ecx, dword [dword esp+0270h]
        call DrawMenuItemNorm
        mov eax, dword [dword esp+0228h]
        mov ebx, dword [dword esp+0224h]
        shl ebx, 5
        mov ecx, dword [dword esp+eax*4+0208h]
        inc esi
        mov dword [dword esp+0284h], esi
        mov ecx, dword [byte ecx+ebx+018h]
        mov dword [dword esp+esi*4+0208h], ecx
        mov eax, dword [dword esp+eax*4+0208h]
        add eax, ebx
        mov ebx, dword [byte eax+01Ch]
        mov dword [dword esp+esi*4+0218h], ebx
        cmp esi, byte 1
        je short .44
        mov edx, dword [byte eax+08h]
        jmp short .45
.44:
        mov edx, dword [eax]
.45:
        mov eax, dword [dword esp+0284h]
        mov ebx, dword [dword esp+eax*8+01C8h]
        add edx, ebx
        mov dword [dword esp+eax*8+01D0h], edx
        mov edx, dword [dword esp+0224h]
        shl edx, 5
        mov eax, dword [dword esp+0228h]
        shl eax, 2
        cmp dword [dword esp+0284h], byte 1
        je short .46
        mov eax, dword [dword esp+eax+0208h]
        mov eax, dword [byte edx+eax+04h]
        jmp short .47
.46:
        mov eax, dword [dword esp+eax+0208h]
        mov eax, dword [byte edx+eax+0Ch]
.47:
        mov edx, dword [dword esp+0284h]
        shl edx, 3
        mov dword [dword esp+0278h], edx
        mov esi, dword [dword esp+edx+01CCh]
        add eax, esi
        mov dword [dword esp+edx+01D4h], eax
        mov eax, dword [dword esp+0284h]
        shl eax, 2
        mov dword [dword esp+027Ch], eax
        mov edx, dword [dword esp+eax+0218h]
        shl edx, 5
        mov eax, dword [dword esp+eax+0208h]
        mov ebx, dword [byte edx+eax-018h]
        sub ebx, dword [eax]
        inc ebx
        mov dword [dword esp+022Ch], ebx
        mov edx, dword [byte edx+eax-014h]
        sub edx, dword [byte eax+04h]
        inc edx
        mov dword [dword esp+0220h], edx
        push byte 20h
        mov eax, dword [dword esp+0230h]
        shl eax, 2
        imul eax, edx
        add eax, byte 11h
        push eax
        push str_Menubuff6
        call AllocMemBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+027Ch]
        mov dword [dword esp+edx+0210h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [dword esp+edx+0210h]
        mov edx, dword [dword esp+022Ch]
        mov word [byte eax+04h], dx
        mov eax, dword [dword esp+027Ch]
        mov eax, dword [dword esp+eax+0210h]
        mov edx, dword [dword esp+0220h]
        mov word [byte eax+06h], dx
        mov eax, dword [dword esp+0278h]
        mov esi, dword [dword esp+eax+01D4h]
        push esi
        mov edi, dword [dword esp+eax+01D4h]
        push edi
        mov eax, dword [dword esp+0284h]
        mov edx, dword [dword esp+eax+0218h]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [dword esp+026Ch]
        push ebx
        mov ecx, dword [dword esp+0274h]
        push ecx
        mov esi, dword [dword esp+0270h]
        push esi
        mov ecx, dword [dword esp+0284h]
        mov ecx, dword [dword esp+ecx+01E0h]
        mov ebx, dword [dword esp+0284h]
        mov ebx, dword [dword esp+ebx+01DCh]
        mov edx, dword [dword esp+0288h]
        mov edx, dword [dword esp+edx+0224h]
        mov eax, dword [dword esp+0288h]
        mov eax, dword [dword esp+eax+0214h]
        call DrawMenuDropdown
        mov eax, dword [dword esp+027Ch]
        xor edi, edi
        mov dword [dword esp+eax+01E0h], edi
        mov eax, dword [dword esp+026Ch]
        push eax
        mov edx, dword [dword esp+0274h]
        push edx
        mov ebx, dword [dword esp+0280h]
        mov ebx, dword [dword esp+ebx+01DCh]
        mov edx, dword [dword esp+0280h]
        mov edx, dword [dword esp+edx+01D8h]
        mov eax, dword [dword esp+0284h]
        mov eax, dword [dword esp+eax+0210h]
        mov ecx, esi
        jmp near .49
.48:
        mov edi, dword [dword esp+0238h]
        push edi
        push edx
        mov eax, dword [dword esp+0288h]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+026Ch]
        push edx
        mov ebx, dword [dword esp+0274h]
        push ebx
        mov eax, dword [dword esp+0230h]
        mov ebx, dword [dword esp+eax*8+01DCh]
        mov edx, dword [dword esp+eax*8+01D8h]
        mov ecx, dword [dword esp+eax*4+01E8h]
        shl ecx, 5
        mov eax, dword [dword esp+eax*4+0210h]
        add eax, ecx
        mov ecx, dword [dword esp+0270h]
        call DrawMenuItemSel
        mov edx, dword [dword esp+0228h]
        mov eax, dword [dword esp+0224h]
        mov dword [dword esp+edx*4+01E0h], eax
        mov ecx, dword [dword esp+026Ch]
        push ecx
        mov esi, dword [dword esp+0274h]
        push esi
        mov ebx, dword [dword esp+edx*8+01DCh]
        mov eax, dword [dword esp+edx*8+01D8h]
        mov esi, dword [dword esp+edx*4+01E8h]
        shl esi, 5
        mov edx, dword [dword esp+edx*4+0210h]
        add esi, edx
        mov ecx, dword [dword esp+0270h]
        mov edx, eax
        mov eax, esi
.49:
        call DrawMenuItemNorm
        jmp near .75
.50:
        mov ebx, dword [dword esp+0238h]
        push ebx
        push edx
        mov ecx, dword [dword esp+0288h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        cmp dword [dword esp+0284h], byte 0
        je near .54
        mov dword [dword esp+028Ch], 1
        jmp short .53
.51:
        mov edi, ecx
        shl edi, 2
        cmp dword [dword esp+edi+0210h], byte 0
        je short .52
        mov esi, ecx
        mov eax, dword [dword esp+ecx*8+01D4h]
        push eax
        mov edx, dword [dword esp+ecx*8+01D4h]
        push edx
        mov ebx, dword [dword esp+edi+0218h]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [dword esp+esi*8+01D0h], ecx
        mov dword [dword esp+esi*8+01D4h], ecx
        mov edx, dword [dword esp+edi+0210h]
        push edx
        call FreeMemBlock
        add esp, byte 4
.52:
        dec dword [dword esp+028Ch]
.53:
        mov ecx, dword [dword esp+028Ch]
        test ecx, ecx
        jge short LeagueTeamSelect.51
        xor esi, esi
        mov dword [dword esp+0284h], esi
        mov dword [dword esp+020Ch], esi
        mov dword [dword esp+0210h], esi
        mov dword [dword esp+0214h], esi
        mov dword [dword esp+01E4h], esi
        mov dword [dword esp+021Ch], esi
        jmp near .75
.54:
        lea ebx, [dword esp+01B4h]
        mov edx, dword [dword esp+0230h]
        mov eax, dword [dword esp+0234h]
        call TeamGridHitTest
        mov dword [dword esp+0240h], eax
        cmp dword [dword esp+02A0h], byte 10h
        jne short .55
        cmp dword [dword esp+0288h], byte 1
        jne short .55
        mov edx, dword [dword esp+02A8h]
        cmp eax, dword [edx]
        jne short .55
        mov dword [dword esp+0240h], 0FFFFFFFFh
.55:
        cmp dword [dword esp+0240h], byte 0
        jl near .75
        mov ecx, dword [dword esp+0288h]
        shl ecx, 2
        mov edi, dword [dword esp+02A8h]
        add ecx, edi
        mov esi, dword [ecx]
        mov eax, dword [dword esp+0240h]
        mov dword [ecx], eax
        cmp esi, eax
        jne near .73
        test byte [dword esp+02A0h], 18h
        je near .57
        shl eax, 4
        sub eax, esi
        cmp byte [byte ebp+eax*2+017h], 1
        jne short .57
        mov eax, esi
        xor ebx, ebx
        lea edx, [dword esp+01B4h]
        call HighlightGridCell
        mov eax, dword [ecx]
        mov ebx, 0FFFFFFFFh
        lea edx, [dword esp+01B4h]
        call HighlightGridCell
        cmp dword [dword esp+0288h], byte 0
        jne short .56
        test byte [dword esp+02A0h], 10h
        je short .56
        mov esi, dword [dword esp+0288h]
        inc esi
        mov dword [dword esp+0288h], esi
        mov eax, esi
        shl eax, 2
        add eax, edi
        mov dword [eax], 0FFFFFFFFh
        jmp near .75
.56:
        mov dword [dword esp+0260h], 0FFFFFFFFh
        jmp near .75
.57:
        test byte [dword esp+02A0h], 4
        je near .59
        cmp dword [dword esp+0264h], byte 1
        jle near .59
        mov esi, dword [dword esp+0288h]
        shl esi, 2
        add esi, dword [dword esp+02A8h]
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, ebp
        cmp byte [byte eax+019h], 0
        jne near .59
        cmp byte [byte eax+017h], 1
        jne near .59
        mov eax, dword [dword esp+0238h]
        push eax
        mov eax, dword [esi]
        mov ecx, dword [dword esp+0240h]
        mov ebx, dword [dword esp+0284h]
        lea edx, [dword esp+01B8h]
        call SaveGridCellBg
        mov eax, dword [esi]
        xor ebx, ebx
        lea edx, [dword esp+01B4h]
        call HighlightGridCell
        mov eax, dword [esi]
        mov ebx, 0FFFFFFFFh
        lea edx, [dword esp+01B4h]
        call HighlightGridCell
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        mov dword [removeteammsg+4], edx
        push byte 0FFFFFFFFh
        lea eax, [dword esp+023Ch]
        push eax
        lea eax, [dword esp+0244h]
        push eax
        push byte 2
        push removeteambtns
        mov ecx, 2
        mov ebx, removeteammsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        test eax, eax
        jne near .58
        mov eax, dword [esi]
        mov edx, ebp
        call AskTeamPassword
        test eax, eax
        jne short .58
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        mov byte [byte ebp+eax*2+017h], 0
        dec dword [dword esp+0264h]
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, ebp
        mov ebx, 0Bh
        xor edx, edx
        call memset_
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, ebp
        add eax, byte 0Bh
        mov ebx, 0Bh
        xor edx, edx
        call memset_
        mov eax, dword [esi]
        lea edx, [dword esp+01B4h]
        call RestoreGridCellBg
        mov eax, dword [esi]
        lea ecx, [dword esp+01B4h]
        mov ebx, dword [dword esp+025Ch]
        mov edx, ebp
        call DrawTeamGridName
        jmp near .75
.58:
        mov eax, dword [esi]
        lea edx, [dword esp+01B4h]
        call RestoreGridCellBg
        jmp near .75
.59:
        test byte [dword esp+02A0h], 3
        je near .75
        mov eax, dword [dword esp+0288h]
        shl eax, 2
        mov edx, dword [dword esp+02A8h]
        add edx, eax
        mov dword [dword esp+0274h], edx
        mov edx, dword [edx]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [byte ebp+eax*2+017h], 0
        jne near .75
        mov esi, dword [dword esp+0238h]
        push esi
        mov eax, dword [dword esp+0278h]
        mov eax, dword [eax]
        mov ecx, dword [dword esp+0240h]
        mov ebx, dword [dword esp+0284h]
        lea edx, [dword esp+01B8h]
        call SaveGridCellBg
        mov eax, dword [dword esp+0274h]
        mov eax, dword [eax]
        xor ebx, ebx
        lea edx, [dword esp+01B4h]
        call HighlightGridCell
        mov eax, dword [dword esp+0274h]
        mov eax, dword [eax]
        mov ebx, 0FFFFFFFFh
        lea edx, [dword esp+01B4h]
        call HighlightGridCell
        mov edx, dword [dword esp+0274h]
        mov edx, dword [edx]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, ebp
        mov ebx, 0Bh
        xor edx, edx
        call memset_
        mov edx, dword [dword esp+0274h]
        mov edx, dword [edx]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, ebp
        add eax, byte 0Bh
        mov ebx, 0Bh
        xor edx, edx
        call memset_
        lea edi, [dword esp+0100h]
        mov esi, str_WhoWillPlayThe
        movsd
        movsd
        movsd
        movsd
        movsw
        movsb
        mov eax, dword [dword esp+0274h]
        mov edi, dword [eax]
        cmp edi, byte 18h
        je short .60
        mov eax, edi
        shl eax, 2
        add eax, edi
        shl eax, 2
        add eax, edi
        mov edx, dword [dword esp+0254h]
        add edx, eax
        jmp short .61
.60:
        mov edx, str_MightyDucksOfAnaheim3
.61:
        lea eax, [dword esp+0100h]
        call strcat_
        mov edx, str_qmark
        lea eax, [dword esp+0100h]
        call strcat_
        mov edi, dword [dword esp+02A8h]
.62:
        push byte 4
        push byte 1
        push byte 0
        push byte 0
        push byte 0
        mov ecx, 46h
        mov ebx, 0Ah
        lea edx, [dword esp+0210h]
        lea eax, [dword esp+0114h]
        call TextInputDialog
        mov ecx, eax
        cmp eax, byte 1Bh
        je near .65
        mov edx, dword [dword esp+0288h]
        shl edx, 2
        add edx, dword [dword esp+02A8h]
        mov edx, dword [edx]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, ebp
        lea edx, [dword esp+01FCh]
        call strcpy_
        xor ecx, ecx
        xor esi, esi
.63:
        mov ebx, dword [dword esp+0288h]
        shl ebx, 2
        add ebx, edi
        cmp esi, dword [ebx]
        je short .64
        mov eax, esi
        shl eax, 4
        sub eax, esi
        add eax, eax
        lea edx, [eax+ebp]
        cmp byte [byte edx+017h], 1
        jne short .64
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, ebp
        call stricmp_
        test eax, eax
        jne short .64
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0234h]
        push eax
        lea eax, [dword esp+023Ch]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, msg_NameTaken
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov ecx, 1
.64:
        inc esi
        cmp esi, byte 1Ah
        jl short LeagueTeamSelect.63
.65:
        test ecx, ecx
        je short .66
        cmp ecx, byte 1Bh
        jne near LeagueTeamSelect.62
.66:
        cmp ecx, byte 1Bh
        je near .70
.67:
        mov edx, str_EnterPasswordFor
        lea eax, [dword esp+0100h]
        call strcpy_
        mov esi, dword [dword esp+0288h]
        shl esi, 2
        add esi, dword [dword esp+02A8h]
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        lea eax, [dword esp+0100h]
        call strcat_
        push byte 6
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        mov ecx, 3Ch
        mov ebx, 0Ah
        lea edx, [dword esp+0210h]
        lea eax, [dword esp+0114h]
        call TextInputDialog
        mov ecx, eax
        cmp eax, byte 1Bh
        je short .68
        mov edx, str_VerifyPasswordFor
        lea eax, [dword esp+0100h]
        call strcpy_
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        lea eax, [dword esp+0100h]
        call strcat_
        push byte 6
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        mov ecx, 3Ch
        mov ebx, 0Ah
        lea edx, [dword esp+0204h]
        lea eax, [dword esp+0114h]
        call TextInputDialog
        mov ecx, eax
.68:
        cmp ecx, byte 1Bh
        je short .69
        xor ecx, ecx
        lea edx, [dword esp+01F0h]
        lea eax, [dword esp+01FCh]
        call strcmp_
        test eax, eax
        je short .69
        push byte 0FFFFFFFFh
        lea eax, [dword esp+023Ch]
        push eax
        lea eax, [dword esp+0244h]
        push eax
        push ecx
        push ecx
        mov ecx, 2
        mov ebx, pwmismatchmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov ecx, 0FFFFFFFFh
.69:
        test ecx, ecx
        je short .70
        cmp ecx, byte 1Bh
        jne near LeagueTeamSelect.67
.70:
        mov ebx, dword [dword esp+0288h]
        shl ebx, 2
        add ebx, dword [dword esp+02A8h]
        cmp ecx, byte 1Bh
        je short .71
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        mov byte [byte ebp+eax*2+017h], 1
        inc dword [dword esp+0264h]
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, ebp
        add eax, byte 0Bh
        lea edx, [dword esp+01FCh]
        call strcpy_
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, ebp
        add eax, byte 0Bh
        call EncryptPassword
        mov eax, dword [ebx]
        lea edx, [dword esp+01B4h]
        call RestoreGridCellBg
        mov eax, dword [ebx]
        lea ecx, [dword esp+01B4h]
        mov ebx, dword [dword esp+025Ch]
        mov edx, ebp
        call DrawTeamGridName
        jmp short .72
.71:
        mov eax, dword [ebx]
        lea edx, [dword esp+01B4h]
        call RestoreGridCellBg
.72:
        call ClearInputQueue
        jmp short .75
.73:
        test esi, esi
        jl short .74
        mov ebx, 0FFFFFFFFh
        lea edx, [dword esp+01B4h]
        mov eax, esi
        call HighlightGridCell
.74:
        mov eax, dword [dword esp+0288h]
        shl eax, 2
        add eax, dword [dword esp+02A8h]
        mov eax, dword [eax]
        mov ebx, 0FFFFFFFFh
        lea edx, [dword esp+01B4h]
        call HighlightGridCell
.75:
        mov eax, dword [dword esp+0238h]
        push eax
        mov eax, dword [dword esp+0240h]
        sub eax, byte 4
        push eax
        mov edx, dword [dword esp+0288h]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [dword esp+0238h]
        push ebx
        mov eax, dword [dword esp+0240h]
        sub eax, byte 4
        push eax
        mov ecx, dword [dword esp+0288h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov esi, dword [dword esp+0230h]
        push esi
        mov eax, dword [dword esp+0238h]
        sub eax, byte 4
        push eax
        mov edi, dword [dword esp+0288h]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        cmp dword [dword esp+0260h], byte 0
        jne short .77
.76:
        mov edx, dword [dword esp+0230h]
        push edx
        mov eax, dword [dword esp+0238h]
        sub eax, byte 4
        push eax
        mov ebx, dword [pointerspr]
        push ebx
        call DrawArt
        add esp, byte 0Ch
.77:
        mov eax, dword [dword esp+0234h]
        mov dword [dword esp+023Ch], eax
        mov eax, dword [dword esp+0230h]
        mov dword [dword esp+0238h], eax
.78:
        cmp dword [dword esp+0260h], byte 0
        je near LeagueTeamSelect.23
        mov eax, dword [dword esp+0264h]
        mov edx, dword [dword esp+0250h]
        mov dword [edx], eax
        mov esi, dword [dword esp+0280h]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [dword esp+0288h]
        shl eax, 2
        add eax, dword [dword esp+02A8h]
        cmp dword [eax], byte 0
        jl short .80
        mov ah, byte [dword esp+02A0h]
        test ah, 8
        jne short .80
        test ah, 1
        je short .79
        mov edx, dword [dword esp+0250h]
        mov edx, dword [edx]
        lea ecx, [dword esp+0238h]
        lea ebx, [dword esp+023Ch]
        mov eax, ebp
        call ChooseLeagueController
.79:
        mov ecx, dword [dword esp+0250h]
        mov ecx, dword [ecx]
        mov ebx, dword [dword esp+02A0h]
        mov edx, dword [dword esp+0258h]
        mov eax, ebp
        call AskExportToFloppy
        mov ebx, 30Ch
        mov edx, ebp
        mov eax, dword [dword esp+0258h]
        call memcpy_
.80:
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [dword esp+024Ch]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        jmp short .84
.81:
        test ecx, ecx
        jne short .84
        mov dword [dword esp+028Ch], ecx
        mov ebx, 1Ah
.82:
        mov edx, dword [dword esp+028Ch]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, dword [dword esp+0258h]
        cmp byte [byte eax+017h], 1
        jne short .83
        mov eax, dword [dword esp+02A8h]
        mov edx, dword [dword esp+028Ch]
        mov dword [eax], edx
        mov dword [dword esp+028Ch], ebx
.83:
        mov ecx, dword [dword esp+028Ch]
        inc ecx
        mov dword [dword esp+028Ch], ecx
        cmp ecx, byte 1Ah
        jl short LeagueTeamSelect.82
.84:
        lea eax, [dword esp+0154h]
        push eax
        call TextRestoreState
        add esp, byte 4
        add esp, 290h
        pop ebp
        pop edi
        pop esi
        ret 0Ch
;-----------------------------------------------------------------------------
; WriteSeasonRec                               3A24F  95 PC, medium confidence
; FileWriteAt 2Fh: SEASON.DB skater record (pair of ReadSeasonRec)
;-----------------------------------------------------------------------------
; C: src/front/league_setup/WriteSeasonRec.c
%ifdef CBUILD
%include "c/front/league_setup/WriteSeasonRec.inc"
%else
WriteSeasonRec:
        push dword 8
        call __CHK
        push ecx
        mov ecx, 2Fh
WriteSeasonRec_common:
        call FileWriteAt
        pop ecx
        ret
;-----------------------------------------------------------------------------
; ReadGoalieSeasonRec                          3A266  95 PC, medium confidence
; FileReadAt 36h: SEASON.DB goalie record (KEY position 'G')
;-----------------------------------------------------------------------------
ReadGoalieSeasonRec:
        push dword 8
        call __CHK
        push ecx
        mov ecx, 36h
ReadGoalieSeasonRec_common:
        call FileReadAt
        pop ecx
        ret
;-----------------------------------------------------------------------------
; WriteGoalieSeasonRec                         3A27D  95 PC, medium confidence
; FileWriteAt 36h: SEASON.DB goalie record
;-----------------------------------------------------------------------------
WriteGoalieSeasonRec:
        push dword 8
        call __CHK
        push ecx
        mov ecx, 36h
        jmp short WriteSeasonRec_common
;-----------------------------------------------------------------------------
; WriteSchedGame                                                  3A28F  95 PC
; FileWriteAt counterpart of ReadSchedGame (2 + index*6, 6 bytes)
;-----------------------------------------------------------------------------
WriteSchedGame:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        mov esi, eax
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        lea ebx, [byte eax+02h]
        mov ecx, 6
WriteSchedGame_common:
        mov eax, esi
        call FileWriteAt
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; WriteTeamRec                                                    3A2B8  95 PC
; FileWriteAt counterpart of ReadTeamRec (index*2E8h, 2E8h bytes)
;-----------------------------------------------------------------------------
WriteTeamRec:
        push dword 10h
        call __CHK
        push ecx
        push esi
        push edi
        mov edi, eax
        mov esi, edx
        mov edx, ebx
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 3
        mov ebx, eax
        shl ebx, 5
        sub ebx, eax
        mov ecx, 2E8h
        mov edx, esi
        mov eax, edi
        call FileWriteAt
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; ReadDbRec4Ch                                 3A2EE  95 PC, medium confidence
; FileReadAt of a 4Ch-byte record at index * 4Ch (options_settings)
;-----------------------------------------------------------------------------
ReadDbRec4Ch:
        push dword 10h
        call __CHK
        push ecx
        push esi
        push edi
        mov edi, eax
        mov esi, edx
        mov edx, ebx
        shl ebx, 2
        add ebx, edx
        shl ebx, 2
        sub ebx, edx
        shl ebx, 2
        mov ecx, 4Ch
        mov edx, esi
        call FileReadAt
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; ReadLeagueTeamEntry                                             3A31E  95 PC
; FileReadAt 1Eh at 20h + team * 1Eh: PINFO league team entry (pair of
; WriteLeagueTeamEntry)
;-----------------------------------------------------------------------------
ReadLeagueTeamEntry:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        mov esi, eax
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        lea ebx, [byte eax+020h]
        mov ecx, 1Eh
        mov eax, esi
        call FileReadAt
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; WriteLeagueTeamEntry                                            3A347  95 PC
; FileWriteAt of one PINFO.DB team entry (20h + index*1Eh, 1Eh bytes)
;-----------------------------------------------------------------------------
WriteLeagueTeamEntry:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        mov esi, eax
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        lea ebx, [byte eax+020h]
        mov ecx, 1Eh
        jmp near WriteSchedGame_common
;-----------------------------------------------------------------------------
; ReadDbRec28h                                 3A36B  95 PC, medium confidence
; FileReadAt of a 28h-byte record (shared tail ReadGoalieSeasonRec_common);
; unused
;-----------------------------------------------------------------------------
ReadDbRec28h:
        push dword 8
        call __CHK
        push ecx
        mov ecx, 28h
        jmp near ReadGoalieSeasonRec_common
;-----------------------------------------------------------------------------
; ReadDbRec2Ch                                 3A380  95 PC, medium confidence
; FileReadAt of a 2Ch-byte record (shared tail ReadGoalieSeasonRec_common);
; unused
;-----------------------------------------------------------------------------
ReadDbRec2Ch:
        push dword 8
        call __CHK
        push ecx
        mov ecx, 2Ch
        jmp near ReadGoalieSeasonRec_common
%endif ; C
;-----------------------------------------------------------------------------
; AskTeamPassword                              3A395  95 PC, medium confidence
; 'Enter password for <team>' input and check (EncryptPassword), 'Incorrect
; password!' on mismatch; TradePlayers asks it for both teams
;-----------------------------------------------------------------------------
; C: src/front/league_setup/AskTeamPassword.c
%ifdef CBUILD
%include "c/front/league_setup/AskTeamPassword.inc"
%else
AskTeamPassword:
        push dword 0A0h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 74h
        mov esi, eax
        mov dword [byte esp+06Ch], edx
        xor ebp, ebp
.1:
        xor edx, edx
        mov dword [byte esp+070h], edx
        mov edx, str_EnterPasswordFor
        mov eax, esp
        call strcpy_
        mov eax, esi
        shl eax, 4
        sub eax, esi
        add eax, eax
        mov edi, dword [byte esp+06Ch]
        add edi, eax
        mov edx, edi
        mov eax, esp
        call strcat_
        push byte 6
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        mov ecx, 3Ch
        mov ebx, 0Ah
        lea edx, [byte esp+068h]
        lea eax, [byte esp+014h]
        call TextInputDialog
        cmp eax, byte 1Bh
        jne short .2
        mov eax, 0FFFFFFFFh
        jmp near .5
.2:
        lea ebx, [byte edi+0Bh]
        mov edx, esi
        mov eax, ebx
        call EncryptPassword
        lea edx, [byte esp+054h]
        mov eax, ebx
        call strcmp_
        test eax, eax
        je short .3
        lea eax, [byte esp+060h]
        push eax
        lea eax, [byte esp+068h]
        push eax
        lea eax, [byte esp+070h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+064h]
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, msg_WrongPassword
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [byte esp+070h], 0FFFFFFFFh
.3:
        mov edx, esi
        mov eax, esi
        shl eax, 4
        sub eax, esi
        add eax, eax
        add eax, dword [byte esp+06Ch]
        add eax, byte 0Bh
        call EncryptPassword
        inc ebp
        cmp dword [byte esp+070h], byte 0
        je short .4
        cmp ebp, byte 3
        jl near AskTeamPassword.1
.4:
        mov eax, dword [byte esp+070h]
.5:
        add esp, byte 74h
AskTeamPassword_ret:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; AskMasterPassword                                               3A49E  95 PC
; Up to 3 tries: '<team> enter master password.' input, compare with the
; master password, 'Incorrect password!'; -1 on Esc
;-----------------------------------------------------------------------------
; C: src/front/league_setup/AskTeamPassword.c (AskMasterPassword)
%ifdef CBUILD
%include "c/front/league_setup/AskTeamPassword.AskMasterPassword.inc"
%else
AskMasterPassword:
        push dword 9Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 74h
        mov esi, eax
        mov dword [byte esp+06Ch], edx
        mov edi, ebx
        xor ebp, ebp
.1:
        xor edx, edx
        mov dword [byte esp+070h], edx
        mov eax, esi
        shl eax, 4
        sub eax, esi
        add eax, eax
        mov edx, dword [byte esp+06Ch]
        add edx, eax
        mov eax, esp
        call strcpy_
        mov edx, str_EnterMasterPassword
        mov eax, esp
        call strcat_
        push byte 6
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        mov ecx, 3Ch
        mov ebx, 0Ah
        lea edx, [byte esp+068h]
        lea eax, [byte esp+014h]
        call TextInputDialog
        cmp eax, byte 1Bh
        jne short .2
        mov eax, 0FFFFFFFFh
        jmp near .x
.2:
        mov edx, esi
        mov eax, edi
        call EncryptPassword
        lea edx, [byte esp+054h]
        mov eax, masterpw
        call strcmp_
        test eax, eax
        je short .3
        lea eax, [byte esp+060h]
        push eax
        lea eax, [byte esp+068h]
        push eax
        lea eax, [byte esp+070h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+064h]
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, msg_WrongPassword
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [byte esp+070h], 0FFFFFFFFh
.3:
        mov edx, esi
        mov eax, edi
        call EncryptPassword
        inc ebp
        cmp dword [byte esp+070h], byte 0
        je short .4
        cmp ebp, byte 3
        jl near AskMasterPassword.1
.4:
        mov eax, dword [byte esp+070h]
.x:
        add esp, byte 74h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; EncryptPassword                                                 3A597  95 PC
; XORs the password with the key "NHLHockey" forwards and backwards
; (symmetric)
;-----------------------------------------------------------------------------
; C: src/front/league_setup/AskTeamPassword.c (EncryptPassword)
%ifdef CBUILD
%include "c/front/league_setup/AskTeamPassword.EncryptPassword.inc"
%else
EncryptPassword:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        push eax
        mov eax, passkey
        call strlen_
        mov ebx, eax
        mov edi, eax
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        xor ebx, ebx
        xor esi, esi
        mov eax, dword [esp]
.1:
        mov cl, byte [dword edx+passkey]
        mov ch, byte [esi+eax]
        xor ch, cl
        mov byte [esi+eax], ch
        mov ebp, edi
        sub ebp, ebx
        mov cl, byte [dword ebp+passkey_m1]
        xor ch, cl
        mov byte [esi+eax], ch
        inc edx
        inc ebx
        cmp edx, edi
        jl short .2
        xor edx, edx
.2:
        cmp ebx, edi
        jl short .3
        xor ebx, ebx
.3:
        inc esi
        cmp esi, byte 0Ah
        jl short EncryptPassword.1
        add esp, byte 4
        jmp near AskTeamPassword_ret
%endif ; C
;-----------------------------------------------------------------------------
; MergeTeamRecDelta                                               3A5FC  95 PC
; (old, new, dst, ...): dst team record stats (+28h..+4Bh) += new - old;
; copies the 30h bytes at +0BCh when the team matches
;-----------------------------------------------------------------------------
; C: src/front/league_setup/MergeTeamRecDelta.c
%ifdef CBUILD
%include "c/front/league_setup/MergeTeamRecDelta.inc"
%else
MergeTeamRecDelta:
        push dword 0Ch
        call __CHK
        push esi
        push edi
        mov esi, ecx
        mov cl, byte [byte edx+028h]
        sub cl, byte [byte eax+028h]
        add byte [byte ebx+028h], cl
        mov cl, byte [byte edx+029h]
        sub cl, byte [byte eax+029h]
        add byte [byte ebx+029h], cl
        mov cl, byte [byte edx+02Ah]
        sub cl, byte [byte eax+02Ah]
        add byte [byte ebx+02Ah], cl
        mov cl, byte [byte edx+02Bh]
        sub cl, byte [byte eax+02Bh]
        add byte [byte ebx+02Bh], cl
        mov cx, word [byte edx+02Ch]
        sub cx, word [byte eax+02Ch]
        add word [byte ebx+02Ch], cx
        mov cx, word [byte edx+02Eh]
        sub cx, word [byte eax+02Eh]
        add word [byte ebx+02Eh], cx
        mov cx, word [byte edx+030h]
        sub cx, word [byte eax+030h]
        add word [byte ebx+030h], cx
        mov cx, word [byte edx+032h]
        sub cx, word [byte eax+032h]
        add word [byte ebx+032h], cx
        mov cx, word [byte edx+034h]
        sub cx, word [byte eax+034h]
        add word [byte ebx+034h], cx
        mov cx, word [byte edx+036h]
        sub cx, word [byte eax+036h]
        add word [byte ebx+036h], cx
        mov cx, word [byte edx+038h]
        sub cx, word [byte eax+038h]
        add word [byte ebx+038h], cx
        mov cl, byte [byte edx+03Ah]
        sub cl, byte [byte eax+03Ah]
        add byte [byte ebx+03Ah], cl
        mov cl, byte [byte edx+03Bh]
        sub cl, byte [byte eax+03Bh]
        add byte [byte ebx+03Bh], cl
        mov cl, byte [byte edx+03Ch]
        sub cl, byte [byte eax+03Ch]
        add byte [byte ebx+03Ch], cl
        mov cl, byte [byte edx+03Dh]
        sub cl, byte [byte eax+03Dh]
        add byte [byte ebx+03Dh], cl
        mov cx, word [byte edx+03Eh]
        sub cx, word [byte eax+03Eh]
        add word [byte ebx+03Eh], cx
        mov cx, word [byte edx+040h]
        sub cx, word [byte eax+040h]
        add word [byte ebx+040h], cx
        mov cx, word [byte edx+042h]
        sub cx, word [byte eax+042h]
        add word [byte ebx+042h], cx
        mov cx, word [byte edx+044h]
        sub cx, word [byte eax+044h]
        add word [byte ebx+044h], cx
        mov cx, word [byte edx+046h]
        sub cx, word [byte eax+046h]
        add word [byte ebx+046h], cx
        mov cx, word [byte edx+048h]
        sub cx, word [byte eax+048h]
        add word [byte ebx+048h], cx
        mov cx, word [byte edx+04Ah]
        mov di, word [byte eax+04Ah]
        mov eax, ecx
        sub eax, edi
        add word [byte ebx+04Ah], ax
        cmp esi, dword [byte esp+0Ch]
        jne short .x
        mov ecx, 0Ch
        lea edi, [dword ebx+0BCh]
        lea esi, [dword edx+0BCh]
        rep movsd
.x:
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; MergeSeasonRecDelta                                             3A71C  95 PC
; Skater season record: dst += new - old
;-----------------------------------------------------------------------------
; C: src/front/league_setup/MergeSeasonRecDelta.c
%ifdef CBUILD
%include "c/front/league_setup/MergeSeasonRecDelta.inc"
%else
MergeSeasonRecDelta:
        push dword 0Ch
        call __CHK
        push esi
        push edi
        mov esi, ecx
        mov cx, word [edx]
        sub cx, word [eax]
        add word [ebx], cx
        mov cx, word [byte edx+02h]
        sub cx, word [byte eax+02h]
        add word [byte ebx+02h], cx
        mov cx, word [byte edx+04h]
        sub cx, word [byte eax+04h]
        add word [byte ebx+04h], cx
        mov cx, word [byte edx+06h]
        sub cx, word [byte eax+06h]
        add word [byte ebx+06h], cx
        mov cx, word [byte edx+08h]
        sub cx, word [byte eax+08h]
        add word [byte ebx+08h], cx
        mov cx, word [byte edx+0Ah]
        sub cx, word [byte eax+0Ah]
        add word [byte ebx+0Ah], cx
        mov cx, word [byte edx+0Ch]
        sub cx, word [byte eax+0Ch]
        add word [byte ebx+0Ch], cx
        mov cx, word [byte edx+0Eh]
        sub cx, word [byte eax+0Eh]
        add word [byte ebx+0Eh], cx
        mov cx, word [byte edx+010h]
        sub cx, word [byte eax+010h]
        add word [byte ebx+010h], cx
        mov cx, word [byte edx+012h]
        sub cx, word [byte eax+012h]
        add word [byte ebx+012h], cx
        mov cx, word [byte edx+014h]
        sub cx, word [byte eax+014h]
        add word [byte ebx+014h], cx
        mov cx, word [byte edx+016h]
        sub cx, word [byte eax+016h]
        add word [byte ebx+016h], cx
        mov cx, word [byte edx+018h]
        sub cx, word [byte eax+018h]
        add word [byte ebx+018h], cx
        mov cx, word [byte edx+01Ah]
        sub cx, word [byte eax+01Ah]
        add word [byte ebx+01Ah], cx
        mov cx, word [byte edx+01Ch]
        sub cx, word [byte eax+01Ch]
        add word [byte ebx+01Ch], cx
        mov cx, word [byte edx+01Eh]
        sub cx, word [byte eax+01Eh]
        add word [byte ebx+01Eh], cx
        mov cx, word [byte edx+020h]
        sub cx, word [byte eax+020h]
        add word [byte ebx+020h], cx
        mov cx, word [byte edx+022h]
        mov di, word [byte eax+022h]
        mov eax, ecx
        sub eax, edi
        add word [byte ebx+022h], ax
        cmp esi, dword [byte esp+0Ch]
        jne short .x
        mov al, byte [byte edx+024h]
        mov byte [byte ebx+024h], al
        mov al, byte [byte edx+025h]
        mov byte [byte ebx+025h], al
        mov al, byte [byte edx+026h]
        mov byte [byte ebx+026h], al
        mov al, byte [byte edx+027h]
        mov byte [byte ebx+027h], al
.x:
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; MergeGoalieRecDelta                                             3A826  95 PC
; Goalie season record: dst += new - old
;-----------------------------------------------------------------------------
; C: src/front/league_setup/MergeGoalieRecDelta.c
%ifdef CBUILD
%include "c/front/league_setup/MergeGoalieRecDelta.inc"
%else
MergeGoalieRecDelta:
        push dword 0Ch
        call __CHK
        push esi
        push edi
        mov esi, edx
        mov dx, word [edx]
        sub dx, word [eax]
        add word [ebx], dx
        mov dx, word [byte esi+02h]
        sub dx, word [byte eax+02h]
        add word [byte ebx+02h], dx
        mov dx, word [byte esi+04h]
        sub dx, word [byte eax+04h]
        add word [byte ebx+04h], dx
        mov dx, word [byte esi+06h]
        sub dx, word [byte eax+06h]
        add word [byte ebx+06h], dx
        mov dx, word [byte esi+08h]
        sub dx, word [byte eax+08h]
        add word [byte ebx+08h], dx
        mov dx, word [byte esi+0Ah]
        sub dx, word [byte eax+0Ah]
        add word [byte ebx+0Ah], dx
        mov dx, word [byte esi+0Ch]
        sub dx, word [byte eax+0Ch]
        add word [byte ebx+0Ch], dx
        mov dx, word [byte esi+0Eh]
        sub dx, word [byte eax+0Eh]
        add word [byte ebx+0Eh], dx
        mov dx, word [byte esi+012h]
        sub dx, word [byte eax+012h]
        add word [byte ebx+012h], dx
        mov dx, word [byte esi+014h]
        sub dx, word [byte eax+014h]
        add word [byte ebx+014h], dx
        mov dx, word [byte esi+016h]
        sub dx, word [byte eax+016h]
        add word [byte ebx+016h], dx
        mov dx, word [byte esi+018h]
        sub dx, word [byte eax+018h]
        add word [byte ebx+018h], dx
        mov dx, word [byte esi+01Ah]
        sub dx, word [byte eax+01Ah]
        add word [byte ebx+01Ah], dx
        mov dx, word [byte esi+01Ch]
        sub dx, word [byte eax+01Ch]
        add word [byte ebx+01Ch], dx
        mov dx, word [byte esi+01Eh]
        sub dx, word [byte eax+01Eh]
        add word [byte ebx+01Eh], dx
        mov dx, word [byte esi+020h]
        sub dx, word [byte eax+020h]
        add word [byte ebx+020h], dx
        mov dx, word [byte esi+022h]
        sub dx, word [byte eax+022h]
        add word [byte ebx+022h], dx
        mov dx, word [byte esi+024h]
        sub dx, word [byte eax+024h]
        add word [byte ebx+024h], dx
        mov dx, word [byte esi+028h]
        sub dx, word [byte eax+028h]
        add word [byte ebx+028h], dx
        mov dx, word [byte esi+02Ah]
        mov di, word [byte eax+02Ah]
        mov eax, edx
        sub eax, edi
        add word [byte ebx+02Ah], ax
        mov di, word [ebx]
        test di, di
        je short .1
        xor edx, edx
        mov dx, word [byte ebx+0Eh]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        shl edx, 2
        xor edi, edi
        mov di, word [ebx]
        mov eax, edx
        sar edx, 1Fh
        idiv edi
        mov word [byte ebx+010h], ax
        jmp short .2
.1:
        mov word [byte ebx+010h], di
.2:
        mov ax, word [byte ebx+016h]
        test ax, ax
        je short .3
        xor edx, edx
        mov dx, word [byte ebx+024h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        shl edx, 2
        xor edi, edi
        mov di, word [byte ebx+016h]
        mov eax, edx
        sar edx, 1Fh
        idiv edi
.3:
        mov word [byte ebx+026h], ax
        cmp ecx, dword [byte esp+0Ch]
        jne short .x
        mov al, byte [byte esi+02Ch]
        mov byte [byte ebx+02Ch], al
        mov al, byte [byte esi+02Dh]
        mov byte [byte ebx+02Dh], al
        mov al, byte [byte esi+02Eh]
        mov byte [byte ebx+02Eh], al
        mov al, byte [byte esi+02Fh]
        mov byte [byte ebx+02Fh], al
.x:
        pop edi
        pop esi
        ret 4
%endif ; C
