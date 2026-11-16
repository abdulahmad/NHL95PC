; The league databases. The Central Registry menu, the free agent and roster lists, loading, saving and
; freeing the databases in memory, and the record pointers.
bits 32
%include "hockey.inc"
section s_6BE95 progbits alloc exec nowrite align=1
extern __CHK, _dos_getdiskfree_, addtimer, attdb, attdb_size, boxfillcolor, boxlitecolor, boxshadecolor
extern btn_LeagueExists, JoyPortMask, byte_D42C3, careerdb, careerdb_size, carteamsdb, carteamsdb_size, CheckDatabases
extern ctlavailmask, curdbname, dbdirty, dbexistsmsg, DeleteDir, dlgtextbg, dlgtextfg, DrawButtons
extern DrawEditRosters, DrawScrollBar, dword_C4CFC, dword_C71E0, cursndbank, dword_CDA24, dword_CDA38, rostereditmode
extern fascrollbar_len, fascrollbar_thumb, fascrollbar_top, fascrollbar_count, dword_D0C20, dword_EA2B0, falisttop, editptrspr
extern EditRosters, editrosters_exit, enterheld, facount, FadePalStep, falist, falistsel, FatalError
extern FitPlayerName, fputchar, FreeMemBlock, fullscrbmp, InitSpeechSlots, inputev, inputinstalled, inputpolldiv
extern inputqcount, inputqhead, inputqtail, inputqueue, inputrepeat, joybtnheld, joycalactive, joycalposthook
extern joycalprehook, joycalx, joycaly, joyenablemask, keydb, keydb_size, lastinputdir, lastmousebtns
extern lastmousex, lastmousey, leaguedbnames, mainfont, MakePath, memcpy_, memset_, MessageBox
extern mkdir_, mousebtns, mousepollfn, MouseSetPos, mousex, mousey, msglines, musichandle
extern musicon, musicslot, nodiskspacemsg, pointerspr, PollKey, PrintCenteredText, PrintShadowText, ptrstep
extern ptrupdatefn, RemoveTimerCallback, RestoreDialogBg, rmdir_, rosterisfa, rosterjersey, rosterlist, rostersel
extern rosterteamptr, RunEditRosters, savedbbtns, scrpitch, seasondb, seasondb_size, SetTextColors, songdata
extern speechbank, sprintf_, str_3dKbytesOfFree2, str_C4, str_Current2, str_Current3, str_DATABASE, str_DBX
extern str_dot, str_EnterANewDatabase, str_ErrorGettingDiskSpace, str_extDB, str_fmt2d, str_FreeAgents, str_Joycal, str_Left
extern str_LEFTJOYSTICK, str_Pal24, str_Pointer11, str_Puck, str_PuckBack, str_RIGHTJOYSTICK, str_Rite, str_S5
extern str_SaveAsGameDatabases, str_SavingDatabases, str_Scrn3, str_space, str_Temp7, str_XXXKbytesOfFree2, strcat_, strcpy_
extern strlen_, strupr_, AllocMemBlock, PushMemDescriptorLocked, LoadBank, OpenArtArchiveErr, TextSetColors, TextSaveState
extern TextRestoreState, TextSetFont, SndQuery, SetDigiChannelVolume, SetPalette, FillRect, XorBar, DrawArtOpaque
extern DrawArtOpaqueAtOwnPos, DrawArt, DrawShape, GrabBlock, PrintString, TextPrintAt, GetFileSize, WriteFile
extern InstallKeyboardHandler, KeyDown, InitMouse, FindShape, CalibrateJoystick, JoyButtonMap, ReadJoyRaw, JoyDefaultCalib1
extern JoyDefaultCalib2, ClearScreen, KbdGetKey, VgaSetPalette, SetScreenTarget, WaitRetraceStart, CreateBitmap, FillRectColor
extern teamsdb, teamsdb_size, TextInputDialog, unk_C27F5, editrostersmenubar, btn_RosterList, fascrollbar, DefaultFont
extern _dos_findfirst_
global MenuCentralRegistry, unk13_6BF3D, BuildFreeAgentList, BuildFreeAgentList_ret, BuildTeamRosterList, LoadLeagueDbsMem, MenuSaveDbs, MenuSaveDbsAs
global SaveDbsToDir, WriteLeagueDbsMem, FreeLeagueDbsMem, CarTeamRecPtr, TeamRecPtr, KeyDbPtr, SeasonDbPtr, SeasonDbPtr_common
global SeasonDbPtr2, CareerDbPtr, CareerDbPtr_common, CareerDbPtr2, AttDbPtr
;-----------------------------------------------------------------------------
; MenuCentralRegistry                          6BE95  95 PC, medium confidence
; "Central Registry ..." menu action: music cue, restores pitch, frees the
; free-agent lists (falist / falistsel), returns 2
;-----------------------------------------------------------------------------
; C: src/pc/league_db/MenuCentralRegistry.c
%ifdef CBUILD
%include "c/pc/league_db/MenuCentralRegistry.inc"
%else
MenuCentralRegistry:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        cmp byte [musicon], 0
        je short .1
        mov eax, dword [speechbank]
        mov edx, dword [dword eax+03B60h]
        push edx
        call PushMemDescriptorLocked
        add esp, byte 4
.1:
        mov dword [scrpitch], 0A0h
        xor ecx, ecx
        mov dword [dword_C71E0], ecx
        call RunEditRosters
        mov esi, dword [falistsel]
        test esi, esi
        je short .2
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ebp, ebp
        mov dword [falistsel], ebp
.2:
        mov eax, dword [falist]
        test eax, eax
        je short .3
        push eax
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [falist], ebx
.3:
        cmp byte [musicon], 0
        je short .4
        mov dword [cursndbank], 20h
        mov eax, dword [dword_C4CFC]
        call InitSpeechSlots
        xor esi, esi
        mov dword [cursndbank], esi
.4:
        mov eax, 2
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
unk13_6BF3D:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; BuildFreeAgentList                                              6BF4A  95 PC
; Falist entries (1Bh bytes: position, jersey, index, "F. Lastname") for KEY
; records with team 0FFh, up to facount
;-----------------------------------------------------------------------------
; C: src/pc/league_db/BuildFreeAgentList.c
%ifdef CBUILD
%include "c/pc/league_db/BuildFreeAgentList.inc"
%else
BuildFreeAgentList:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ebx, 34h
        xor edx, edx
        mov eax, dword [keydb_size]
        div ebx
        mov dword [esp], eax
        xor ebx, ebx
        xor esi, esi
        jmp near .3
.1:
        mov edi, esi
        shl edi, 2
        sub edi, esi
        shl edi, 2
        add edi, esi
        shl edi, 2
        mov edx, dword [keydb]
        add edx, edi
        cmp byte [edx], 0FFh
        jne near .2
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        mov ecx, dword [falist]
        mov byte [byte ecx+eax+02h], bl
        mov ebp, dword [falist]
        mov cl, byte [byte edx+02h]
        mov byte [eax+ebp], cl
        mov ebp, dword [falist]
        mov cl, byte [byte edx+01h]
        mov byte [byte eax+ebp+01h], cl
        mov ecx, dword [falist]
        mov byte [byte ecx+eax+03h], 3
        mov ecx, dword [falist]
        mov dword [byte ecx+eax+04h], edi
        mov edi, dword [falist]
        mov cl, byte [byte edx+03h]
        mov byte [byte edi+eax+08h], cl
        mov edi, dword [falist]
        mov cl, byte [str_dot]
        mov byte [byte edi+eax+09h], cl
        mov edi, dword [falist]
        mov cl, byte [str_space]
        mov byte [byte edi+eax+0Ah], cl
        mov ecx, dword [falist]
        mov byte [byte ecx+eax+0Bh], 0
        add edx, byte 13h
        mov ecx, dword [falist]
        add eax, ecx
        add eax, byte 8
        call strcat_
        inc ebx
.2:
        inc esi
.3:
        cmp esi, dword [esp]
        jge short .4
        cmp ebx, dword [facount]
        jl near BuildFreeAgentList.1
.4:
        add esp, byte 4
BuildFreeAgentList_ret:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; BuildTeamRosterList                                             6C043  95 PC
; (team, entries, teamrec*): 28 roster entries from the in-memory TEAMS / KEY
; DBs, entries in teamrec+0E4h flagged 2
;-----------------------------------------------------------------------------
; C: src/pc/league_db/BuildTeamRosterList.c
%ifdef CBUILD
%include "c/pc/league_db/BuildTeamRosterList.inc"
%else
BuildTeamRosterList:
        push dword 14h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov esi, eax
        mov ebp, edx
        mov edi, ebx
        xor ebx, ebx
.1:
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        mov byte [byte edx+ebp+02h], bl
        inc ebx
        cmp ebx, byte 1Ch
        jl short BuildTeamRosterList.1
        mov eax, esi
        call TeamRecPtr
        mov dword [edi], eax
        xor ebx, ebx
.2:
        mov eax, dword [edi]
        mov ecx, ebx
        mov ecx, dword [byte eax+ecx*4+04Ch]
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        add edx, ebp
        cmp ecx, byte 0FFFFFFFFh
        jne short .3
        mov byte [edx], 0
        mov byte [byte edx+01h], 64h
        mov byte [byte edx+02h], 0
        mov byte [byte edx+03h], 0
        jmp short .4
.3:
        mov eax, ecx
        call KeyDbPtr
        mov esi, eax
        mov al, byte [byte eax+02h]
        mov byte [edx], al
        mov al, byte [byte esi+01h]
        mov byte [byte edx+01h], al
        mov byte [byte edx+03h], 3
        mov dword [byte edx+04h], ecx
        mov al, byte [byte esi+03h]
        mov byte [byte edx+08h], al
        mov al, byte [str_dot]
        mov byte [byte edx+09h], al
        mov al, byte [str_space]
        mov byte [byte edx+0Ah], al
        mov byte [byte edx+0Bh], 0
        add esi, byte 13h
        lea eax, [byte edx+08h]
        mov edx, esi
        call strcat_
.4:
        inc ebx
        cmp ebx, byte 19h
        jl short BuildTeamRosterList.2
        xor ebx, ebx
.5:
        mov ecx, dword [edi]
        mov eax, ebx
        mov ecx, dword [dword ecx+eax*4+0B0h]
        lea esi, [byte ebx+019h]
        mov edx, esi
        shl edx, 3
        sub edx, esi
        shl edx, 2
        sub edx, esi
        add edx, ebp
        cmp ecx, byte 0FFFFFFFFh
        jne short .6
        mov byte [edx], 0
        mov byte [byte edx+01h], 64h
        mov byte [byte edx+02h], 0
        mov byte [byte edx+03h], 0
        jmp short .7
.6:
        mov eax, ecx
        call KeyDbPtr
        mov esi, eax
        mov al, byte [byte eax+02h]
        mov byte [edx], al
        mov al, byte [byte esi+01h]
        mov byte [byte edx+01h], al
        mov byte [byte edx+03h], 3
        mov dword [byte edx+04h], ecx
        mov al, byte [byte esi+03h]
        mov byte [byte edx+08h], al
        mov al, byte [str_dot]
        mov byte [byte edx+09h], al
        mov al, byte [str_space]
        mov byte [byte edx+0Ah], al
        mov byte [byte edx+0Bh], 0
        add esi, byte 13h
        lea eax, [byte edx+08h]
        mov edx, esi
        call strcat_
.7:
        inc ebx
        cmp ebx, byte 3
        jl short BuildTeamRosterList.5
        xor ebx, ebx
.8:
        mov edx, dword [edi]
        add edx, ebx
        mov ah, byte [dword edx+0E4h]
        cmp ah, 64h
        je short .9
        xor ecx, ecx
        mov cl, ah
        mov edx, ecx
        shl edx, 3
        sub edx, ecx
        shl edx, 2
        sub edx, ecx
        mov byte [byte edx+ebp+03h], 2
.9:
        inc ebx
        cmp ebx, byte 8
        jl short BuildTeamRosterList.8
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadLeagueDbsMem                                                6C19B  95 PC
; (dir): loads SEASON, CAREER, CARTEAMS, KEY, TEAMS and ATT .DB files into
; memory (seasondb, careerdb, ...) with sizes
;-----------------------------------------------------------------------------
; C: src/pc/league_db/LoadLeagueDbsMem.c
%ifdef CBUILD
%include "c/pc/league_db/LoadLeagueDbsMem.inc"
%else
LoadLeagueDbsMem:
        push dword 3Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 20h
        mov esi, eax
        call FreeLeagueDbsMem
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, esi
        xor edx, edx
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
        xor edx, edx
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
        xor edx, edx
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
        xor edx, edx
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
        xor edx, edx
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
        xor edx, edx
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
        add esp, byte 20h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuSaveDbs                                                     6C2F9  95 PC
; Edit Rosters menu "Save": "Save as game databases?", CheckDatabases,
; "Saving databases." into "Current" (SaveDbsToDir)
;-----------------------------------------------------------------------------
; C: src/pc/league_db/MenuSaveDbs.c
%ifdef CBUILD
%include "c/pc/league_db/MenuSaveDbs.inc"
%else
MenuSaveDbs:
        push dword 3Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        push edx
        mov ebp, ebx
        lea edi, [byte esp+04h]
        mov esi, unk13_6BF3D
        movsd
        movsd
        movsd
        movsb
        mov dword [msglines], str_SaveAsGameDatabases
        push byte 0FFFFFFFFh
        push ebx
        mov ebx, dword [byte esp+08h]
        push ebx
        push byte 2
        push savedbbtns
        mov ecx, 1
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        cmp eax, byte 1
        jne short .x
        mov edx, ebp
        mov eax, dword [esp]
        call CheckDatabases
        mov edx, eax
        call DrawEditRosters
        test edx, edx
        je short .x
        mov edi, curdbname
        mov esi, str_Current2
        movsd
        movsd
        mov dword [msglines], str_SavingDatabases
        push byte 0
        push ebp
        mov esi, dword [byte esp+08h]
        push esi
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov edx, str_extDB
        lea eax, [byte esp+04h]
        call SaveDbsToDir
        call RestoreDialogBg
        call DrawEditRosters
.x:
        add esp, byte 14h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuSaveDbsAs                                                   6C3BB  95 PC
; Edit Rosters menu "Save As": "Enter a new database name:" (.DBX dir),
; "There is already a database with that name! Do you want to replace it?",
; mkdir, SaveDbsToDir
;-----------------------------------------------------------------------------
; C: src/pc/league_db/MenuSaveDbsAs.c
%ifdef CBUILD
%include "c/pc/league_db/MenuSaveDbsAs.inc"
%else
MenuSaveDbsAs:
        push dword 78h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 50h
        mov edi, edx
        mov ebp, ebx
        xor esi, esi
        mov dword [byte esp+04Ch], esi
        push byte 5
        push esi
        push esi
        push esi
        push esi
        mov ecx, 30h
        mov ebx, 8
        lea edx, [byte esp+050h]
        mov eax, str_EnterANewDatabase
        call TextInputDialog
        cmp byte [byte esp+03Ch], 0
        je near .x
        cmp eax, byte 1Bh
        je near .x
        lea edx, [byte esp+03Ch]
        lea eax, [byte esp+02Ch]
        call strcpy_
        mov edx, str_DBX
        lea eax, [byte esp+03Ch]
        call strcat_
        mov ebx, esp
        mov edx, 10h
        lea eax, [byte esp+03Ch]
        call _dos_findfirst_
        test eax, eax
        sete al
        and eax, 0FFh
        je short .2
        push byte 0FFFFFFFFh
        push ebp
        push edi
        push byte 2
        push btn_LeagueExists
        mov ecx, 2
        mov ebx, dbexistsmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        cmp eax, byte 1
        jne short .1
        lea eax, [byte esp+03Ch]
        call DeleteDir
        jmp short .2
.1:
        mov esi, 1
.2:
        test esi, esi
        jne short .3
        lea eax, [byte esp+03Ch]
        call mkdir_
        mov dword [byte esp+04Ch], eax
.3:
        test esi, esi
        jne short .x
        cmp dword [byte esp+04Ch], byte 0
        jne short .x
        lea edx, [byte esp+02Ch]
        mov eax, curdbname
        call strcpy_
        mov edx, str_extDB
        lea eax, [byte esp+03Ch]
        call SaveDbsToDir
        call DrawEditRosters
.x:
        add esp, byte 50h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SaveDbsToDir                                 6C4BA  95 PC, medium confidence
; (dir, ext): sums the old file sizes (KB) against the in-memory DB sizes and
; the free disk space ("Insufficient disk space available ... XXX Kbytes"),
; then writes the DBs (WriteLeagueDbsMem); rmdir on failure
;-----------------------------------------------------------------------------
; C: src/pc/league_db/SaveDbsToDir.c
%ifdef CBUILD
%include "c/pc/league_db/SaveDbsToDir.inc"
%else
SaveDbsToDir:
        push dword 0CCh
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 0A0h
        mov ebp, eax
        mov dword [dword esp+09Ch], edx
        lea edx, [dword esp+08Ch]
        xor eax, eax
        call _dos_getdiskfree_
        test eax, eax
        je short .1
        push str_ErrorGettingDiskSpace
        call FatalError
        add esp, byte 4
.1:
        xor esi, esi
        mov si, word [dword esp+090h]
        xor eax, eax
        mov ax, word [dword esp+092h]
        imul esi, eax
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, dword [dword esp+09Ch]
        mov edx, ebp
        lea eax, [byte esp+02Ch]
        call MakePath
        mov ebx, esp
        xor edx, edx
        lea eax, [byte esp+02Ch]
        call _dos_findfirst_
        test eax, eax
        je short .2
        xor edx, edx
        mov dword [byte esp+04Ch], edx
        jmp short .3
.2:
        mov eax, dword [byte esp+01Ah]
        add eax, 3FFh
        shr eax, 0Ah
        mov dword [byte esp+04Ch], eax
.3:
        mov ebx, dword [leaguedbnames+4]
        mov ecx, dword [dword esp+09Ch]
        mov edx, ebp
        lea eax, [byte esp+02Ch]
        call MakePath
        mov ebx, esp
        xor edx, edx
        lea eax, [byte esp+02Ch]
        call _dos_findfirst_
        test eax, eax
        je short .4
        xor ebx, ebx
        mov dword [byte esp+050h], ebx
        jmp short .5
.4:
        mov eax, dword [byte esp+01Ah]
        add eax, 3FFh
        shr eax, 0Ah
        mov dword [byte esp+050h], eax
.5:
        mov ebx, dword [leaguedbnames+0Ch]
        mov ecx, dword [dword esp+09Ch]
        mov edx, ebp
        lea eax, [byte esp+02Ch]
        call MakePath
        mov ebx, esp
        xor edx, edx
        lea eax, [byte esp+02Ch]
        call _dos_findfirst_
        test eax, eax
        je short .6
        xor ecx, ecx
        mov dword [byte esp+054h], ecx
        jmp short .7
.6:
        mov eax, dword [byte esp+01Ah]
        add eax, 3FFh
        shr eax, 0Ah
        mov dword [byte esp+054h], eax
.7:
        mov ebx, dword [leaguedbnames]
        mov ecx, dword [dword esp+09Ch]
        mov edx, ebp
        lea eax, [byte esp+02Ch]
        call MakePath
        mov ebx, esp
        xor edx, edx
        lea eax, [byte esp+02Ch]
        call _dos_findfirst_
        test eax, eax
        je short .8
        xor edi, edi
        mov dword [byte esp+058h], edi
        jmp short .9
.8:
        mov eax, dword [byte esp+01Ah]
        add eax, 3FFh
        shr eax, 0Ah
        mov dword [byte esp+058h], eax
.9:
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, dword [dword esp+09Ch]
        mov edx, ebp
        lea eax, [byte esp+02Ch]
        call MakePath
        mov ebx, esp
        xor edx, edx
        lea eax, [byte esp+02Ch]
        call _dos_findfirst_
        test eax, eax
        je short .10
        xor eax, eax
        jmp short .11
.10:
        mov eax, dword [byte esp+01Ah]
        add eax, 3FFh
        shr eax, 0Ah
.11:
        mov dword [byte esp+05Ch], eax
        mov ebx, dword [leaguedbnames+8]
        mov ecx, dword [dword esp+09Ch]
        mov edx, ebp
        lea eax, [byte esp+02Ch]
        call MakePath
        mov ebx, esp
        xor edx, edx
        lea eax, [byte esp+02Ch]
        call _dos_findfirst_
        test eax, eax
        je short .12
        xor edx, edx
        mov dword [byte esp+060h], edx
        jmp short .13
.12:
        mov eax, dword [byte esp+01Ah]
        add eax, 3FFh
        shr eax, 0Ah
        mov dword [byte esp+060h], eax
.13:
        mov edx, dword [seasondb_size]
        add edx, 3FFh
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        mov dword [byte esp+06Ch], eax
        mov edx, dword [careerdb_size]
        add edx, 3FFh
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        mov dword [byte esp+070h], eax
        mov edx, dword [carteamsdb_size]
        add edx, 3FFh
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        mov dword [byte esp+074h], eax
        mov edx, dword [keydb_size]
        add edx, 3FFh
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        mov dword [byte esp+078h], eax
        mov edx, dword [teamsdb_size]
        add edx, 3FFh
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        mov dword [byte esp+07Ch], eax
        mov edx, dword [attdb_size]
        add edx, 3FFh
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        mov dword [dword esp+080h], eax
        xor ebx, ebx
        mov dword [dword esp+084h], ebx
        xor edi, edi
.14:
        mov edx, dword [byte esp+ebx*4+06Ch]
        add edx, esi
        dec edx
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        add edi, eax
        mov edx, dword [byte esp+ebx*4+04Ch]
        add edx, esi
        dec edx
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        sub edi, eax
        inc ebx
        cmp ebx, byte 6
        jl short SaveDbsToDir.14
        xor eax, eax
        mov ax, word [dword esp+08Eh]
        cmp edi, eax
        jle near .16
        mov eax, 140h
        mov dword [dword esp+098h], eax
        mov edx, 0F0h
        mov dword [dword esp+094h], edx
        push edx
        push eax
        call MouseSetPos
        add esp, byte 8
        xor ebx, ebx
.15:
        mov edx, dword [byte esp+ebx*4+06Ch]
        add edx, esi
        dec edx
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        add edi, eax
        inc ebx
        cmp ebx, byte 6
        jl short SaveDbsToDir.15
        mov edx, edi
        imul edx, esi
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        push eax
        push str_3dKbytesOfFree2
        push str_XXXKbytesOfFree2
        call sprintf_
        add esp, byte 0Ch
        push dword 320h
        lea eax, [dword esp+098h]
        push eax
        lea eax, [dword esp+0A0h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, nodiskspacemsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        cmp byte [byte ebp+00h], 0
        je near .x
        mov eax, ebp
        call rmdir_
        jmp near .x
.16:
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, dword [dword esp+09Ch]
        mov edx, ebp
        lea eax, [byte esp+02Ch]
        call MakePath
        mov ecx, dword [seasondb_size]
        push ecx
        mov esi, dword [seasondb]
        push esi
        lea eax, [byte esp+034h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        mov ebx, dword [leaguedbnames+4]
        mov ecx, dword [dword esp+09Ch]
        mov edx, ebp
        lea eax, [byte esp+02Ch]
        call MakePath
        mov edi, dword [careerdb_size]
        push edi
        mov eax, dword [careerdb]
        push eax
        lea eax, [byte esp+034h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        mov ebx, dword [leaguedbnames+0Ch]
        mov ecx, dword [dword esp+09Ch]
        mov edx, ebp
        lea eax, [byte esp+02Ch]
        call MakePath
        mov edx, dword [carteamsdb_size]
        push edx
        mov ebx, dword [carteamsdb]
        push ebx
        lea eax, [byte esp+034h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        mov ebx, dword [leaguedbnames]
        mov ecx, dword [dword esp+09Ch]
        mov edx, ebp
        lea eax, [byte esp+02Ch]
        call MakePath
        mov ecx, dword [keydb_size]
        push ecx
        mov esi, dword [keydb]
        push esi
        lea eax, [byte esp+034h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, dword [dword esp+09Ch]
        mov edx, ebp
        lea eax, [byte esp+02Ch]
        call MakePath
        mov edi, dword [teamsdb_size]
        push edi
        mov eax, dword [teamsdb]
        push eax
        lea eax, [byte esp+034h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        mov ebx, dword [leaguedbnames+8]
        mov ecx, dword [dword esp+09Ch]
        mov edx, ebp
        lea eax, [byte esp+02Ch]
        call MakePath
        mov edx, dword [attdb_size]
        push edx
        mov ebx, dword [attdb]
        push ebx
        lea eax, [byte esp+034h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [dbdirty], ecx
.x:
        add esp, 0A0h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; WriteLeagueDbsMem                                               6C96C  95 PC
; (dir): writes SEASON, CAREER, CARTEAMS, KEY, TEAMS and ATT from memory
; (pair of LoadLeagueDbsMem)
;-----------------------------------------------------------------------------
; C: src/pc/league_db/BuildFreeAgentList.c (WriteLeagueDbsMem)
%ifdef CBUILD
%include "c/pc/league_db/BuildFreeAgentList.WriteLeagueDbsMem.inc"
%else
WriteLeagueDbsMem:
        push dword 48h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 20h
        mov esi, eax
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, eax
        xor edx, edx
        mov eax, esp
        call MakePath
        mov edx, dword [seasondb_size]
        push edx
        mov ebx, dword [seasondb]
        push ebx
        lea eax, [byte esp+08h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        mov ebx, dword [leaguedbnames+4]
        mov ecx, esi
        xor edx, edx
        mov eax, esp
        call MakePath
        mov ecx, dword [careerdb_size]
        push ecx
        mov edi, dword [careerdb]
        push edi
        lea eax, [byte esp+08h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        mov ebx, dword [leaguedbnames+0Ch]
        mov ecx, esi
        xor edx, edx
        mov eax, esp
        call MakePath
        mov ebp, dword [carteamsdb_size]
        push ebp
        mov eax, dword [carteamsdb]
        push eax
        lea eax, [byte esp+08h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        mov ebx, dword [leaguedbnames]
        mov ecx, esi
        xor edx, edx
        mov eax, esp
        call MakePath
        mov edx, dword [keydb_size]
        push edx
        mov ebx, dword [keydb]
        push ebx
        lea eax, [byte esp+08h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, esi
        xor edx, edx
        mov eax, esp
        call MakePath
        mov ecx, dword [teamsdb_size]
        push ecx
        mov edi, dword [teamsdb]
        push edi
        lea eax, [byte esp+08h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        mov ebx, dword [leaguedbnames+8]
        mov ecx, esi
        xor edx, edx
        mov eax, esp
        call MakePath
        mov ebp, dword [attdb_size]
        push ebp
        mov eax, dword [attdb]
        push eax
        lea eax, [byte esp+08h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        add esp, byte 20h
        jmp near BuildFreeAgentList_ret
%endif ; C
;-----------------------------------------------------------------------------
; FreeLeagueDbsMem                                                6CA8F  95 PC
; Frees the six in-memory DBs
;-----------------------------------------------------------------------------
; C: src/pc/league_db/BuildFreeAgentList.c (FreeLeagueDbsMem)
%ifdef CBUILD
%include "c/pc/league_db/BuildFreeAgentList.FreeLeagueDbsMem.inc"
%else
FreeLeagueDbsMem:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov edx, dword [attdb]
        test edx, edx
        je short .1
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [attdb], ecx
        mov dword [attdb_size], ecx
.1:
        mov edi, dword [teamsdb]
        test edi, edi
        je short .2
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [teamsdb], eax
        mov dword [teamsdb_size], eax
.2:
        mov ebx, dword [keydb]
        test ebx, ebx
        je short .3
        push ebx
        call FreeMemBlock
        add esp, byte 4
        xor esi, esi
        mov dword [keydb], esi
        mov dword [keydb_size], esi
.3:
        mov ebp, dword [carteamsdb]
        test ebp, ebp
        je short .4
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor edx, edx
        mov dword [carteamsdb], edx
        mov dword [carteamsdb_size], edx
.4:
        mov ecx, dword [careerdb]
        test ecx, ecx
        je short .5
        push ecx
        call FreeMemBlock
        add esp, byte 4
        xor edi, edi
        mov dword [careerdb], edi
        mov dword [careerdb_size], edi
.5:
        mov eax, dword [seasondb]
        test eax, eax
        je near BuildFreeAgentList_ret
        push eax
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [seasondb], ebx
        mov dword [seasondb_size], ebx
        jmp near BuildFreeAgentList_ret
%endif ; C
;-----------------------------------------------------------------------------
; CarTeamRecPtr                                                   6CB6B  95 PC
; Returns carteamsdb + team * 4Ch
;-----------------------------------------------------------------------------
; C: src/pc/league_db/CarTeamRecPtr.c
%ifdef CBUILD
%include "c/pc/league_db/CarTeamRecPtr.inc"
%else
CarTeamRecPtr:
        push dword 8
        call __CHK
        push edx
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        shl edx, 2
        mov eax, dword [carteamsdb]
        add eax, edx
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TeamRecPtr                                                      6CB90  95 PC
; Returns teamsdb + team * 2E8h
;-----------------------------------------------------------------------------
; C: src/pc/league_db/TeamRecPtr.c
%ifdef CBUILD
%include "c/pc/league_db/TeamRecPtr.inc"
%else
TeamRecPtr:
        push dword 8
        call __CHK
        push edx
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov edx, eax
        mov eax, dword [teamsdb]
        add eax, edx
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; KeyDbPtr                                                        6CBB7  95 PC
; Returns keydb + offset (player entry pointer into KEY.DB)
;-----------------------------------------------------------------------------
; C: src/pc/league_db/KeyDbPtr.c
%ifdef CBUILD
%include "c/pc/league_db/KeyDbPtr.inc"
%else
KeyDbPtr:
        push dword 8
        call __CHK
        push edx
        mov edx, dword [keydb]
        add eax, edx
        pop edx
        ret
;-----------------------------------------------------------------------------
; SeasonDbPtr                                  6CBCC  95 PC, medium confidence
; Seasondb + offset
;-----------------------------------------------------------------------------
SeasonDbPtr:
        push dword 8
SeasonDbPtr_common:
        call __CHK
        push edx
        mov edx, dword [seasondb]
        add eax, edx
        pop edx
        ret
;-----------------------------------------------------------------------------
; SeasonDbPtr2                                 6CBE1  95 PC, medium confidence
; Second entry with the same body (SimulateGame goalie path)
;-----------------------------------------------------------------------------
SeasonDbPtr2:
        push dword 8
        jmp short SeasonDbPtr_common
;-----------------------------------------------------------------------------
; CareerDbPtr                                  6CBE8  95 PC, medium confidence
; Careerdb + offset
;-----------------------------------------------------------------------------
CareerDbPtr:
        push dword 8
CareerDbPtr_common:
        call __CHK
        push edx
        mov edx, dword [careerdb]
        add eax, edx
        pop edx
        ret
;-----------------------------------------------------------------------------
; CareerDbPtr2                                 6CBFD  95 PC, medium confidence
; Second entry with the same body
;-----------------------------------------------------------------------------
CareerDbPtr2:
        push dword 8
        jmp short CareerDbPtr_common
;-----------------------------------------------------------------------------
; AttDbPtr                                     6CC04  95 PC, medium confidence
; Attdb + offset (no direct refs; an unlabelled twin follows)
;-----------------------------------------------------------------------------
AttDbPtr:
        push dword 8
.1:
        call __CHK
        push edx
        mov edx, dword [attdb]
        add eax, edx
        pop edx
        ret
;-----------------------------------------------------------------------------
; AttDbPtr2                                                       6CC19  95 PC
; Twin of AttDbPtr (pointer ofs bytes into the attdb buffer); Watcom reduced
; it to a jump into AttDbPtr.
;-----------------------------------------------------------------------------
AttDbPtr2:
        push dword 8
        jmp short AttDbPtr.1
%endif ; C
