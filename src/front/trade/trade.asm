; The Trade Players screen, including the check that two players are not given the same jersey number,
; and making the trade (95G front/trade95).
bits 32
%include "hockey.inc"
section s_3DC2C progbits alloc exec nowrite align=1
extern __CHK, _fstrcspn_, AskMasterPassword, AskTeamPassword, awlinetab, btn_MasterDB, btn_TradeStats, btn_WrongDisk
extern byte_D11BC, byte_D12DE, jerseypalslot0, jerseypalslot1, jerseypalslot2, jerseypalslot3, TextCharH, awayremap
extern homeremap, lgschedrec, byte_DE268, cddriveptr, ClearInputQueue, ClearPlayerFromLines, CopyFile, curleague
extern curperiod, DeleteFiles, dlgbevelcol1, dlgbevelcol2, dlgedgecol1, dlgedgecol2, dlgedgecol3, dlgfillcol
extern DrawDlgFrame, DrawMenuBar, DrawMenuDropdown, DrawMenuItemNorm, DrawMenuItemSel, menuwidth_trade1, menutext_trade1, menuwidth_trade2
extern menutext_trade2, leaguestatsmode, dword_DDD34, dword_DDD3C, tradebitmap, ExportTeamToFloppy, FadePalStep, FileClose
extern FileCreate, fileoncd, FileOpenRead, FileOpenRW, FileOpenWrite, FileReadAt, FileWriteAt, fputchar
extern FreeMemBlock, GameLineEditor, GetInputEvent, hmlinetab, HomeTeam, humancount, InitMenuRemap, jerseymsg
extern jerseyremap, leaguedbfmt, leaguedbfmt2, leaguedbnames, leagueflags, leaguemaster, leaguesaved, leagueteams
extern LeagueTeamSelect, lggameidx, lgplayteam, LoadGameTeams, MakeJerseyShape, MakePath, masterpw, memcpy_
extern memset_, menuact_gamedress, menuact_gamescratch, MenuHitTest, MergeLeagueFiles, MessageBox, MouseSetPos, msg_AllHuman
extern msg_Copying, msg_Copying_arg, msg_InsertDisk, msg_InsertDisk_arg, msg_MasterDB, msg_MasterDB_arg, msg_OneHuman, msg_SavedGame
extern msg_SavedGame_arg, msg_TradeDeadline, msg_TradeError, msg_WrongDisk, msg_WrongDisk_arg, negone_3DC28, pointerspr, ptrupdatefn
extern qsort_, ReadKeyRec, ReadLeagueInfo, ReadSchedGame, ReadTeamNames, ReadTeamRec, RestoreDialogBg, RunMenu
extern savedname, savleague1, savleague2, SelectFloppyDrive, SetDialogColors, SetDrawBitmap, sprintf_, statsbgshapes
extern statscategory, statsgoaliebuf, statspalshape, statsplayerbuf, statsredrawcb, statsskaterbuf, statsteambuf, str_backslash2
extern str_bangpal, str_Bkgd9, str_C2dS, str_Donepal, str_dot, str_easndesk, str_Embnhl2, str_Embpal3
extern str_EnterJerseyNumberFor, str_extBIN, str_extDB, str_extID, str_extLP, str_extnum, str_extxx, str_floppydrv
extern str_FromLeague, str_Gstat2, str_HOMEPALS, str_HOMEPALS2, str_Keys2, str_Lineditp, str_LLSN, str_LLST
extern str_Menubuff7, str_Pal21, str_Pal22, str_PINFO, str_PLAYER, str_Pntr2, str_Pointer10, str_Pstat2
extern str_S12, str_S4, str_saved, str_SelNewHuman, str_SelRemoveHuman, str_SelTradeTeams, str_Show, str_Shrt
extern str_space, str_star, str_Statistics, str_Temp6, str_TheJerseyNumber2d2, str_Tstat, str_VFN, strcat_
extern strcmp_, strcpy_, strcspn_, stricmp_, strncpy_, AllocMemBlock, LoadBank, OpenArtArchiveErr
extern TextSetColors, TextSaveState, TextRestoreState, TextSetFont, SetPalette, PutBlock, DrawArtOpaqueAtOwnPos, DrawArt
extern GrabBlock, DrawArtKeyColour, PrintBoxedText, DrawArtMasked, MouseRead, FindShape, ClearScreen, VgaSetPalette
extern SetScreenTarget, SetColorRemap, CreateBitmap, teamcitynames, TeamRosterScreen, TextInputDialog, tradebtnx, tradebtny
extern tradeclick, tradecursor, tradejersey, traderemap1, traderemap2, traderesult, traderoster, tradeside
extern tradeslot, treeteamnames, unequaltrademsg, tradestatsmenubar, tradelinesmenubar, unk_D12C8, _dos_findfirst_, _dos_findnext_
extern VisTeam, word_DDD48, word_DDD4A, WriteKeyRec, WriteLeagueTeamEntry, WriteTeamRec
global BuildTradeRoster, TradeShowStats, FixJerseyConflict, ExecuteTrade, DrawTradeRow, LoadTradeTeamPals, DrawTradeScreen, TradeHitTest
global TradeHitTest_ret, TradeDone, TradeCancel, FindTradeSlot, TradeScreenLoop, TradeRosterCmp, TradeScreen, TradePlayers
global LoadHomePals
;-----------------------------------------------------------------------------
; BuildTradeRoster                               3DC2C  95 PC, none confidence
; Fill list (28 entries of 22 bytes) from the team database named in dir.
; Entry i gets index i at +2. The 25 skater slots (team record +4Ch) and the
; 3 goalie slots (+B0h) become entries 0-24 and 25-27. An empty slot (-1)
; stores a zero position byte; otherwise the key record supplies position
; (+2), number (+1) and "<initial>. <last name>" (+3 and +13h). Returns 0 or
; the first file error. Both file handles are closed. The counter i is a
; plain local that Watcom keeps on the stack (the frame struct holds only the
; key record, the path and the two handles).
;-----------------------------------------------------------------------------
; C: src/front/trade/BuildTradeRoster.c
%ifdef CBUILD
%include "c/front/trade/BuildTradeRoster.inc"
%else
BuildTradeRoster:
        push dword 74h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 64h
        mov ebp, eax
        mov dword [byte esp+060h], edx
        mov esi, ebx
        mov edi, ecx
        mov edx, 0FFFFFFFFh
        mov dword [byte esp+058h], edx
        mov dword [byte esp+054h], edx
        xor ecx, ecx
        mov dword [byte esp+05Ch], ecx
.1:
        mov eax, dword [byte esp+05Ch]
        mov ecx, eax
        shl ecx, 2
        sub ecx, eax
        shl ecx, 2
        sub ecx, eax
        mov dl, byte [byte esp+05Ch]
        mov byte [byte esi+ecx*2+02h], dl
        inc eax
        mov dword [byte esp+05Ch], eax
        cmp eax, byte 1Ch
        jl short BuildTradeRoster.1
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, ebp
        lea eax, [byte esp+034h]
        call MakePath
        lea edx, [byte esp+058h]
        lea eax, [byte esp+034h]
        call FileOpenRead
        mov ebx, eax
        test eax, eax
        jne short .2
        mov ebx, dword [byte esp+060h]
        mov edx, edi
        mov eax, dword [byte esp+058h]
        call ReadTeamRec
        mov ebx, eax
.2:
        lea eax, [byte esp+058h]
        call FileClose
        test ebx, ebx
        jne short .3
        mov ebx, dword [leaguedbnames]
        mov ecx, str_extDB
        mov edx, ebp
        lea eax, [byte esp+034h]
        call MakePath
        lea edx, [byte esp+054h]
        lea eax, [byte esp+034h]
        call FileOpenRead
        mov ebx, eax
.3:
        test ebx, ebx
        jne near .13
        mov dword [byte esp+05Ch], ebx
        jmp short .7
.4:
        mov eax, ebp
        mov eax, dword [byte edi+eax*4+04Ch]
        mov ecx, ebp
        shl ecx, 2
        sub ecx, ebp
        shl ecx, 2
        sub ecx, ebp
        add ecx, ecx
        add ecx, esi
        cmp eax, byte 0FFFFFFFFh
        jne short .5
        mov byte [ecx], 0
        jmp short .6
.5:
        mov ebx, eax
        mov edx, esp
        mov eax, dword [byte esp+054h]
        call ReadKeyRec
        mov ebx, eax
        test eax, eax
        jne short .6
        mov al, byte [byte esp+02h]
        mov byte [ecx], al
        mov al, byte [byte esp+01h]
        mov byte [byte ecx+01h], al
        mov al, byte [byte esp+03h]
        mov byte [byte ecx+03h], al
        mov al, byte [str_dot]
        mov byte [byte ecx+04h], al
        mov al, byte [str_space]
        mov byte [byte ecx+05h], al
        mov byte [byte ecx+06h], 0
        lea eax, [byte ecx+03h]
        lea edx, [byte esp+013h]
        call strcat_
.6:
        inc dword [byte esp+05Ch]
.7:
        mov ebp, dword [byte esp+05Ch]
        cmp ebp, byte 19h
        jge short .8
        test ebx, ebx
        je short BuildTradeRoster.4
.8:
        xor eax, eax
        mov dword [byte esp+05Ch], eax
        jmp short .12
.9:
        mov eax, ecx
        mov eax, dword [dword edi+eax*4+0B0h]
        lea edx, [byte ecx+019h]
        mov ecx, edx
        shl ecx, 2
        sub ecx, edx
        shl ecx, 2
        sub ecx, edx
        add ecx, ecx
        add ecx, esi
        cmp eax, byte 0FFFFFFFFh
        jne short .10
        mov byte [ecx], 0
        jmp short .11
.10:
        mov ebx, eax
        mov edx, esp
        mov eax, dword [byte esp+054h]
        call ReadKeyRec
        mov ebx, eax
        test eax, eax
        jne short .11
        mov al, byte [byte esp+02h]
        mov byte [ecx], al
        mov al, byte [byte esp+01h]
        mov byte [byte ecx+01h], al
        mov al, byte [byte esp+03h]
        mov byte [byte ecx+03h], al
        mov al, byte [str_dot]
        mov byte [byte ecx+04h], al
        mov al, byte [str_space]
        mov byte [byte ecx+05h], al
        mov byte [byte ecx+06h], 0
        lea eax, [byte ecx+03h]
        lea edx, [byte esp+013h]
        call strcat_
.11:
        inc dword [byte esp+05Ch]
.12:
        mov ecx, dword [byte esp+05Ch]
        cmp ecx, byte 3
        jge short .13
        test ebx, ebx
        je short BuildTradeRoster.9
.13:
        lea eax, [byte esp+054h]
        call FileClose
        mov eax, ebx
        add esp, byte 64h
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TradeShowStats                                 3DE05  95 PC, none confidence
; Fade out, load the roster stat screens for cat, show the trade menu, then
; fade back and redraw the trade screen. list and the other arguments are the
; trade screen's own. The last stack argument is unused.
;-----------------------------------------------------------------------------
; C: src/front/trade/TradeShowStats.c
%ifdef CBUILD
%include "c/front/trade/TradeShowStats.inc"
%else
TradeShowStats:
        push dword 38h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 1Ch
        mov ebp, eax
        mov byte [byte esp+018h], dl
        mov dword [byte esp+010h], ebx
        mov dword [byte esp+014h], ecx
        call SetScreenTarget
        push byte 20h
        push dword 300h
        push str_Temp6
        call AllocMemBlock
        mov edi, eax
        add esp, byte 0Ch
        mov esi, eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, edi
        mov eax, 1
        call FadePalStep
        push byte 0
        call ClearScreen
        add esp, byte 4
        mov dword [leaguestatsmode], 1
        mov dword [statsredrawcb], TeamRosterScreen
        xor eax, eax
        mov al, byte [byte esp+018h]
        mov dword [statscategory], eax
        push byte 20h
        push dword 2A4h
        push str_Tstat
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsteambuf], eax
        push byte 20h
        push dword 5B0h
        push str_Keys2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsplayerbuf], eax
        push byte 20h
        push dword 497h
        push str_Pstat2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsskaterbuf], eax
        push byte 20h
        push dword 10Eh
        push str_Gstat2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsgoaliebuf], eax
        xor ecx, ecx
        mov ebx, str_Embpal3
        cmp byte [fileoncd+08Eh], 1
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
        mov edi, eax
        add esp, byte 8
        push str_Pal21
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, esi
        call memcpy_
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov eax, 1
        call InitMenuRemap
        xor eax, eax
        mov al, byte [byte esp+018h]
        call TeamRosterScreen
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 2
        mov eax, tradestatsmenubar
        call DrawMenuBar
        mov ebx, 10h
        mov edx, esi
        xor eax, eax
        call FadePalStep
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 2
        mov eax, tradestatsmenubar
        call RunMenu
        xor ecx, ecx
        mov dword [leaguestatsmode], ecx
        mov dword [statsredrawcb], ecx
        mov eax, dword [statsteambuf]
        push eax
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [statsgoaliebuf]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [statsskaterbuf]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        mov ecx, dword [statsplayerbuf]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        xor edi, edi
        mov dword [statsplayerbuf], edi
        mov dword [statsteambuf], edi
        mov dword [statsgoaliebuf], edi
        mov dword [statsskaterbuf], edi
        call SetScreenTarget
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push edi
        call ClearScreen
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov ecx, dword [byte esp+010h]
        push ecx
        mov esi, dword [byte esp+018h]
        push esi
        mov edi, dword [byte esp+040h]
        push edi
        mov ecx, dword [byte esp+03Ch]
        mov ebx, dword [byte esp+040h]
        mov edx, dword [byte esp+038h]
        mov eax, ebp
        call DrawTradeScreen
        add esp, byte 1Ch
        pop ebp
        pop edi
        pop esi
        ret 14h
%endif ; C
;-----------------------------------------------------------------------------
; FixJerseyConflict                              3E055  95 PC, none confidence
; After a trade: gives a traded player a free jersey number when his number
; is already taken on the new team.
;-----------------------------------------------------------------------------
FixJerseyConflict:
        push dword 670h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 644h
        push eax
        mov edi, edx
        mov dword [dword esp+0640h], ebx
        xor ecx, ecx
        mov dword [dword esp+0634h], ecx
        jmp short .2
.1:
        mov eax, ebx
        shl eax, 2
        add eax, dword [dword esp+0640h]
        mov ebx, dword [byte eax+04Ch]
        mov edx, dword [dword esp+0634h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        lea edx, [byte esp+04h]
        add edx, eax
        mov eax, dword [esp]
        call ReadKeyRec
        mov ecx, eax
        inc dword [dword esp+0634h]
.2:
        mov ebx, dword [dword esp+0634h]
        cmp ebx, byte 1Ch
        jge short .3
        test ecx, ecx
        je short FixJerseyConflict.1
.3:
        test ecx, ecx
        jne near .10
.4:
        xor esi, esi
        mov dword [dword esp+0634h], esi
        jmp short .7
.5:
        cmp edi, eax
        je short .6
        mov ebx, edi
        shl ebx, 2
        sub ebx, edi
        shl ebx, 2
        add ebx, edi
        shl ebx, 2
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        mov dl, byte [byte esp+ebx+05h]
        cmp dl, byte [byte esp+eax*4+05h]
        jne short .6
        mov esi, 0FFFFFFFFh
.6:
        inc dword [dword esp+0634h]
.7:
        mov eax, dword [dword esp+0634h]
        cmp eax, byte 1Ch
        jge short .8
        test esi, esi
        je short FixJerseyConflict.5
.8:
        test esi, esi
        je near .9
        push byte 20h
        push byte 0Ch
        push str_Donepal
        call AllocMemBlock
        mov dword [dword esp+0644h], eax
        add esp, byte 0Ch
        push eax
        push byte 4
        push dword 0FBh
        call SetPalette
        add esp, byte 0Ch
        mov byte [dword esp+0644h], 18h
        xor dl, dl
        mov byte [dword esp+0645h], dl
        mov byte [dword esp+0646h], dl
        lea eax, [dword esp+0644h]
        push eax
        push byte 1
        push dword 0FBh
        call VgaSetPalette
        add esp, byte 0Ch
        mov byte [dword esp+0644h], 2Ah
        xor bh, bh
        mov byte [dword esp+0645h], bh
        mov byte [dword esp+0646h], bh
        lea eax, [dword esp+0644h]
        push eax
        push byte 1
        push dword 0FCh
        call VgaSetPalette
        add esp, byte 0Ch
        mov byte [dword esp+0644h], 3Bh
        mov byte [dword esp+0645h], 12h
        xor ah, ah
        mov byte [dword esp+0646h], ah
        lea eax, [dword esp+0644h]
        push eax
        push byte 1
        push dword 0FDh
        call VgaSetPalette
        add esp, byte 0Ch
        mov dl, 3Bh
        mov byte [dword esp+0644h], dl
        mov byte [dword esp+0645h], dl
        mov byte [dword esp+0646h], dl
        lea eax, [dword esp+0644h]
        push eax
        push byte 1
        push dword 0FEh
        call VgaSetPalette
        add esp, byte 0Ch
        mov ebp, edi
        shl ebp, 2
        sub ebp, edi
        shl ebp, 2
        add ebp, edi
        shl ebp, 2
        lea eax, [byte esp+04h]
        add eax, ebp
        mov dword [dword esp+063Ch], eax
        lea edx, [byte eax+03h]
        lea eax, [dword esp+0608h]
        call strcpy_
        mov edx, str_space
        lea eax, [dword esp+0608h]
        call strcat_
        mov edx, dword [dword esp+063Ch]
        add edx, byte 13h
        lea eax, [dword esp+0608h]
        call strcat_
        mov eax, dword [dword esp+0640h]
        add eax, byte 1Ah
        push eax
        xor eax, eax
        mov al, byte [byte esp+ebp+09h]
        push eax
        push str_TheJerseyNumber2d2
        lea eax, [dword esp+05C0h]
        push eax
        call sprintf_
        add esp, byte 10h
        lea eax, [dword esp+05B4h]
        mov dword [jerseymsg], eax
        lea eax, [dword esp+062Ch]
        push eax
        lea eax, [dword esp+0634h]
        push eax
        lea eax, [dword esp+063Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0630h]
        push eax
        lea eax, [dword esp+0638h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, jerseymsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov ebx, dword [dword esp+0638h]
        push ebx
        push byte 4
        push dword 0FBh
        call VgaSetPalette
        add esp, byte 0Ch
        mov ecx, dword [dword esp+0638h]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        lea eax, [dword esp+0608h]
        push eax
        push str_EnterJerseyNumberFor
        lea eax, [dword esp+05BCh]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor bh, bh
        mov byte [dword esp+0628h], bh
        push byte 0
        push byte 0
        push byte 63h
        push byte 1
        push byte 0FFFFFFFFh
        mov ecx, 16h
        mov ebx, 2
        lea edx, [dword esp+063Ch]
        lea eax, [dword esp+05C8h]
        call TextInputDialog
        mov byte [byte esp+ebp+05h], al
        mov eax, edi
        shl eax, 2
        add eax, dword [dword esp+0640h]
        mov ebx, dword [byte eax+04Ch]
        mov edx, dword [dword esp+063Ch]
        mov eax, dword [esp]
        call WriteKeyRec
        mov ecx, eax
.9:
        test esi, esi
        je short .10
        test ecx, ecx
        je near FixJerseyConflict.4
.10:
        mov eax, ecx
        add esp, 648h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; ExecuteTrade                                   3E390  95 PC, none confidence
; Carries out a trade: swaps the two players between the team databases and
; fixes jersey numbers.
;-----------------------------------------------------------------------------
ExecuteTrade:
        push dword 68Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 66Ch
        mov ebp, eax
        mov edi, edx
        mov dword [dword esp+0664h], ebx
        mov edx, 0FFFFFFFFh
        mov dword [dword esp+065Ch], edx
        mov dword [dword esp+0658h], edx
        xor ecx, ecx
        mov dword [dword esp+0668h], ecx
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, eax
        lea eax, [dword esp+0638h]
        call MakePath
        lea edx, [dword esp+065Ch]
        lea eax, [dword esp+0638h]
        call FileOpenRW
        mov esi, eax
        test eax, eax
        jne short .1
        mov ebx, dword [edi]
        mov edx, esp
        mov eax, dword [dword esp+065Ch]
        call ReadTeamRec
        mov esi, eax
.1:
        test esi, esi
        jne short .2
        mov ebx, dword [byte edi+04h]
        lea edx, [dword esp+02E8h]
        mov eax, dword [dword esp+065Ch]
        call ReadTeamRec
        mov esi, eax
.2:
        test esi, esi
        jne short .3
        mov ebx, dword [leaguedbnames]
        mov ecx, str_extDB
        mov edx, ebp
        lea eax, [dword esp+0638h]
        call MakePath
        lea edx, [dword esp+0658h]
        lea eax, [dword esp+0638h]
        call FileOpenRW
        mov esi, eax
.3:
        test esi, esi
        jne near .12
        xor ecx, ecx
        jmp near .11
.4:
        mov eax, dword [dword esp+0664h]
        add eax, ecx
        mov dl, byte [eax]
        cmp dl, 0FFh
        je near .10
        cmp byte [byte eax+02h], 0FFh
        je near .10
        mov dword [dword esp+0668h], 0FFFFFFFFh
        cmp dl, 19h
        movzx ebp, dl
        mov ebp, dword [byte esp+ebp*4+04Ch]
        mov ebx, ebp
        lea edx, [dword esp+0604h]
        mov eax, dword [dword esp+0658h]
        call ReadKeyRec
        mov esi, eax
        test eax, eax
        jne short .5
        mov eax, dword [dword esp+0664h]
        add eax, ecx
        mov bh, byte [byte eax+02h]
        cmp bh, 19h
        mov al, bh
        and eax, 0FFh
        mov eax, dword [dword esp+eax*4+0334h]
        mov dword [dword esp+0660h], eax
        mov ebx, dword [dword esp+0660h]
        lea edx, [dword esp+05D0h]
        mov eax, dword [dword esp+0658h]
        call ReadKeyRec
        mov esi, eax
.5:
        test esi, esi
        jne near .10
        mov al, byte [byte edi+04h]
        mov byte [dword esp+0604h], al
        mov al, byte [edi]
        mov byte [dword esp+05D0h], al
        mov eax, dword [dword esp+0664h]
        add eax, ecx
        mov dl, byte [eax]
        cmp dl, 19h
        mov al, dl
        and eax, 0FFh
        mov edx, dword [dword esp+0660h]
        mov dword [byte esp+eax*4+04Ch], edx
        mov eax, dword [dword esp+0664h]
        add eax, ecx
        mov dh, byte [byte eax+02h]
        cmp dh, 19h
        mov al, dh
        and eax, 0FFh
        mov dword [dword esp+eax*4+0334h], ebp
        mov esi, dword [dword esp+0664h]
        xor eax, eax
        mov al, byte [ecx+esi]
        lea edx, [dword esp+0BCh]
        call ClearPlayerFromLines
        xor eax, eax
        mov al, byte [ecx+esi]
        lea edx, [dword esp+0ECh]
        call ClearPlayerFromLines
        xor eax, eax
        mov al, byte [byte ecx+esi+02h]
        lea edx, [dword esp+03A4h]
        call ClearPlayerFromLines
        xor eax, eax
        mov al, byte [byte ecx+esi+02h]
        lea edx, [dword esp+03D4h]
        call ClearPlayerFromLines
        mov ebx, ebp
        lea edx, [dword esp+0604h]
        mov eax, dword [dword esp+0658h]
        call WriteKeyRec
        mov esi, eax
        test eax, eax
        jne short .6
        mov ebx, dword [dword esp+0660h]
        lea edx, [dword esp+05D0h]
        mov eax, dword [dword esp+0658h]
        call WriteKeyRec
        mov esi, eax
.6:
        test esi, esi
        jne short .7
        mov ebx, dword [edi]
        mov edx, esp
        mov eax, dword [dword esp+065Ch]
        call WriteTeamRec
        mov esi, eax
.7:
        test esi, esi
        jne short .8
        mov ebx, dword [byte edi+04h]
        lea edx, [dword esp+02E8h]
        mov eax, dword [dword esp+065Ch]
        call WriteTeamRec
        mov esi, eax
.8:
        test esi, esi
        jne short .9
        mov eax, dword [dword esp+0664h]
        xor edx, edx
        mov dl, byte [ecx+eax]
        mov ebx, esp
        mov eax, dword [dword esp+0658h]
        call FixJerseyConflict
        mov esi, eax
.9:
        test esi, esi
        jne short .10
        mov eax, dword [dword esp+0664h]
        xor edx, edx
        mov dl, byte [byte ecx+eax+02h]
        lea ebx, [dword esp+02E8h]
        mov eax, dword [dword esp+0658h]
        call FixJerseyConflict
        mov esi, eax
.10:
        inc ecx
.11:
        cmp ecx, byte 2
        jge short .12
        test esi, esi
        je near ExecuteTrade.4
.12:
        lea eax, [dword esp+0658h]
        call FileClose
        lea eax, [dword esp+065Ch]
        call FileClose
        test esi, esi
        jne near .13
        cmp dword [dword esp+0668h], byte 0
        je near .13
        mov ax, word [edi]
        mov word [HomeTeam], ax
        mov ax, word [byte edi+04h]
        mov word [VisTeam], ax
        mov edx, curleague
        mov eax, leaguedbfmt
        call strcpy_
        mov edx, str_backslash2
        mov eax, leaguedbfmt
        call strcat_
        mov edx, str_S4
        mov eax, leaguedbfmt
        call strcat_
        mov edx, str_extDB
        mov eax, leaguedbfmt
        call strcat_
        mov edx, leaguedbfmt
        mov eax, leaguedbfmt2
        call strcpy_
        xor eax, eax
        call LoadGameTeams
        mov dword [curperiod], 0FFFFFFFEh
        mov ecx, 3
        mov ebx, tradelinesmenubar
        mov edx, hmlinetab
        xor eax, eax
        call GameLineEditor
        push byte 20h
        push dword 300h
        push str_Pal22
        call AllocMemBlock
        mov edi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push esi
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, edi
        mov eax, 1
        call FadePalStep
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ecx, 3
        mov ebx, tradelinesmenubar
        mov edx, awlinetab
        mov eax, 1
        call GameLineEditor
        push byte 20h
        push dword 300h
        push str_Pal22
        call AllocMemBlock
        mov edi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push esi
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, edi
        mov eax, 1
        call FadePalStep
        push edi
        call FreeMemBlock
        add esp, byte 4
.13:
        mov eax, esi
        add esp, 66Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; DrawTradeRow                                   3E7B3  95 PC, none confidence
; Print the cursor row of trade list side (16h-byte rows, 268h per side):
; position letter, jersey number and name at x side * 1C0h + 5, y row * line
; height + 1Dh.
;-----------------------------------------------------------------------------
; C: src/front/trade/DrawTradeRow.c
%ifdef CBUILD
%include "c/front/trade/DrawTradeRow.inc"
%else
DrawTradeRow:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, eax
        mov ecx, dword [nosplit eax*4+tradecursor]
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        sub eax, ecx
        add eax, eax
        imul ecx, edx, dword 268h
        mov esi, traderoster
        add esi, ecx
        add esi, eax
        add esi, byte 3
        push esi
        add eax, ecx
        xor ecx, ecx
        mov cl, byte [dword eax+tradejersey]
        push ecx
        mov al, byte [dword eax+traderoster]
        and eax, 0FFh
        push eax
        push str_C2dS
        xor eax, eax
        mov al, byte [TextCharH]
        imul eax, dword [nosplit edx*4+tradecursor]
        add eax, byte 1Dh
        push eax
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 6
        add eax, byte 5
        push eax
        call PrintBoxedText
        add esp, byte 18h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadTradeTeamPals                              3E835  95 PC, none confidence
; For the trade screen load HOMEPALS.BIN (1C0h bytes per team) twice: team
; t1's palette part to pal+180h and its remap table to homeremap, team t2's
; palette part to pal+240h and its remap table to awayremap (entries 90h and
; up shifted by 40h); then the four fixed colours at pal+171h and remap
; 7Bh-7Eh to themselves.
;-----------------------------------------------------------------------------
; C: src/front/trade/LoadTradeTeamPals.c
%ifdef CBUILD
%include "c/front/trade/LoadTradeTeamPals.inc"
%else
LoadTradeTeamPals:
        push dword 2Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov edi, eax
        mov ebp, edx
        mov esi, ebx
        mov ecx, str_extBIN
        mov ebx, str_HOMEPALS2
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
        mov edx, eax
        add esp, byte 8
        mov ecx, eax
        mov eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 6
        add edx, eax
        xor eax, eax
.3:
        mov bl, byte [edx+eax]
        mov byte [dword esi+eax+0180h], bl
        inc eax
        cmp eax, 0C0h
        jl short LoadTradeTeamPals.3
        xor eax, eax
        add edx, 0C0h
.4:
        mov bl, byte [edx+eax]
        mov byte [dword eax+homeremap], bl
        inc eax
        cmp eax, 100h
        jl short LoadTradeTeamPals.4
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov ecx, str_extBIN
        mov ebx, str_HOMEPALS2
        cmp byte [fileoncd+02Bh], 1
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
        call OpenArtArchiveErr
        mov edx, eax
        add esp, byte 8
        mov ecx, eax
        mov eax, ebp
        shl eax, 3
        sub eax, ebp
        shl eax, 6
        add edx, eax
        xor eax, eax
.7:
        mov bl, byte [edx+eax]
        mov byte [dword esi+eax+0240h], bl
        inc eax
        cmp eax, 0C0h
        jl short LoadTradeTeamPals.7
        xor eax, eax
        add edx, 0C0h
.8:
        mov bl, byte [edx+eax]
        mov byte [dword eax+awayremap], bl
        inc eax
        cmp eax, 90h
        jl short LoadTradeTeamPals.8
        mov eax, 90h
.9:
        mov bl, byte [edx+eax]
        add bl, 40h
        mov byte [dword eax+awayremap], bl
        inc eax
        cmp eax, 100h
        jl short LoadTradeTeamPals.9
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov byte [dword esi+0171h], 18h
        mov byte [dword esi+0172h], 0
        mov byte [dword esi+0173h], 0
        mov byte [dword esi+0174h], 2Ah
        mov byte [dword esi+0175h], 0
        mov byte [dword esi+0176h], 0
        mov byte [dword esi+0177h], 3Bh
        mov byte [dword esi+0178h], 12h
        mov byte [dword esi+0179h], 0
        mov byte [dword esi+017Ah], 3Bh
        mov byte [dword esi+017Bh], 3Bh
        mov byte [dword esi+017Ch], 3Bh
        mov byte [jerseypalslot0], 7Bh
        mov byte [jerseypalslot1], 7Ch
        mov byte [jerseypalslot2], 7Dh
        mov byte [jerseypalslot3], 7Eh
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawTradeScreen                                3E9CF  95 PC, none confidence
; Draw the trade menu background, team palettes, four jersey buttons and both
; roster columns, then display the bitmap with a palette fade. The jersey's
; primary colour is first the team's palette index, then that entry of
; jerseyremap.
;-----------------------------------------------------------------------------
; C: src/front/trade/DrawTradeScreen.c
%ifdef CBUILD
%include "c/front/trade/DrawTradeScreen.inc"
%else
DrawTradeScreen:
        push dword 60h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 38h
        mov ebp, edx
        mov esi, ebx
        mov edi, dword [byte esp+050h]
        mov edx, dword [tradebitmap]
        push edx
        call SetDrawBitmap
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Embnhl2
        cmp byte [fileoncd+08Ch], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [byte esp+020h]
        call MakePath
        push byte 0
        lea eax, [byte esp+024h]
        push eax
        call LoadBank
        mov dword [byte esp+038h], eax
        add esp, byte 8
        push byte 0
        push byte 0
        push str_Bkgd9
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call DrawArt
        add esp, byte 0Ch
        mov ecx, dword [byte esp+030h]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, dword [byte esp+04Ch]
        mov eax, esi
        call DrawMenuBar
        push byte 1
        mov ecx, 1DFh
        mov ebx, 27Fh
        xor edx, edx
        mov eax, 1C0h
        call DrawDlgFrame
        push byte 1
        mov ecx, 1DFh
        mov ebx, 0BEh
        xor edx, edx
        xor eax, eax
        call DrawDlgFrame
        push byte 20h
        push dword 300h
        push str_Pal22
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        mov dword [byte esp+034h], eax
        xor ecx, ecx
        mov ebx, str_Embpal3
        xor edx, edx
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pal21
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, esi
        call memcpy_
        mov eax, dword [statsbgshapes]
        push eax
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [byte edi+04h]
        mov eax, dword [edi]
        mov ebx, esi
        call LoadTradeTeamPals
        mov dword [traderemap1], homeremap
        mov dword [traderemap2], awayremap
        xor esi, esi
.3:
        mov ecx, esi
        sar ecx, 1
        mov edx, dword [nosplit ecx*4+traderemap1]
        add edx, 90h
        mov ebx, 30h
        mov eax, unk_D12C8
        call memcpy_
        mov eax, dword [edi+ecx*4]
        mov al, byte [nosplit eax*4+byte_D11BC]
        and eax, 0FFh
        mov al, byte [dword eax+jerseyremap]
        mov ah, byte [byte_D12DE]
        xor ecx, ecx
        mov cl, ah
        xor ebx, ebx
        mov bl, al
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        sub eax, esi
        mov edx, dword [byte esp+04Ch]
        mov dl, byte [byte edx+eax*2+01h]
        and edx, 0FFh
        mov eax, jerseyremap
        call MakeJerseyShape
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov ecx, dword [nosplit esi*8+tradebtny]
        push ecx
        mov edx, dword [nosplit esi*8+tradebtnx]
        push edx
        push ebp
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 4
        jl near DrawTradeScreen.3
        xor edi, edi
.4:
        xor esi, esi
.5:
        imul ebx, edi, dword 268h
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        sub eax, esi
        cmp byte [dword ebx+eax*2+traderoster], 0
        je near .8
        cmp esi, dword [nosplit edi*4+tradecursor]
        jne short .6
        push byte 41h
        push byte 42h
        jmp short .7
.6:
        push byte 41h
        push byte 40h
.7:
        call TextSetColors
        add esp, byte 8
        imul ebx, edi, dword 268h
        mov ecx, traderoster
        add ecx, ebx
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        sub eax, esi
        add eax, eax
        lea edx, [byte ecx+eax+03h]
        push edx
        xor edx, edx
        mov dl, byte [dword ebx+eax+tradejersey]
        push edx
        mov al, byte [dword ebx+eax+traderoster]
        and eax, 0FFh
        push eax
        push str_C2dS
        xor eax, eax
        mov al, byte [TextCharH]
        imul eax, esi
        add eax, byte 1Dh
        push eax
        mov eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 6
        add eax, byte 5
        push eax
        call PrintBoxedText
        add esp, byte 18h
        inc esi
        cmp esi, byte 1Ch
        jl near DrawTradeScreen.5
.8:
        inc edi
        cmp edi, byte 2
        jl near DrawTradeScreen.4
        call SetScreenTarget
        mov eax, dword [tradebitmap]
        mov ecx, dword [byte eax+02Ch]
        push ecx
        call DrawArtOpaqueAtOwnPos
        add esp, byte 4
        mov ebx, 10h
        mov edx, dword [byte esp+034h]
        xor eax, eax
        call FadePalStep
        mov esi, dword [byte esp+034h]
        push esi
        call FreeMemBlock
        add esp, byte 4
        add esp, byte 38h
        pop ebp
        pop edi
        pop esi
        ret 0Ch
%endif ; C
;-----------------------------------------------------------------------------
; TradeHitTest                                   3ECAE  95 PC, none confidence
; X is tested 4 pixels to the right. A point over the four trade buttons
; (tradebtnx/y, 3Ah by 28h, stride 8) writes the button into out[slot], or
; when slot is negative writes slot/2 and sets flag to -1. A point in the
; roster columns (y at least 1Dh, under TextCharH * 28 rows) writes the side
; (x past BEh) into slot and the row + 64h into out[slot]. Returns 1 for a
; hit. The button edges are read in place, and each branch sets hit (Watcom
; merges the two stores into one).
;-----------------------------------------------------------------------------
; C: src/front/trade/TradeHitTest.c
%ifdef CBUILD
%include "c/front/trade/TradeHitTest.inc"
%else
TradeHitTest:
        push dword 14h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov edi, edx
        mov dword [esp], ebx
        xor edx, edx
        mov eax, dword [byte esp+014h]
        mov dword [eax], edx
        add esi, byte 4
        cmp esi, 0BEh
        jle near .5
        cmp esi, 1C0h
        jge near .5
        xor ebx, ebx
.1:
        mov eax, ebx
        shl eax, 3
        mov ebp, dword [dword eax+tradebtnx]
        cmp esi, ebp
        jl short .4
        add ebp, byte 3Ah
        cmp esi, ebp
        jge short .4
        mov ebp, dword [dword eax+tradebtny]
        cmp edi, ebp
        jl short .4
        lea eax, [byte ebp+028h]
        cmp edi, eax
        jge short .4
        mov eax, dword [ecx]
        test eax, eax
        jl short .2
        shl eax, 2
        add eax, dword [esp]
        mov dword [eax], ebx
        jmp short .3
.2:
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [ecx], eax
        shl eax, 2
        add eax, dword [esp]
        mov dword [eax], ebx
        mov eax, dword [byte esp+014h]
        mov dword [eax], 0FFFFFFFFh
.3:
        mov edx, 1
.4:
        inc ebx
        cmp ebx, byte 4
        jl short TradeHitTest.1
        jmp short .6
.5:
        cmp edi, byte 1Dh
        jl short .6
        xor ebx, ebx
        mov bl, byte [TextCharH]
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        add eax, byte 1Dh
        cmp edi, eax
        jge short .6
        cmp esi, 0BEh
        setge al
        and eax, 0FFh
        mov dword [ecx], eax
        xor ebx, ebx
        mov bl, byte [TextCharH]
        lea edx, [byte edi-01Dh]
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, dword [ecx]
        shl edx, 2
        add edx, dword [esp]
        add eax, byte 64h
        mov dword [edx], eax
        mov edx, 1
.6:
        mov eax, edx
        add esp, byte 4
TradeHitTest_ret:
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; TradeDone                                      3EDAA  95 PC, none confidence
; Trade dialog "done" callback (a-h unused; sel: the selected slots of both
; sides, byte 0/1 and 2/3): a side with one of its pair picked and not the
; other is an unequal trade: save palette entries FBh-FEh (DONEPAL buffer),
; set them to the message colours, show "unequal trade" at the mouse, restore
; the palette and the mouse position. Otherwise traderesult = 1.
;-----------------------------------------------------------------------------
; C: src/front/trade/TradeDone.c
%ifdef CBUILD
%include "c/front/trade/TradeDone.inc"
%else
TradeDone:
        push dword 2Ch
        call __CHK
        push esi
        sub esp, byte 10h
        mov edx, dword [byte esp+028h]
        xor ebx, ebx
        mov dword [byte esp+08h], ebx
.1:
        mov eax, dword [byte esp+08h]
        add eax, edx
        mov cl, byte [eax]
        cmp cl, 0FFh
        jne short .2
        cmp cl, byte [byte eax+02h]
        jne short .3
.2:
        mov eax, dword [byte esp+08h]
        add eax, edx
        cmp byte [eax], 0FFh
        je short .4
        cmp byte [byte eax+02h], 0FFh
        jne short .4
.3:
        mov ebx, 0FFFFFFFFh
.4:
        mov esi, dword [byte esp+08h]
        inc esi
        mov dword [byte esp+08h], esi
        cmp esi, byte 2
        jl short TradeDone.1
        test ebx, ebx
        je near .5
        push byte 20h
        push byte 0Ch
        push str_Donepal
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        push eax
        push byte 4
        push dword 0FBh
        call SetPalette
        add esp, byte 0Ch
        mov byte [byte esp+0Ch], 18h
        xor ah, ah
        mov byte [byte esp+0Dh], ah
        mov byte [byte esp+0Eh], ah
        lea eax, [byte esp+0Ch]
        push eax
        push byte 1
        push dword 0FBh
        call VgaSetPalette
        add esp, byte 0Ch
        mov byte [byte esp+0Ch], 2Ah
        xor bl, bl
        mov byte [byte esp+0Dh], bl
        mov byte [byte esp+0Eh], bl
        lea eax, [byte esp+0Ch]
        push eax
        push byte 1
        push dword 0FCh
        call VgaSetPalette
        add esp, byte 0Ch
        mov byte [byte esp+0Ch], 3Bh
        mov byte [byte esp+0Dh], 12h
        xor al, al
        mov byte [byte esp+0Eh], al
        lea eax, [byte esp+0Ch]
        push eax
        push byte 1
        push dword 0FDh
        call VgaSetPalette
        add esp, byte 0Ch
        mov ah, 3Bh
        mov byte [byte esp+0Ch], ah
        mov byte [byte esp+0Dh], ah
        mov byte [byte esp+0Eh], ah
        lea eax, [byte esp+0Ch]
        push eax
        push byte 1
        push dword 0FEh
        call VgaSetPalette
        add esp, byte 0Ch
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
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, unequaltrademsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        push esi
        push byte 4
        push dword 0FBh
        call VgaSetPalette
        add esp, byte 0Ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [esp]
        push eax
        mov edx, dword [byte esp+08h]
        push edx
        call MouseSetPos
        add esp, byte 8
        jmp short .x
.5:
        mov dword [traderesult], 1
.x:
        add esp, byte 10h
        pop esi
        ret 14h
%endif ; C
;-----------------------------------------------------------------------------
; TradeCancel                                    3EF27  95 PC, none confidence
; Trade cancelled: traderesult = -1.
;-----------------------------------------------------------------------------
; C: src/front/trade/TradeCancel.c
%ifdef CBUILD
%include "c/front/trade/TradeCancel.inc"
%else
TradeCancel:
        push dword 4
        call __CHK
        mov dword [traderesult], 0FFFFFFFFh
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FindTradeSlot                                  3EF3C  95 PC, none confidence
; Index of the trade list slot of team side (28 slots of 22 bytes, 268h per
; team) whose first byte is pl, or -1.
;-----------------------------------------------------------------------------
; C: src/front/trade/FindTradeSlot.c
%ifdef CBUILD
%include "c/front/trade/FindTradeSlot.inc"
%else
FindTradeSlot:
        push dword 14h
        call __CHK
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov esi, eax
        mov byte [esp], dl
        mov edi, 0FFFFFFFFh
        xor edx, edx
        imul ecx, esi, dword 268h
.1:
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov al, byte [dword ecx+eax*2+tradeslot]
        cmp al, byte [esp]
        jne short .2
        mov edi, edx
        jmp short .3
.2:
        inc edx
        cmp edx, byte 1Ch
        jl short FindTradeSlot.1
.3:
        mov eax, edi
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TradeScreenLoop                                3EF89  95 PC, none confidence
; Trade screen main loop: draws both rosters, handles the mouse and the Trade
; / Done / Cancel buttons.
;-----------------------------------------------------------------------------
TradeScreenLoop:
        push dword 140h
        call __CHK
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 10Ch
        push eax
        push edx
        push ebx
        push ecx
        sub ebp, byte 72h
        xor edx, edx
        mov dword [byte ebp+06Eh], edx
        mov dword [byte ebp+05Ah], 40h
        mov dword [byte ebp+056h], 41h
        mov dword [byte ebp+052h], 42h
        mov dword [byte ebp+042h], edx
.1:
        mov edx, dword [byte ebp+042h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov byte [dword ebp+eax*2-099h], 0FFh
        mov eax, dword [byte ebp+042h]
        inc eax
        mov dword [byte ebp+042h], eax
        cmp eax, byte 4
        jl short TradeScreenLoop.1
        mov ebx, dword [dword ebp-0A6h]
        push ebx
        lea eax, [dword ebp-09Ah]
        push eax
        mov ecx, dword [dword ebp+08Eh]
        push ecx
        mov ecx, dword [dword ebp+08Ah]
        mov ebx, dword [dword ebp+082h]
        mov edx, dword [dword ebp-09Eh]
        mov eax, dword [dword ebp-0A2h]
        call DrawTradeScreen
        push str_Pntr2
        mov esi, dword [dword ebp+086h]
        push esi
        call FindShape
        mov dword [byte ebp+046h], eax
        add esp, byte 8
        mov eax, dword [dword ebp+082h]
        mov dword [byte ebp+0Eh], eax
        mov eax, dword [dword ebp+08Eh]
        mov dword [byte ebp-02h], eax
        xor edi, edi
        mov dword [byte ebp+01Ah], edi
        mov dword [byte ebp+016h], edi
        mov dword [byte ebp+012h], edi
        mov dword [byte ebp-016h], edi
        mov dword [byte ebp-01Ah], edi
        mov dword [byte ebp-01Eh], edi
        mov dword [byte ebp-022h], edi
        mov dword [byte ebp-06h], edi
        mov dword [byte ebp-0Ah], edi
        mov dword [byte ebp-0Eh], edi
        mov dword [byte ebp-012h], edi
        mov dword [byte ebp-03Eh], edi
        mov dword [byte ebp-042h], edi
        mov dword [menuact_gamescratch], edi
        mov dword [menuact_gamedress], edi
        mov eax, dword [byte ebp+046h]
        mov eax, dword [byte eax+02h]
        sar eax, 10h
        shl eax, 2
        mov edx, dword [byte ebp+046h]
        mov edx, dword [byte edx+04h]
        sar edx, 10h
        inc edx
        add eax, byte 4
        imul eax, edx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_Pointer10
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte ebp+05Eh], eax
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
        lea eax, [byte ebp+036h]
        push eax
        lea eax, [byte ebp+03Ah]
        push eax
        lea eax, [byte ebp+042h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov eax, dword [byte ebp+03Ah]
        mov dword [byte ebp+032h], eax
        mov eax, dword [byte ebp+036h]
        mov dword [byte ebp+02Eh], eax
        cmp eax, byte 20h
        jge short .2
        xor eax, eax
        jmp short .3
.2:
        sub eax, byte 20h
.3:
        push eax
        mov ecx, dword [byte ebp+03Ah]
        cmp ecx, byte 1Ch
        jge short .4
        xor eax, eax
        jmp short .5
.4:
        lea eax, [byte ecx-01Ch]
.5:
        push eax
        mov esi, dword [byte ebp+05Eh]
        push esi
        call GrabBlock
        add esp, byte 0Ch
        mov edi, dword [byte ebp+036h]
        push edi
        mov eax, dword [byte ebp+03Ah]
        sub eax, byte 3
        push eax
        mov eax, dword [pointerspr]
        push eax
        call DrawArtKeyColour
        add esp, byte 0Ch
        call ClearInputQueue
        xor edx, edx
        mov dword [traderesult], edx
.6:
        xor edx, edx
.7:
        call GetInputEvent
        mov ecx, eax
        test eax, eax
        je short .8
        lea ebx, [byte ebp+02Eh]
        lea edx, [byte ebp+032h]
        call dword [ptrupdatefn]
        mov edx, eax
.8:
        test ecx, ecx
        je short .9
        test dl, 2
        je short TradeScreenLoop.7
.9:
        test dl, 2
        jne near .20
        mov eax, dword [byte ebp+032h]
        cmp eax, dword [byte ebp+03Ah]
        jne short .10
        mov eax, dword [byte ebp+02Eh]
        cmp eax, dword [byte ebp+036h]
        je near .79
.10:
        mov esi, dword [byte ebp+036h]
        cmp esi, byte 20h
        jge short .11
        xor eax, eax
        jmp short .12
.11:
        lea eax, [byte esi-020h]
.12:
        push eax
        mov edi, dword [byte ebp+03Ah]
        cmp edi, byte 1Ch
        jge short .13
        xor eax, eax
        jmp short .14
.13:
        lea eax, [byte edi-01Ch]
.14:
        push eax
        mov eax, dword [byte ebp+05Eh]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [byte ebp+02Eh]
        cmp edx, byte 20h
        jge short .15
        xor eax, eax
        jmp short .16
.15:
        lea eax, [byte edx-020h]
.16:
        push eax
        mov ebx, dword [byte ebp+032h]
        cmp ebx, byte 1Ch
        jge short .17
        xor eax, eax
        jmp short .18
.17:
        lea eax, [byte ebx-01Ch]
.18:
        push eax
        mov ecx, dword [byte ebp+05Eh]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+02Eh]
        mov edx, dword [byte ebp+0Eh]
        cmp eax, dword [byte edx+0Ch]
        jle near .78
        mov edi, dword [byte ebp+032h]
        cmp edi, 0BEh
        jle near .78
        cmp edi, 1C0h
        jge near .78
        mov edx, dword [tradeside]
        cmp edx, byte 0FFFFFFFFh
        je near .78
        cmp dword [nosplit edx*4+tradecursor], byte 0FFFFFFFFh
        je near .78
        cmp dword [byte ebp+012h], byte 0
        je short .19
        lea eax, [byte ebp+026h]
        push eax
        lea eax, [byte ebp+02Ah]
        push eax
        lea eax, [byte ebp-042h]
        push eax
        lea eax, [byte ebp-02h]
        push eax
        mov ecx, dword [byte ebp+06Eh]
        lea ebx, [byte ebp+0Eh]
        mov edx, dword [byte ebp+02Eh]
        mov eax, edi
        call MenuHitTest
        test eax, eax
        jne near .78
.19:
        mov eax, dword [tradeside]
        mov edx, dword [nosplit eax*4+traderemap1]
        add edx, 90h
        mov ebx, 30h
        mov eax, unk_D12C8
        call memcpy_
        mov eax, dword [tradeside]
        mov edx, dword [dword ebp-0A6h]
        mov edx, dword [edx+eax*4]
        mov dl, byte [nosplit edx*4+byte_D11BC]
        and edx, 0FFh
        mov dl, byte [dword edx+jerseyremap]
        mov dh, byte [byte_D12DE]
        xor ecx, ecx
        mov cl, dh
        xor ebx, ebx
        mov bl, dl
        mov edx, dword [nosplit eax*4+tradecursor]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        imul edx, dword [tradeside], dword 268h
        add eax, edx
        xor edx, edx
        mov dl, byte [dword eax+tradejersey]
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
        mov edi, dword [dword ebp-09Eh]
        push edi
        call DrawArtKeyColour
        add esp, byte 0Ch
        jmp near .78
.20:
        lea eax, [byte ebp+026h]
        push eax
        lea eax, [byte ebp+02Ah]
        push eax
        lea eax, [byte ebp-042h]
        push eax
        lea eax, [byte ebp-02h]
        push eax
        mov ecx, dword [byte ebp+06Eh]
        lea ebx, [byte ebp+0Eh]
        mov edx, dword [byte ebp+02Eh]
        mov eax, dword [byte ebp+032h]
        call MenuHitTest
        mov edx, dword [byte ebp+036h]
        sub edx, byte 20h
        test eax, eax
        je near .50
        mov ebx, dword [byte ebp+02Ah]
        shl ebx, 2
        mov eax, dword [byte ebp+026h]
        shl eax, 5
        mov ecx, dword [byte ebx+ebp+0Eh]
        add eax, ecx
        cmp dword [byte eax+014h], byte 0
        je near .34
        mov eax, dword [byte ebp+026h]
        cmp eax, dword [byte ebx+ebp-012h]
        jne near .28
        cmp dword [byte ebp+036h], byte 20h
        jge short .21
        xor edx, edx
.21:
        push edx
        mov eax, dword [byte ebp+03Ah]
        cmp eax, byte 1Ch
        jge short .22
        xor eax, eax
        jmp short .23
.22:
        sub eax, byte 1Ch
.23:
        push eax
        mov edx, dword [byte ebp+05Eh]
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword ebp+08Eh]
        mov dword [byte ebp+042h], eax
        jmp short .26
.24:
        mov edx, ebx
        shl edx, 2
        cmp dword [byte edx+ebp-022h], byte 0
        je short .25
        mov eax, ebx
        mov ebx, dword [byte ebp+ebx*8-03Eh]
        push ebx
        mov ecx, dword [byte ebp+eax*8-042h]
        push ecx
        mov esi, dword [byte edx+ebp-022h]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+042h]
        xor edi, edi
        mov dword [byte ebp+eax*8-03Eh], edi
        mov dword [byte ebp+eax*8-042h], edi
        mov edx, dword [byte ebp+eax*4-022h]
        push edx
        call FreeMemBlock
        add esp, byte 4
.25:
        dec dword [byte ebp+042h]
.26:
        mov ebx, dword [byte ebp+042h]
        test ebx, ebx
        jge short TradeScreenLoop.24
        xor ecx, ecx
        mov dword [byte ebp+06Eh], ecx
        mov eax, dword [byte ebp+02Ah]
        mov esi, dword [byte ebp+026h]
        shl esi, 5
        mov eax, dword [byte ebp+eax*4+0Eh]
        add esi, eax
        mov edi, dword [dword ebp-0AAh]
        push edi
        mov eax, dword [dword ebp+08Eh]
        push eax
        mov edx, dword [dword ebp+082h]
        push edx
        mov ebx, dword [dword ebp+08Ah]
        push ebx
        mov ecx, dword [dword ebp-09Eh]
        push ecx
        mov eax, dword [byte ebp-0Eh]
        shl eax, 2
        mov edi, dword [dword ebp-0A6h]
        add eax, edi
        mov edx, dword [eax]
        lea ecx, [dword ebp-09Ah]
        mov ebx, edi
        mov eax, dword [dword ebp-0A2h]
        call dword [byte esi+014h]
        xor edx, edx
        mov dword [byte ebp+01Ah], edx
        mov dword [byte ebp+016h], edx
        mov dword [byte ebp+012h], edx
        mov dword [byte ebp-01Ah], edx
        mov dword [byte ebp-01Eh], edx
        mov dword [byte ebp-022h], edx
        mov dword [byte ebp-06h], edx
        mov dword [byte ebp-0Ah], edx
        mov dword [byte ebp-0Eh], edx
        mov dword [byte ebp+0Ah], edx
        mov dword [byte ebp+06h], edx
        mov dword [byte ebp+02h], edx
        cmp eax, byte 1
        jne short .27
        call ClearInputQueue
        mov edi, dword [byte ebp+05Eh]
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        jmp near .81
.27:
        mov ecx, dword [byte ebp+036h]
        push ecx
        mov esi, dword [byte ebp+03Ah]
        push esi
        call MouseSetPos
        add esp, byte 8
        mov eax, dword [byte ebp+03Ah]
        mov dword [byte ebp+032h], eax
        mov eax, dword [byte ebp+036h]
        mov dword [byte ebp+02Eh], eax
        call ClearInputQueue
        jmp near .72
.28:
        cmp dword [byte ebp+036h], byte 20h
        jge short .29
        xor edx, edx
.29:
        push edx
        mov edi, dword [byte ebp+03Ah]
        cmp edi, byte 1Ch
        jge short .30
        xor eax, eax
        jmp short .31
.30:
        lea eax, [byte edi-01Ch]
.31:
        push eax
        mov eax, dword [byte ebp+05Eh]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [byte ebp+052h]
        push edx
        mov ebx, dword [byte ebp+056h]
        push ebx
        mov eax, dword [byte ebp+02Ah]
        mov ebx, dword [byte ebp+eax*8-03Eh]
        mov edx, dword [byte ebp+eax*8-042h]
        mov ecx, dword [byte ebp+eax*4-012h]
        shl ecx, 5
        mov eax, dword [byte ebp+eax*4+0Eh]
        add eax, ecx
        mov ecx, dword [byte ebp+05Ah]
        call DrawMenuItemSel
        mov edx, dword [byte ebp+02Ah]
        mov eax, dword [byte ebp+026h]
        mov dword [byte ebp+edx*4-012h], eax
        mov ecx, dword [byte ebp+052h]
        push ecx
        mov esi, dword [byte ebp+056h]
        push esi
.32:
        mov ebx, dword [byte ebp+edx*8-03Eh]
        mov eax, dword [byte ebp+edx*8-042h]
        mov esi, dword [byte ebp+edx*4-012h]
        shl esi, 5
        mov edx, dword [byte ebp+edx*4+0Eh]
        add esi, edx
        mov ecx, dword [byte ebp+05Ah]
        mov edx, eax
        mov eax, esi
.33:
        call DrawMenuItemNorm
        jmp near .72
.34:
        cmp dword [byte eax+018h], byte 0
        je near .46
        cmp dword [byte ebp+036h], byte 20h
        jge short .35
        xor edx, edx
.35:
        push edx
        mov edi, dword [byte ebp+03Ah]
        cmp edi, byte 1Ch
        jge short .36
        xor eax, eax
        jmp short .37
.36:
        lea eax, [byte edi-01Ch]
.37:
        push eax
        mov eax, dword [byte ebp+05Eh]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+06Eh]
        cmp eax, dword [byte ebp+02Ah]
        je short .41
        mov dword [byte ebp+042h], eax
        jmp short .40
.38:
        shl eax, 2
        xor ebx, ebx
        mov dword [byte eax+ebp-012h], ebx
        mov ecx, dword [byte eax+ebp-022h]
        test ecx, ecx
        je short .39
        mov edx, dword [byte ebp+042h]
        mov esi, dword [byte ebp+edx*8-03Eh]
        push esi
        mov edi, dword [byte ebp+edx*8-042h]
        push edi
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+042h]
        xor ebx, ebx
        mov dword [byte ebp+eax*8-03Eh], ebx
        mov dword [byte ebp+eax*8-042h], ebx
        mov ecx, dword [byte ebp+eax*4-022h]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [byte ebp+042h]
        xor esi, esi
        mov dword [byte ebp+eax*4-022h], esi
        mov dword [byte ebp+eax*4+0Eh], esi
        mov dword [byte ebp+eax*4-02h], esi
.39:
        dec dword [byte ebp+042h]
.40:
        mov eax, dword [byte ebp+042h]
        mov edx, dword [byte ebp+02Ah]
        cmp eax, edx
        jg short TradeScreenLoop.38
        mov dword [byte ebp+06Eh], edx
.41:
        mov ecx, dword [byte ebp+052h]
        push ecx
        mov esi, dword [byte ebp+056h]
        push esi
        mov edi, dword [byte ebp+06Eh]
        mov ebx, dword [byte ebp+edi*8-03Eh]
        mov edx, dword [byte ebp+edi*8-042h]
        mov eax, dword [byte ebp+edi*4-012h]
        shl eax, 5
        mov ecx, dword [byte ebp+edi*4+0Eh]
        add eax, ecx
        mov ecx, dword [byte ebp+05Ah]
        call DrawMenuItemSel
        mov eax, dword [byte ebp+026h]
        mov dword [byte ebp+edi*4-012h], eax
        mov eax, dword [byte ebp+052h]
        push eax
        push esi
        mov ebx, dword [byte ebp+edi*8-03Eh]
        mov edx, dword [byte ebp+edi*8-042h]
        mov ecx, dword [byte ebp+026h]
        shl ecx, 5
        mov eax, dword [byte ebp+edi*4+0Eh]
        add eax, ecx
        mov ecx, dword [byte ebp+05Ah]
        call DrawMenuItemNorm
        mov eax, dword [byte ebp+02Ah]
        mov ecx, dword [byte ebp+026h]
        shl ecx, 5
        mov ebx, dword [byte ebp+eax*4+0Eh]
        lea esi, [byte edi+01h]
        mov dword [byte ebp+06Eh], esi
        mov ebx, dword [byte ecx+ebx+018h]
        mov dword [byte ebp+esi*4+0Eh], ebx
        mov eax, dword [byte ebp+eax*4+0Eh]
        add eax, ecx
        mov ebx, dword [byte eax+01Ch]
        mov dword [byte ebp+esi*4-02h], ebx
        cmp esi, byte 1
        je short .42
        mov edx, dword [byte eax+08h]
        jmp short .43
.42:
        mov edx, dword [eax]
.43:
        mov eax, dword [byte ebp+06Eh]
        mov ebx, dword [byte ebp+eax*8-04Ah]
        add edx, ebx
        mov dword [byte ebp+eax*8-042h], edx
        mov edx, dword [byte ebp+026h]
        shl edx, 5
        mov eax, dword [byte ebp+02Ah]
        shl eax, 2
        cmp dword [byte ebp+06Eh], byte 1
        je short .44
        mov eax, dword [byte eax+ebp+0Eh]
        mov eax, dword [byte edx+eax+04h]
        jmp short .45
.44:
        mov eax, dword [byte eax+ebp+0Eh]
        mov eax, dword [byte edx+eax+0Ch]
.45:
        mov edx, dword [byte ebp+06Eh]
        shl edx, 3
        mov dword [byte ebp+062h], edx
        mov esi, dword [byte edx+ebp-046h]
        add eax, esi
        mov dword [byte edx+ebp-03Eh], eax
        mov eax, dword [byte ebp+06Eh]
        shl eax, 2
        mov dword [byte ebp+066h], eax
        mov edx, dword [byte eax+ebp-02h]
        shl edx, 5
        mov eax, dword [byte eax+ebp+0Eh]
        mov ebx, dword [byte edx+eax-018h]
        sub ebx, dword [eax]
        inc ebx
        mov dword [byte ebp+01Eh], ebx
        mov edx, dword [byte edx+eax-014h]
        sub edx, dword [byte eax+04h]
        inc edx
        mov dword [byte ebp+022h], edx
        push byte 20h
        mov eax, dword [byte ebp+01Eh]
        shl eax, 2
        imul eax, edx
        add eax, byte 11h
        push eax
        push str_Menubuff7
        call AllocMemBlock
        add esp, byte 0Ch
        mov edx, dword [byte ebp+066h]
        mov dword [byte edx+ebp-022h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [byte edx+ebp-022h]
        mov edx, dword [byte ebp+01Eh]
        mov word [byte eax+04h], dx
        mov eax, dword [byte ebp+066h]
        mov eax, dword [byte eax+ebp-022h]
        mov edx, dword [byte ebp+022h]
        mov word [byte eax+06h], dx
        mov eax, dword [byte ebp+062h]
        mov esi, dword [byte eax+ebp-03Eh]
        push esi
        mov edi, dword [byte eax+ebp-042h]
        push edi
        mov eax, dword [byte ebp+066h]
        mov edx, dword [byte eax+ebp-022h]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte ebp+052h]
        push ebx
        mov ecx, dword [byte ebp+056h]
        push ecx
        mov esi, dword [byte ebp+05Ah]
        push esi
        mov ecx, dword [byte ebp+062h]
        mov ecx, dword [byte ecx+ebp-03Eh]
        mov ebx, dword [byte ebp+062h]
        mov ebx, dword [byte ebx+ebp-042h]
        mov edx, dword [byte ebp+066h]
        mov edx, dword [byte edx+ebp-02h]
        mov eax, dword [byte ebp+066h]
        mov eax, dword [byte eax+ebp+0Eh]
        call DrawMenuDropdown
        mov eax, dword [byte ebp+066h]
        xor edi, edi
        mov dword [byte eax+ebp-012h], edi
        mov eax, dword [byte ebp+052h]
        push eax
        mov edx, dword [byte ebp+056h]
        push edx
        mov ebx, dword [byte ebp+062h]
        mov ebx, dword [byte ebx+ebp-03Eh]
        mov edx, dword [byte ebp+062h]
        mov edx, dword [byte edx+ebp-042h]
        mov eax, dword [byte ebp+066h]
        mov eax, dword [byte eax+ebp+0Eh]
        mov ecx, esi
        jmp near TradeScreenLoop.33
.46:
        cmp dword [byte ebp+036h], byte 20h
        jge short .47
        xor edx, edx
.47:
        push edx
        mov esi, dword [byte ebp+03Ah]
        cmp esi, byte 1Ch
        jge short .48
        xor eax, eax
        jmp short .49
.48:
        lea eax, [byte esi-01Ch]
.49:
        push eax
        mov edi, dword [byte ebp+05Eh]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+052h]
        push eax
        mov edx, dword [byte ebp+056h]
        push edx
        mov eax, dword [byte ebp+02Ah]
        mov ebx, dword [byte ebp+eax*8-03Eh]
        mov edx, dword [byte ebp+eax*8-042h]
        mov ecx, dword [byte ebp+eax*4-012h]
        shl ecx, 5
        mov eax, dword [byte ebp+eax*4+0Eh]
        add eax, ecx
        mov ecx, dword [byte ebp+05Ah]
        call DrawMenuItemSel
        mov edx, dword [byte ebp+02Ah]
        mov eax, dword [byte ebp+026h]
        mov dword [byte ebp+edx*4-012h], eax
        mov ebx, dword [byte ebp+052h]
        push ebx
        mov ecx, dword [byte ebp+056h]
        push ecx
        jmp near TradeScreenLoop.32
.50:
        cmp dword [byte ebp+036h], byte 20h
        jge short .51
        xor edx, edx
.51:
        push edx
        mov ecx, dword [byte ebp+03Ah]
        cmp ecx, byte 1Ch
        jge short .52
        xor eax, eax
        jmp short .53
.52:
        lea eax, [byte ecx-01Ch]
.53:
        push eax
        mov esi, dword [byte ebp+05Eh]
        push esi
        call PutBlock
        add esp, byte 0Ch
        lea eax, [byte ebp+03Eh]
        push eax
        mov ecx, tradeside
        mov ebx, tradeclick
        mov edx, dword [byte ebp+02Eh]
        mov eax, dword [byte ebp+032h]
        call TradeHitTest
        test eax, eax
        je near .72
        mov eax, dword [dword ebp+08Eh]
        mov dword [byte ebp+042h], eax
        jmp short .56
.54:
        mov eax, ebx
        shl eax, 2
        mov esi, dword [byte eax+ebp-022h]
        test esi, esi
        je short .55
        mov edi, dword [byte ebp+ebx*8-03Eh]
        push edi
        mov ebx, dword [byte ebp+ebx*8-042h]
        push ebx
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+042h]
        xor esi, esi
        mov dword [byte ebp+eax*8-03Eh], esi
        mov dword [byte ebp+eax*8-042h], esi
        mov edi, dword [byte ebp+eax*4-022h]
        push edi
        call FreeMemBlock
        add esp, byte 4
.55:
        dec dword [byte ebp+042h]
.56:
        mov ebx, dword [byte ebp+042h]
        test ebx, ebx
        jge short TradeScreenLoop.54
        xor ecx, ecx
        mov dword [byte ebp+06Eh], ecx
        mov dword [byte ebp+01Ah], ecx
        mov dword [byte ebp+016h], ecx
        mov dword [byte ebp+012h], ecx
        mov dword [byte ebp-01Ah], ecx
        mov dword [byte ebp-01Eh], ecx
        mov dword [byte ebp-022h], ecx
        mov dword [byte ebp-06h], ecx
        mov dword [byte ebp-0Ah], ecx
        mov dword [byte ebp-0Eh], ecx
        mov dword [byte ebp+0Ah], ecx
        mov dword [byte ebp+06h], ecx
        mov dword [byte ebp+02h], ecx
        mov eax, dword [tradeside]
        shl eax, 2
        cmp dword [dword eax+tradeclick], byte 64h
        jge near .69
        cmp dword [dword eax+tradecursor], byte 0FFFFFFFFh
        jne short .57
        cmp dword [byte ebp+03Eh], byte 0
        je near .69
.57:
        xor edi, edi
        mov eax, dword [tradeside]
        mov edx, dword [nosplit eax*4+tradeclick]
        mov dword [byte ebp+06Ah], edx
        mov eax, dword [nosplit eax*4+tradecursor]
        mov dword [byte ebp+04Ah], eax
        mov esi, dword [dword ebp-0AAh]
        add esi, edx
        cmp dword [byte ebp+03Eh], byte 0
        je near .60
        mov cl, byte [esi]
        cmp cl, 0FFh
        je near .59
        mov edi, dword [byte ebp+04Ah]
        cmp edi, byte 0FFFFFFFFh
        je short .58
        xor eax, eax
        mov al, cl
        cmp eax, edi
        je short .58
        push byte 41h
        push byte 40h
        call TextSetColors
        add esp, byte 8
        mov eax, dword [tradeside]
        call DrawTradeRow
.58:
        mov esi, dword [dword ebp-0AAh]
        add esi, dword [byte ebp+06Ah]
        xor edx, edx
        mov dl, byte [esi]
        mov eax, dword [tradeside]
        call FindTradeSlot
        mov edx, eax
        mov eax, dword [tradeside]
        mov dword [nosplit eax*4+tradecursor], edx
        push byte 41h
        push byte 42h
        call TextSetColors
        add esp, byte 8
        mov eax, dword [tradeside]
        call DrawTradeRow
        mov byte [esi], 0FFh
        mov edx, dword [byte ebp+06Ah]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov byte [dword ebp+eax*2-099h], 0FFh
        mov edi, 0FFFFFFFFh
        jmp near .67
.59:
        mov dword [tradeside], 0FFFFFFFFh
        jmp near .67
.60:
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [eax+eax]
        mov ebx, dword [byte ebp+04Ah]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov dword [byte ebp+04Eh], eax
        imul eax, dword [tradeside], dword 268h
        add eax, dword [byte ebp+04Eh]
        mov ebx, dword [byte ebp+06Ah]
        cmp ebx, byte 2
        jge near .63
        cmp dword [tradeside], byte 0
        jne near .67
        mov ebx, dword [dword ebp-0AAh]
        mov bl, byte [ebx]
        cmp bl, byte [dword eax+tradeslot]
        je near .67
        mov ebx, dword [dword ebp-0AAh]
        mov bl, byte [byte ebx+01h]
        mov cl, byte [dword eax+tradeslot]
        cmp bl, cl
        je near .67
        mov byte [esi], cl
        imul esi, dword [tradeside], dword 268h
        add esi, dword [byte ebp+04Eh]
        lea edi, [dword edx+ebp-09Ah]
        lea esi, [dword esi+traderoster]
        movsd
        movsd
        movsd
        movsd
        movsd
        movsw
        mov ch, byte [dword edx+ebp-09Ah]
        cmp ch, 47h
        jne short .61
        mov edx, dword [byte ebp+06Ah]
        add edx, byte 2
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        cmp ch, byte [dword ebp+eax*2-09Ah]
        jne short .62
.61:
        mov edx, dword [byte ebp+06Ah]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        cmp byte [dword ebp+eax*2-09Ah], 47h
        je near .66
        mov edx, dword [byte ebp+06Ah]
        add edx, byte 2
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        cmp byte [dword ebp+eax*2-09Ah], 47h
        jne near .66
.62:
        mov eax, dword [dword ebp-0AAh]
        mov edx, dword [byte ebp+06Ah]
        add eax, edx
        mov byte [byte eax+02h], 0FFh
        add edx, byte 2
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov byte [dword ebp+eax*2-099h], 0FFh
        jmp near .66
.63:
        cmp ebx, byte 4
        jge near .67
        cmp dword [tradeside], byte 1
        jne near .67
        mov ebx, dword [dword ebp-0AAh]
        mov bl, byte [byte ebx+02h]
        mov ch, byte [dword eax+tradeslot]
        cmp bl, ch
        je near .67
        mov ebx, dword [dword ebp-0AAh]
        cmp ch, byte [byte ebx+03h]
        je near .67
        mov byte [esi], ch
        imul esi, dword [tradeside], dword 268h
        add esi, dword [byte ebp+04Eh]
        lea edi, [dword edx+ebp-09Ah]
        lea esi, [dword esi+traderoster]
        movsd
        movsd
        movsd
        movsd
        movsd
        movsw
        mov cl, byte [dword edx+ebp-09Ah]
        cmp cl, 47h
        jne short .64
        mov edx, dword [byte ebp+06Ah]
        sub edx, byte 2
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        cmp cl, byte [dword ebp+eax*2-09Ah]
        jne short .65
.64:
        mov edx, dword [byte ebp+06Ah]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        cmp byte [dword ebp+eax*2-09Ah], 47h
        je short .66
        mov edx, dword [byte ebp+06Ah]
        sub edx, byte 2
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        cmp byte [dword ebp+eax*2-09Ah], 47h
        jne short .66
.65:
        mov eax, dword [dword ebp-0AAh]
        mov edx, dword [byte ebp+06Ah]
        add eax, edx
        mov byte [byte eax-02h], 0FFh
        sub edx, byte 2
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov byte [dword ebp+eax*2-099h], 0FFh
.66:
        push byte 41h
        push byte 40h
        call TextSetColors
        add esp, byte 8
        mov eax, dword [tradeside]
        call DrawTradeRow
        mov eax, dword [tradeside]
        mov ebx, 0FFFFFFFFh
        mov dword [nosplit eax*4+tradecursor], ebx
        mov dword [tradeside], ebx
        mov edi, ebx
.67:
        test edi, edi
        je near .72
        xor ecx, ecx
        mov dword [byte ebp+042h], ecx
        mov esi, dword [dword ebp-09Eh]
.68:
        mov eax, dword [byte ebp+042h]
        sar eax, 1
        mov edx, dword [nosplit eax*4+traderemap1]
        add edx, 90h
        mov ebx, 30h
        mov eax, unk_D12C8
        call memcpy_
        mov eax, dword [byte ebp+042h]
        sar eax, 1
        shl eax, 2
        add eax, dword [dword ebp-0A6h]
        mov eax, dword [eax]
        mov al, byte [nosplit eax*4+byte_D11BC]
        and eax, 0FFh
        mov al, byte [dword eax+jerseyremap]
        mov ah, byte [byte_D12DE]
        xor ecx, ecx
        mov cl, ah
        xor ebx, ebx
        mov bl, al
        mov edx, dword [byte ebp+042h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        xor edx, edx
        mov dl, byte [dword ebp+eax*2-099h]
        mov eax, jerseyremap
        call MakeJerseyShape
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov eax, dword [byte ebp+042h]
        mov ebx, dword [nosplit eax*8+tradebtny]
        push ebx
        mov ecx, dword [nosplit eax*8+tradebtnx]
        push ecx
        push esi
        call DrawArtMasked
        add esp, byte 0Ch
        mov edi, dword [byte ebp+042h]
        inc edi
        mov dword [byte ebp+042h], edi
        cmp edi, byte 4
        jl near TradeScreenLoop.68
        jmp near .72
.69:
        mov eax, dword [tradeside]
        shl eax, 2
        mov edx, dword [dword eax+tradeclick]
        cmp edx, byte 64h
        jl near .72
        lea ebx, [byte edx-064h]
        mov dword [dword eax+tradeclick], ebx
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        lea ebx, [edx+edx]
        imul edx, dword [tradeside], dword 268h
        cmp byte [dword edx+ebx+traderoster], 0
        je near .72
        mov edx, dword [dword eax+tradecursor]
        cmp edx, dword [dword eax+tradeclick]
        jne short .70
        push byte 41h
        push byte 40h
        call TextSetColors
        add esp, byte 8
        mov eax, dword [tradeside]
        call DrawTradeRow
        mov eax, dword [tradeside]
        mov edx, 0FFFFFFFFh
        mov dword [nosplit eax*4+tradecursor], edx
        mov dword [tradeside], edx
        jmp short .72
.70:
        cmp edx, byte 0FFFFFFFFh
        je short .71
        push byte 41h
        push byte 40h
        call TextSetColors
        add esp, byte 8
        mov eax, dword [tradeside]
        call DrawTradeRow
.71:
        mov eax, dword [tradeside]
        mov edx, dword [nosplit eax*4+tradeclick]
        mov dword [nosplit eax*4+tradecursor], edx
        push byte 41h
        push byte 42h
        call TextSetColors
        add esp, byte 8
        mov eax, dword [tradeside]
        call DrawTradeRow
.72:
        cmp dword [traderesult], byte 0
        jne near .79
        mov esi, dword [byte ebp+02Eh]
        cmp esi, byte 20h
        jge short .73
        xor eax, eax
        jmp short .74
.73:
        lea eax, [byte esi-020h]
.74:
        push eax
        mov edi, dword [byte ebp+032h]
        cmp edi, byte 1Ch
        jge short .75
        xor eax, eax
        jmp short .76
.75:
        lea eax, [byte edi-01Ch]
.76:
        push eax
        mov eax, dword [byte ebp+05Eh]
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+02Eh]
        mov edx, dword [byte ebp+0Eh]
        cmp eax, dword [byte edx+0Ch]
        jle near .78
        mov ecx, dword [byte ebp+032h]
        cmp ecx, 0BEh
        jle near .78
        cmp ecx, 1C0h
        jge near .78
        mov edi, dword [tradeside]
        cmp edi, byte 0FFFFFFFFh
        je near .78
        cmp dword [nosplit edi*4+tradecursor], byte 0FFFFFFFFh
        je near .78
        cmp dword [byte ebp+012h], byte 0
        je short .77
        lea eax, [byte ebp+026h]
        push eax
        lea eax, [byte ebp+02Ah]
        push eax
        lea eax, [byte ebp-042h]
        push eax
        lea eax, [byte ebp-02h]
        push eax
        mov ecx, dword [byte ebp+06Eh]
        lea ebx, [byte ebp+0Eh]
        mov edx, dword [byte ebp+02Eh]
        mov eax, dword [byte ebp+032h]
        call MenuHitTest
        test eax, eax
        jne near .78
.77:
        mov eax, dword [tradeside]
        mov edx, dword [nosplit eax*4+traderemap1]
        add edx, 90h
        mov ebx, 30h
        mov eax, unk_D12C8
        call memcpy_
        mov edx, dword [tradeside]
        mov eax, dword [dword ebp-0A6h]
        mov eax, dword [eax+edx*4]
        mov al, byte [nosplit eax*4+byte_D11BC]
        and eax, 0FFh
        mov al, byte [dword eax+jerseyremap]
        mov ah, byte [byte_D12DE]
        xor ecx, ecx
        mov cl, ah
        xor ebx, ebx
        mov bl, al
        mov edx, dword [nosplit edx*4+tradecursor]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        imul edx, dword [tradeside], dword 268h
        add eax, edx
        xor edx, edx
        mov dl, byte [dword eax+tradejersey]
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
        mov edi, dword [dword ebp-09Eh]
        push edi
        call DrawArtKeyColour
        add esp, byte 0Ch
.78:
        mov eax, dword [byte ebp+02Eh]
        push eax
        mov eax, dword [byte ebp+032h]
        sub eax, byte 3
        push eax
        mov edx, dword [pointerspr]
        push edx
        call DrawArtKeyColour
        add esp, byte 0Ch
        mov eax, dword [byte ebp+032h]
        mov dword [byte ebp+03Ah], eax
        mov eax, dword [byte ebp+02Eh]
        mov dword [byte ebp+036h], eax
.79:
        cmp dword [traderesult], byte 0
        je near TradeScreenLoop.6
        mov ecx, dword [byte ebp+05Eh]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        cmp dword [traderesult], byte 0
        jle short .80
        xor edi, edi
        mov dword [traderesult], edi
.80:
        mov eax, dword [traderesult]
.81:
        lea esp, [byte ebp+072h]
        pop ebp
        pop edi
        pop esi
        ret 10h
;-----------------------------------------------------------------------------
; TradeRosterCmp                                 3FEF0  95 PC, none confidence
; Qsort compare for trade roster rows: same position letter (byte 0) sorts by
; name (+6), empty rows last, then positions in the order L, C, R, D, others.
;-----------------------------------------------------------------------------
; C: src/front/trade/TradeRosterCmp.c
%ifdef CBUILD
%include "c/front/trade/TradeRosterCmp.inc"
%else
TradeRosterCmp:
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
        je short TradeRosterCmp.3
        cmp bh, 4Ch
        je short .5
        cmp bl, 43h
        je short TradeRosterCmp.3
        cmp bh, 43h
        je short .5
        cmp bl, 52h
        je short TradeRosterCmp.3
        cmp bh, 52h
        je short .5
        cmp bl, 44h
        je short TradeRosterCmp.3
.5:
        mov eax, 1
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TradeScreen                                    3FF52  95 PC, none confidence
; TradeScreen (3FF52, PC only; ends in TradeHitTest_ret): the trade screen of
; league dir between teams[0] and teams[1]. Fade to the black "Temp" palette,
; clear the screen bitmap (tradebitmap), save the text state, load the S12
; font and the lineditp bank ("Shrt" art), reset the cursors and clicks
; (tradecursor, tradeclick, tradeside -1) and build both trade rosters
; (BuildTradeRoster into traderoster / +268h, the team records into recs);
; when both load, sort them (TradeRosterCmp) and run the screen
; (TradeScreenLoop). Then free the bank, restore the text state and free the
; font. dir: the league dir; teams: the two teams; b, c, d: passed on to
; TradeScreenLoop. Result: BuildTradeRoster's error, else TradeScreenLoop's
; result. Matched under 10.0 GA with the locals declared bank, recs, state,
; path, r, font, shape (the EXE's slots: shape +620h, b +624h, c +628h, bank
; +62Ch, font +630h).
;-----------------------------------------------------------------------------
; C: src/front/trade/TradeHitTest.c (TradeScreen)
%ifdef CBUILD
%include "c/front/trade/TradeHitTest.TradeScreen.inc"
%else
TradeScreen:
        push dword 654h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 634h
        mov ebp, eax
        mov esi, edx
        mov dword [dword esp+0624h], ebx
        mov dword [dword esp+0628h], ecx
        call SetScreenTarget
        push byte 20h
        push dword 300h
        push str_Temp6
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
        mov edx, dword [tradebitmap]
        push edx
        call SetDrawBitmap
        add esp, byte 4
        push byte 0
        call ClearScreen
        add esp, byte 4
        lea eax, [dword esp+05D0h]
        push eax
        call TextSaveState
        add esp, byte 4
        mov ecx, str_VFN
        mov ebx, str_S12
        cmp byte [fileoncd+0E7h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0610h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0614h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [dword esp+0630h], eax
        push eax
        call TextSetFont
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Lineditp
        cmp byte [fileoncd+0E8h], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp short .4
.3:
        xor edx, edx
.4:
        lea eax, [dword esp+0610h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0614h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [dword esp+062Ch], eax
        push str_Shrt
        push eax
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0620h], eax
        mov ebx, 0FFFFFFFFh
        mov dword [tradecursor], ebx
        mov dword [tradecursor+4], ebx
        mov dword [tradeclick], ebx
        mov dword [tradeclick+4], ebx
        mov dword [tradeside], ebx
        mov edx, dword [esi]
        mov ecx, esp
        mov ebx, traderoster
        mov eax, ebp
        call BuildTradeRoster
        mov edi, eax
        test eax, eax
        jne short .5
        mov edx, dword [byte esi+04h]
        lea ecx, [dword esp+02E8h]
        mov ebx, traderoster+268h
        mov eax, ebp
        call BuildTradeRoster
        mov edi, eax
.5:
        test edi, edi
        jne short .6
        mov ecx, TradeRosterCmp
        mov ebx, 16h
        mov edx, 1Ch
        mov eax, traderoster
        call qsort_
        mov ecx, TradeRosterCmp
        mov ebx, 16h
        mov edx, 1Ch
        mov eax, traderoster+268h
        call qsort_
        mov ebx, dword [dword esp+0644h]
        push ebx
        mov ecx, dword [dword esp+0634h]
        push ecx
        mov edi, dword [dword esp+0634h]
        push edi
        mov ebp, dword [dword esp+0634h]
        push ebp
        mov ecx, dword [dword esp+0634h]
        mov ebx, esi
        lea edx, [byte esp+010h]
        mov eax, dword [dword esp+0630h]
        call TradeScreenLoop
        mov edi, eax
.6:
        mov eax, dword [dword esp+062Ch]
        push eax
        call FreeMemBlock
        add esp, byte 4
        lea eax, [dword esp+05D0h]
        push eax
        call TextRestoreState
        add esp, byte 4
        mov edx, dword [dword esp+0630h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov eax, edi
        add esp, 634h
        jmp near TradeHitTest_ret
%endif ; C
;-----------------------------------------------------------------------------
; TradePlayers                                                    40183  95 PC
; League menu entry (temp_files 3354F): reads PINFO (ReadLeagueInfo), refuses
; with 'There is a saved game in the league' / master-database prompt, reads
; SCHEDULE.DB to refuse after the deadline ('The trading deadline has
; passed!'), needs two human teams ('There is only one human controlled
; team!'), 'Select two teams for trading players', AskTeamPassword for each,
; 'Show <team> Statistics...' buttons, then ExecuteTrade does the trade
; ('Error while trading players!')
;-----------------------------------------------------------------------------
TradePlayers:
        push dword 108h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 0D8h
        mov dword [dword esp+0B8h], 0FFFFFFFFh
        xor ebp, ebp
        mov eax, dword [negone_3DC28]
        mov dword [dword esp+0ACh], eax
        push ebp
        push dword 1E0h
        push dword 280h
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [tradebitmap], eax
        mov eax, dword [dlgfillcol]
        mov dword [dword esp+0BCh], eax
        mov eax, dword [dlgedgecol1]
        mov dword [dword esp+0CCh], eax
        mov eax, dword [dlgedgecol2]
        mov dword [dword esp+0C8h], eax
        mov eax, dword [dlgedgecol3]
        mov dword [dword esp+0C4h], eax
        mov eax, dword [dlgbevelcol1]
        mov dword [dword esp+0C0h], eax
        mov eax, dword [dlgbevelcol2]
        mov dword [dword esp+0D0h], eax
        mov ebx, 41h
        mov dword [dlgfillcol], ebx
        mov ecx, 40h
        mov dword [dlgedgecol1], ecx
        mov dword [dlgedgecol2], 42h
        mov dword [dlgedgecol3], ebx
        mov dword [dlgbevelcol1], ecx
        mov dword [dlgbevelcol2], ebx
.1:
        xor esi, esi
        test ebp, ebp
        jne short .2
        push savedname
        push leaguesaved
        push leagueflags
        push humancount
        mov ecx, leaguemaster
        mov ebx, masterpw
        mov edx, leagueteams
        mov eax, curleague
        call ReadLeagueInfo
        mov ebp, eax
.2:
        test ebp, ebp
        jne near .6
        push dword 0F7h
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        lea eax, [dword esp+0B0h]
        push eax
        lea eax, [dword esp+0B8h]
        push eax
        lea eax, [dword esp+0B0h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov edx, curleague
        lea eax, [dword esp+088h]
        call strcpy_
        mov edx, str_dot
        lea eax, [dword esp+088h]
        call strcspn_
        xor dl, dl
        mov byte [dword esp+eax+088h], dl
        cmp dword [leaguesaved], byte 0
        je short .4
        lea eax, [dword esp+088h]
        mov dword [msg_SavedGame_arg], eax
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0B4h]
        push eax
        lea eax, [dword esp+0BCh]
        push eax
        push ebp
        push ebp
        mov ecx, 3
        mov ebx, msg_SavedGame
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.3:
        mov ebp, 0FFFFFFFFh
        jmp near .6
.4:
        test byte [leagueflags], 4
        jne short .5
        lea eax, [dword esp+088h]
        mov dword [msg_MasterDB_arg], eax
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0B4h]
        push eax
        lea eax, [dword esp+0BCh]
        push eax
        push byte 2
        push btn_MasterDB
        mov ecx, 4
        mov ebx, msg_MasterDB
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [dword esp+0A8h], eax
        test eax, eax
        jne short TradePlayers.3
        call MergeLeagueFiles
        mov esi, 0FFFFFFFFh
        jmp short .6
.5:
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, curleague
        lea eax, [byte esp+068h]
        call MakePath
        mov ebx, 1
        mov edx, treeteamnames
        lea eax, [byte esp+068h]
        call ReadTeamNames
        mov ebp, eax
.6:
        test esi, esi
        jne near TradePlayers.1
        test ebp, ebp
        jne near .19
        mov ebx, dword [leaguedbnames+18h]
        mov ecx, str_extDB
        mov edx, curleague
        lea eax, [byte esp+068h]
        call MakePath
        lea edx, [dword esp+0B8h]
        lea eax, [byte esp+068h]
        call FileOpenRW
        mov ebp, eax
        test eax, eax
        jne short .7
        mov ecx, 2
        xor ebx, ebx
        lea edx, [dword esp+0D4h]
        mov eax, dword [dword esp+0B8h]
        call FileReadAt
        mov ebp, eax
.7:
        test ebp, ebp
        jne short .8
        cmp word [dword esp+0D4h], 4ADh
        jge short .8
        mov ebx, dword [dword esp+0D2h]
        sar ebx, 10h
        lea edx, [dword esp+0A0h]
        mov eax, dword [dword esp+0B8h]
        call ReadSchedGame
        mov ebp, eax
.8:
        lea eax, [dword esp+0B8h]
        call FileClose
        test ebp, ebp
        jne near .12
        cmp byte [dword esp+0A0h], 3
        jne short .9
        cmp byte [dword esp+0A1h], 16h
        jae short .11
.9:
        mov cl, byte [dword esp+0A0h]
        cmp cl, 3
        jbe short .10
        cmp cl, 0Ah
        jb short .11
.10:
        cmp word [dword esp+0D4h], 444h
        jl near .12
.11:
        lea eax, [dword esp+0B0h]
        push eax
        lea eax, [dword esp+0B8h]
        push eax
        lea eax, [dword esp+0B0h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push dword 0F7h
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        lea eax, [dword esp+0B0h]
        push eax
        lea eax, [dword esp+0B8h]
        push eax
        lea eax, [dword esp+0B0h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0B4h]
        push eax
        lea eax, [dword esp+0BCh]
        push eax
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msg_TradeDeadline
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov ebp, 0FFFFFFFFh
.12:
        test ebp, ebp
        jne near .19
        cmp dword [humancount], byte 1
        jne short .13
        push dword 0F7h
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        lea eax, [dword esp+0B0h]
        push eax
        lea eax, [dword esp+0B8h]
        push eax
        lea eax, [dword esp+0B0h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0B4h]
        push eax
        lea eax, [dword esp+0BCh]
        push eax
        push ebp
        push ebp
        mov ecx, 2
        mov ebx, msg_OneHuman
        jmp near .18
.13:
        lea eax, [dword esp+098h]
        push eax
        push str_SelTradeTeams
        push byte 10h
        mov ecx, leagueteams
        mov ebx, treeteamnames
        mov edx, humancount
        mov eax, curleague
        call LeagueTeamSelect
        mov esi, dword [dword esp+098h]
        test esi, esi
        jl near .17
        cmp dword [dword esp+09Ch], byte 0
        jl near .17
        mov edx, leagueteams
        mov eax, esi
        call AskTeamPassword
        test eax, eax
        jne short .14
        mov edx, leagueteams
        mov eax, dword [dword esp+09Ch]
        call AskTeamPassword
.14:
        test eax, eax
        jne near .16
        mov edi, esp
        mov esi, str_Show
        movsd
        movsw
        mov edx, dword [dword esp+098h]
        mov edx, dword [nosplit edx*4+teamcitynames]
        mov eax, esp
        call strcat_
        mov edx, str_Statistics
        mov eax, esp
        call strcat_
        mov eax, esp
        mov dword [menutext_trade1], eax
        lea edi, [byte esp+034h]
        mov esi, str_Show
        movsd
        movsw
        mov eax, dword [dword esp+09Ch]
        mov edx, dword [nosplit eax*4+teamcitynames]
        lea eax, [byte esp+034h]
        call strcat_
        mov edx, str_Statistics
        lea eax, [byte esp+034h]
        call strcat_
        lea eax, [byte esp+034h]
        mov dword [menutext_trade2], eax
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        mov dword [dword esp+0B4h], eax
        lea eax, [byte esp+034h]
        push eax
        call fputchar
        add esp, byte 4
        mov dword [dword esp+0B0h], eax
        mov edx, dword [dword esp+0B4h]
        cmp eax, edx
        jge short .15
        mov eax, edx
.15:
        add eax, byte 6
        mov dword [menuwidth_trade2], eax
        mov dword [menuwidth_trade1], eax
        push byte 3
        mov ecx, btn_TradeStats
        lea ebx, [dword esp+0B0h]
        lea edx, [dword esp+09Ch]
        mov eax, curleague
        call TradeScreen
.16:
        test eax, eax
        jne short .17
        lea ebx, [dword esp+0ACh]
        lea edx, [dword esp+098h]
        mov eax, curleague
        call ExecuteTrade
        mov ebp, eax
.17:
        test ebp, ebp
        je short .19
        lea eax, [dword esp+0B0h]
        push eax
        lea eax, [dword esp+0B8h]
        push eax
        lea eax, [dword esp+0B0h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0B4h]
        push eax
        lea eax, [dword esp+0BCh]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, msg_TradeError
.18:
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.19:
        mov eax, dword [dword esp+0BCh]
        mov dword [dlgfillcol], eax
        mov eax, dword [dword esp+0CCh]
        mov dword [dlgedgecol1], eax
        mov eax, dword [dword esp+0C8h]
        mov dword [dlgedgecol2], eax
        mov eax, dword [dword esp+0C4h]
        mov dword [dlgedgecol3], eax
        mov eax, dword [dword esp+0C0h]
        mov dword [dlgbevelcol1], eax
        mov eax, dword [dword esp+0D0h]
        mov dword [dlgbevelcol2], eax
        mov ebx, dword [tradebitmap]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        add esp, 0D8h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; LoadHomePals                                 40792  95 PC, medium confidence
; Unreferenced: opens HOMEPALS.BIN (palette dir when byte_ED86D), copies
; 1C0h-byte records for two teams (C0h to a local palette, 100h to homeremap
; / 90h+70h(+40h) to awayremap) and sets 80h colours with VgaSetPalette
;-----------------------------------------------------------------------------
; C: src/front/trade/LoadHomePals.c
%ifdef CBUILD
%include "c/front/trade/LoadHomePals.inc"
%else
LoadHomePals:
        push dword 1B0h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, 190h
        mov esi, eax
        mov edi, edx
        mov ecx, str_extBIN
        mov ebx, str_HOMEPALS
        cmp byte [fileoncd+0A1h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0180h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0184h]
        push eax
        call OpenArtArchiveErr
        mov edx, eax
        add esp, byte 8
        mov ecx, eax
        mov eax, esi
        shl eax, 3
        sub eax, esi
        shl eax, 6
        add edx, eax
        xor eax, eax
.3:
        mov bl, byte [edx+eax]
        mov byte [esp+eax], bl
        inc eax
        cmp eax, 0C0h
        jl short LoadHomePals.3
        xor eax, eax
        add edx, 0C0h
.4:
        mov bl, byte [edx+eax]
        mov byte [dword eax+homeremap], bl
        inc eax
        cmp eax, 100h
        jl short LoadHomePals.4
        mov eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 6
        lea edx, [ecx+eax]
        xor eax, eax
.5:
        mov bl, byte [edx+eax]
        mov byte [dword esp+eax+0C0h], bl
        inc eax
        cmp eax, 0C0h
        jl short LoadHomePals.5
        xor eax, eax
        add edx, 0C0h
.6:
        mov bl, byte [edx+eax]
        mov byte [dword eax+awayremap], bl
        inc eax
        cmp eax, 90h
        jl short LoadHomePals.6
        mov eax, 90h
.7:
        mov bl, byte [edx+eax]
        add bl, 40h
        mov byte [dword eax+awayremap], bl
        inc eax
        cmp eax, 100h
        jl short LoadHomePals.7
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov byte [dword esp+0171h], 18h
        xor dh, dh
        mov byte [dword esp+0172h], dh
        mov byte [dword esp+0173h], dh
        mov byte [dword esp+0174h], 2Ah
        mov byte [dword esp+0175h], dh
        mov byte [dword esp+0176h], dh
        mov al, 3Bh
        mov byte [dword esp+0177h], al
        mov byte [dword esp+0178h], 12h
        mov byte [dword esp+0179h], dh
        mov byte [dword esp+017Ah], al
        mov byte [dword esp+017Bh], al
        mov byte [dword esp+017Ch], al
        mov eax, esp
        push eax
        push dword 80h
        push dword 80h
        call VgaSetPalette
        add esp, byte 0Ch
        add esp, 190h
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
