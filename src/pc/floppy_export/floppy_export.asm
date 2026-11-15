; Team export and import on floppy, master league import (PC only).
bits 32
%include "hockey.inc"
section s_3BB87 progbits alloc exec nowrite align=1
extern __CHK, _dos_getdiskfree_, _fstrcspn_, AskMasterPassword, btn_MasterDB, btn_WrongDisk, BuildSavedGameLabels, CopyFile
extern CopyGameSettings, CopyHumanTeamDBs, criterrflag, curleague, DeleteDir, DeleteFiles, drivebtns, exporterrmsg
extern FatalError, FileClose, FileCreate, FileExists, FileOpenRead, FileOpenRW, FileOpenWrite, FileReadAt
extern FileWriteAt, floppyok, floppyprobe, FmtFromLeague, forceexportbtns, forceexportmsg, GetLeagueId, humancount
extern importdiskmsg, importerrmsg, importmastermsg, importtypebtns, importtypemsg, insavegamemsg, insertfloppymsg, LeagueCheckStub
extern leaguedbnames, leagueflags, leaguemaster, leaguemgrmenu, leaguesaved, leagueteams, LeagueTeamSelect, lgexistsformsg
extern lgexistsmsg, lgreaderrmsg, lgstate, lgteamflags, lgteamver, lgteamver_hi, LoadModeState, MakePath
extern masterpw, menuact_export, menuact_nextlg, MenuExportDbs, MenuNextLeagueGame, menusub_lgmgr, MessageBox, mkdir_
extern MouseRead, msg_InsertDisk, msg_InsertDisk_arg, msg_SavedGame, msg_SavedGame_arg, msg_WrongDisk, msg_WrongDisk_arg, MsgCopyingDatabases
extern newfloppybtns, newfloppymsg, notexportedmsg, notforlgmsg, oldcopymsg, playerdbsmsg, ReadLeagueTeamEntry, RestoreDialogBg
extern savedname, SetDialogColors, SetupStatsSourceMenu, sprintf_, str_02d3, str_dot, str_extDB, str_extID
extern str_extxx, str_floppydrv, str_Game2, str_GAME3, str_GAME4, str_ID, str_L1, str_L22
extern str_PINFO, str_PLAYER, str_Sav2, str_SAV3, str_SelectATeamTo2, str_SET, str_SET2, str_wildcard
extern strcmp_, strcpy_, stricmp_, sub_B3CC8, treeteamnames, unknown_libname_1, updateerrmsg, UpdateTeamDbs
extern whichdrivemsg, WriteLeagueTeamEntry
global ExportTeamToFloppy, CopyLeagueFiles, ImportMasterLeague, ImportMasterLeague_ret, ImportPlayerTeam, ImportDbs, ExportDbs, SelectFloppyDrive
global FindLeagueFloppy, WaitLeagueFloppy, ReadLeagueInfo, ReadTeamNames
;-----------------------------------------------------------------------------
; ExportTeamToFloppy                           3BB87  95 PC, medium confidence
; Writes the league DBs, PINFO.DB and PLAYER.ID for one team to a floppy
; (wrong disk / "Are you sure you want to use a new floppy disk?"); "Error
; while exporting player! Player not exported!"
;-----------------------------------------------------------------------------
ExportTeamToFloppy:
        push dword 130h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 10Ch
        mov edi, eax
        mov dword [dword esp+0F8h], edx
        mov dword [dword esp+0F4h], ebx
        mov dword [dword esp+0FCh], ecx
        mov edx, 0FFFFFFFFh
        mov dword [dword esp+0D4h], edx
        mov ebx, edx
        mov dword [dword esp+0D0h], edx
        mov dword [dword esp+0E8h], edx
        mov esi, edx
        mov dword [dword esp+0CCh], edx
        mov ebp, ecx
        shl ebp, 4
        sub ebp, ecx
        add ebp, ebp
        add ebp, dword [dword esp+011Ch]
        xor esi, ebx
        cmp dword [dword esp+0124h], byte 0
        je near .12
        xor ecx, ecx
        mov dword [dword esp+0ECh], ecx
.1:
        xor esi, esi
        mov dword [dword esp+0F0h], esi
        mov dword [dword esp+0100h], esi
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, str_floppydrv
        lea eax, [byte esp+040h]
        call MakePath
        lea edx, [dword esp+0E8h]
        lea eax, [byte esp+040h]
        call FileOpenRW
        test eax, eax
        jne near .5
        mov ebx, dword [dword esp+0FCh]
        lea edx, [dword esp+080h]
        mov eax, dword [dword esp+0E8h]
        call ReadLeagueTeamEntry
        mov esi, eax
        test eax, eax
        jne short .2
        mov ecx, str_extID
        mov ebx, str_PLAYER
        mov edx, str_floppydrv
        lea eax, [byte esp+040h]
        call MakePath
        lea edx, [dword esp+0CCh]
        lea eax, [byte esp+040h]
        call FileOpenRead
        mov esi, eax
.2:
        test esi, esi
        jne short .3
        mov ecx, 0Bh
        mov ebx, 1
        lea edx, [dword esp+0C0h]
        mov eax, dword [dword esp+0CCh]
        call FileReadAt
        mov esi, eax
.3:
        test esi, esi
        jne short .4
        mov ecx, 0Dh
        mov ebx, 0Ch
        lea edx, [dword esp+0B0h]
        mov eax, dword [dword esp+0CCh]
        call FileReadAt
        mov esi, eax
.4:
        lea eax, [dword esp+0CCh]
        call FileClose
        test esi, esi
        jne short .6
        mov edx, ebp
        lea eax, [dword esp+0C0h]
        call strcmp_
        mov ebx, eax
        mov edx, edi
        lea eax, [dword esp+0B0h]
        call strcmp_
        add ebx, eax
        mov dword [dword esp+0100h], ebx
        jne short .6
        mov dword [dword esp+0ECh], 1
        jmp short .6
.5:
        mov dword [dword esp+0F0h], 0FFFFFFFFh
.6:
        cmp dword [dword esp+0100h], byte 0
        je near .8
        lea ebx, [dword esp+0B0h]
        lea edx, [dword esp+0C0h]
        mov eax, esp
        call FmtFromLeague
        mov eax, esp
        mov dword [msg_WrongDisk_arg], eax
        lea eax, [dword esp+0DCh]
        push eax
        lea eax, [dword esp+0E4h]
        push eax
        lea eax, [dword esp+0E0h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0E0h]
        push eax
        lea eax, [dword esp+0E8h]
        push eax
        push byte 2
        push btn_WrongDisk
        mov ecx, 3
        mov ebx, msg_WrongDisk
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [dword esp+0D8h], eax
        test eax, eax
        jne short .7
        mov dword [dword esp+0ECh], 0FFFFFFFFh
        jmp short .8
.7:
        mov esi, 0FFFFFFFFh
.8:
        test esi, esi
        jne near .11
        test byte [byte ebp+018h], 2
        je near .10
        cmp dword [dword esp+0F0h], byte 0
        je near .10
        mov ebx, 1
        mov edx, ebp
        mov eax, edi
        call WaitLeagueFloppy
        mov esi, eax
        test eax, eax
        jle near .11
        xor esi, eax
        lea eax, [dword esp+0DCh]
        push eax
        lea eax, [dword esp+0E4h]
        push eax
        lea eax, [dword esp+0ECh]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0E0h]
        push eax
        lea eax, [dword esp+0E8h]
        push eax
        push byte 2
        push newfloppybtns
        mov ecx, 2
        mov ebx, newfloppymsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [dword esp+0D8h], eax
        test eax, eax
        jne short .9
        mov byte [dword esp+096h], 1
        mov dword [dword esp+0ECh], 1
.9:
        cmp dword [dword esp+0D8h], byte 0
        jge short .11
        mov esi, 0FFFFFFFFh
        jmp short .11
.10:
        mov byte [dword esp+096h], 1
        xor esi, esi
        mov dword [dword esp+0ECh], 1
.11:
        lea eax, [dword esp+0E8h]
        call FileClose
        cmp dword [dword esp+0ECh], byte 0
        jne short .12
        test esi, esi
        je near ExportTeamToFloppy.1
.12:
        test esi, esi
        jne near .35
        cmp dword [dword esp+0120h], byte 0
        jne short .13
        mov bl, byte [byte ebp+016h]
        cmp bl, 1
        jne near .33
        cmp bl, byte [dword esp+096h]
        jne near .33
.13:
        mov eax, dword [dword esp+0FCh]
        shl eax, 4
        sub eax, dword [dword esp+0FCh]
        add eax, eax
        add eax, dword [dword esp+011Ch]
        call MsgCopyingDatabases
        xor ecx, ecx
        mov dword [dword esp+0E4h], ecx
        jmp short .15
.14:
        mov edx, str_floppydrv
        lea eax, [byte esp+040h]
        call strcpy_
        mov edx, dword [dword esp+0E4h]
        mov edx, dword [nosplit edx*4+leaguedbnames]
        lea eax, [byte esp+060h]
        call strcpy_
        mov ebx, str_wildcard
        lea edx, [byte esp+060h]
        lea eax, [byte esp+040h]
        call DeleteFiles
        inc dword [dword esp+0E4h]
.15:
        cmp dword [dword esp+0E4h], byte 7
        jge short .16
        test esi, esi
        je short ExportTeamToFloppy.14
.16:
        mov edx, str_floppydrv
        lea eax, [byte esp+040h]
        call strcpy_
        mov edx, str_PINFO
        lea eax, [byte esp+060h]
        call strcpy_
        mov ebx, str_wildcard
        lea edx, [byte esp+060h]
        lea eax, [byte esp+040h]
        call DeleteFiles
        mov edx, str_floppydrv
        lea eax, [byte esp+040h]
        call strcpy_
        mov edx, str_PLAYER
        lea eax, [byte esp+060h]
        call strcpy_
        mov ebx, str_ID
        lea edx, [byte esp+060h]
        lea eax, [byte esp+040h]
        call DeleteFiles
        xor edx, edx
        mov dword [dword esp+0E4h], edx
        jmp short .19
.17:
        push str_floppydrv
        mov eax, dword [nosplit ecx*4+leaguedbnames]
        mov ecx, edi
        mov ebx, dword [dword esp+0F8h]
        mov edx, dword [dword esp+0FCh]
        call CopyFile
        mov esi, eax
        test eax, eax
        jne short .18
        push str_floppydrv
        mov eax, dword [dword esp+0E8h]
        mov eax, dword [nosplit eax*4+leaguedbnames]
        mov ecx, edi
        mov ebx, str_extDB
        mov edx, ebx
        call CopyFile
        mov esi, eax
.18:
        inc dword [dword esp+0E4h]
.19:
        mov ecx, dword [dword esp+0E4h]
        cmp ecx, byte 7
        jge short .20
        test esi, esi
        je short ExportTeamToFloppy.17
.20:
        test esi, esi
        jne short .21
        push str_floppydrv
        mov ecx, edi
        mov ebx, str_extDB
        mov edx, ebx
        mov eax, str_PINFO
        call CopyFile
        mov esi, eax
.21:
        test esi, esi
        jne short .22
        mov ecx, str_SET2
        mov ebx, str_GAME4
        mov edx, edi
        lea eax, [byte esp+040h]
        call MakePath
        mov ecx, str_SET2
        mov ebx, str_GAME4
        mov edx, str_floppydrv
        lea eax, [byte esp+060h]
        call MakePath
        lea edx, [byte esp+060h]
        lea eax, [byte esp+040h]
        call CopyGameSettings
        mov esi, eax
.22:
        inc dword [byte ebp+01Ah]
        mov byte [byte ebp+016h], 2
        or byte [byte ebp+018h], 2
        test esi, esi
        jne short .23
        mov ecx, str_extID
        mov ebx, str_PLAYER
        mov edx, str_floppydrv
        lea eax, [byte esp+040h]
        call MakePath
        lea edx, [dword esp+0D4h]
        lea eax, [byte esp+040h]
        call FileCreate
        mov esi, eax
.23:
        test esi, esi
        jne short .24
        mov al, byte [dword esp+0FCh]
        mov byte [dword esp+0108h], al
        mov ecx, 1
        xor ebx, ebx
        lea edx, [dword esp+0108h]
        mov eax, dword [dword esp+0D4h]
        call FileWriteAt
        mov esi, eax
.24:
        test esi, esi
        jne short .25
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, ebp
        mov eax, dword [dword esp+0D4h]
        call FileWriteAt
        mov esi, eax
.25:
        test esi, esi
        jne short .26
        mov ecx, 0Dh
        mov ebx, 0FFFFFFFFh
        mov edx, edi
        mov eax, dword [dword esp+0D4h]
        call FileWriteAt
        mov esi, eax
.26:
        test esi, esi
        jne short .27
        lea edx, [byte ebp+01Ah]
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov eax, dword [dword esp+0D4h]
        call FileWriteAt
        mov esi, eax
.27:
        lea eax, [dword esp+0D4h]
        call FileClose
        test esi, esi
        jne short .28
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, str_floppydrv
        lea eax, [byte esp+040h]
        call MakePath
        lea edx, [dword esp+0E8h]
        lea eax, [byte esp+040h]
        call FileOpenWrite
        mov esi, eax
.28:
        test esi, esi
        jne short .29
        xor edx, edx
        mov dword [dword esp+0104h], edx
        mov ecx, 2
        mov ebx, 13h
        lea edx, [dword esp+0104h]
        mov eax, dword [dword esp+0E8h]
        call FileWriteAt
        mov esi, eax
.29:
        test esi, esi
        jne short .30
        mov ebx, dword [dword esp+0FCh]
        mov edx, ebp
        mov eax, dword [dword esp+0E8h]
        call WriteLeagueTeamEntry
        mov esi, eax
.30:
        lea eax, [dword esp+0E8h]
        call FileClose
        test esi, esi
        jne short .31
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, edi
        lea eax, [byte esp+040h]
        call MakePath
        lea edx, [dword esp+0D0h]
        lea eax, [byte esp+040h]
        call FileOpenRW
        mov esi, eax
.31:
        test esi, esi
        jne short .32
        mov ebx, dword [dword esp+0FCh]
        mov edx, ebp
        mov eax, dword [dword esp+0D0h]
        call WriteLeagueTeamEntry
        mov esi, eax
.32:
        call RestoreDialogBg
        test esi, esi
        je near .35
        mov byte [byte ebp+016h], 1
        or byte [byte ebp+018h], 1
        mov ebx, dword [dword esp+0FCh]
        mov edx, ebp
        mov eax, dword [dword esp+0D0h]
        call WriteLeagueTeamEntry
        lea eax, [dword esp+0DCh]
        push eax
        lea eax, [dword esp+0E4h]
        push eax
        lea eax, [dword esp+0ECh]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0E0h]
        push eax
        lea eax, [dword esp+0E8h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, exporterrmsg
        jmp near .34
.33:
        mov edx, edi
        lea eax, [dword esp+0A0h]
        call strcpy_
        mov ecx, ds
        mov ebx, str_dot
        mov edx, ds
        lea eax, [dword esp+0A0h]
        call _fstrcspn_
        xor cl, cl
        mov byte [dword esp+eax+0A0h], cl
        lea eax, [dword esp+0A0h]
        mov dword [forceexportmsg], eax
        mov dword [forceexportmsg+8], ebp
        lea eax, [dword esp+0DCh]
        push eax
        lea eax, [dword esp+0E4h]
        push eax
        lea eax, [dword esp+0ECh]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0E0h]
        push eax
        lea eax, [dword esp+0E8h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, forceexportmsg
.34:
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.35:
        lea eax, [dword esp+0D0h]
        call FileClose
        mov eax, esi
        add esp, 10Ch
        pop ebp
        pop edi
        pop esi
        ret 0Ch
;-----------------------------------------------------------------------------
; CopyLeagueFiles                                                 3C310  95 PC
; (src dir, dst dir): CopyFile of the 7 league .DB and .xx files, PINFO.DB
; and PLAYER.ID
;-----------------------------------------------------------------------------
; C: src/pc/floppy_export/CopyLeagueFiles.c
%ifdef CBUILD
%include "c/pc/floppy_export/CopyLeagueFiles.inc"
%else
CopyLeagueFiles:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov dword [esp], edx
        xor eax, eax
        xor ebp, ebp
        jmp short .3
.1:
        mov ecx, dword [esp]
        push ecx
        mov esi, ebp
        shl esi, 2
        mov eax, dword [dword esi+leaguedbnames]
        mov ecx, edi
        mov ebx, str_extDB
        mov edx, ebx
        call CopyFile
        test eax, eax
        jne short .2
        mov eax, dword [esp]
        push eax
        mov eax, dword [dword esi+leaguedbnames]
        mov ecx, edi
        mov ebx, str_extxx
        mov edx, ebx
        call CopyFile
.2:
        inc ebp
.3:
        cmp ebp, byte 7
        jge short .4
        test eax, eax
        je short CopyLeagueFiles.1
.4:
        test eax, eax
        jne short .5
        mov edx, dword [esp]
        push edx
        mov ecx, edi
        mov ebx, str_extDB
        mov edx, ebx
        mov eax, str_PINFO
        call CopyFile
.5:
        test eax, eax
        jne short .x
        mov ebx, dword [esp]
        push ebx
        mov ecx, edi
        mov ebx, str_extID
        mov edx, ebx
        mov eax, str_PLAYER
        call CopyFile
.x:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ImportMasterLeague                                              3C3AF  95 PC
; "Importing Master Databases.": mkdir + CopyLeagueFiles from floppy, master
; password; "Can not import master league! The league already exists!",
; "Error while importing league!"
;-----------------------------------------------------------------------------
; C: src/pc/floppy_export/ImportMasterLeague.c
%ifdef CBUILD
%include "c/pc/floppy_export/ImportMasterLeague.inc"
%else
ImportMasterLeague:
        push dword 0A4h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 74h
        mov edx, 0FFFFFFFFh
        mov dword [byte esp+06Ch], edx
        mov dword [byte esp+068h], edx
        mov ecx, str_extID
        mov ebx, str_PLAYER
        mov edx, str_floppydrv
        lea eax, [byte esp+02Ch]
        call MakePath
        lea edx, [byte esp+06Ch]
        lea eax, [byte esp+02Ch]
        call FileOpenRead
        mov esi, eax
        test eax, eax
        jne short .1
        mov ecx, 0Dh
        mov ebx, 0Ch
        mov edx, curleague
        mov eax, dword [byte esp+06Ch]
        call FileReadAt
        mov esi, eax
.1:
        lea eax, [byte esp+06Ch]
        call FileClose
        test esi, esi
        jne near .12
        jne short .2
        push savedname
        push leaguesaved
        push leagueflags
        push humancount
        mov ecx, leaguemaster
        mov ebx, masterpw
        mov edx, leagueteams
        mov eax, str_floppydrv
        call ReadLeagueInfo
        mov esi, eax
.2:
        mov edx, curleague
        lea eax, [byte esp+04Ch]
        call strcpy_
        mov ebx, esp
        mov edx, 10h
        lea eax, [byte esp+04Ch]
        call unknown_libname_1
        test eax, eax
        je near .11
        mov eax, dword [leaguemaster]
        mov ebx, masterpw
        mov edx, leagueteams
        call AskMasterPassword
        mov edi, eax
        test eax, eax
        jne near .12
        push eax
        lea eax, [byte esp+060h]
        push eax
        lea eax, [byte esp+068h]
        push eax
        push edi
        push edi
        mov ecx, 1
        mov ebx, importmastermsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        lea eax, [byte esp+04Ch]
        call mkdir_
        mov esi, eax
        test eax, eax
        jne short .5
        mov dword [byte esp+064h], eax
        jmp short .4
.3:
        push curleague
        mov eax, dword [nosplit ebp*4+leaguedbnames]
        mov ecx, str_floppydrv
        mov ebx, str_extDB
        mov edx, ebx
        call CopyFile
        mov esi, eax
        inc dword [byte esp+064h]
.4:
        mov ebp, dword [byte esp+064h]
        cmp ebp, byte 7
        jge short .5
        test esi, esi
        je short ImportMasterLeague.3
.5:
        test esi, esi
        jne short .6
        push curleague
        mov ecx, str_floppydrv
        mov ebx, str_extDB
        mov edx, ebx
        mov eax, str_PINFO
        call CopyFile
        mov esi, eax
.6:
        test esi, esi
        jne short .7
        push curleague
        mov ecx, str_floppydrv
        mov ebx, str_SET
        mov edx, ebx
        mov eax, str_GAME3
        call CopyFile
.7:
        call RestoreDialogBg
        mov edx, curleague
        lea eax, [byte esp+02Ch]
        call strcpy_
        mov ebx, str_SAV3
        mov edx, str_GAME3
        lea eax, [byte esp+02Ch]
        call DeleteFiles
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, curleague
        lea eax, [byte esp+02Ch]
        call MakePath
        lea edx, [byte esp+068h]
        lea eax, [byte esp+02Ch]
        call FileOpenRW
        mov esi, eax
        test eax, eax
        jne short .8
        mov ecx, 2
        mov ebx, 13h
        lea edx, [byte esp+070h]
        mov eax, dword [byte esp+068h]
        call FileReadAt
        mov esi, eax
.8:
        lea eax, [byte esp+068h]
        call FileClose
        test esi, esi
        jne short .9
        mov ebx, 0FFFFFFFFh
        mov edx, leagueteams
        mov eax, curleague
        call CopyHumanTeamDBs
        mov esi, eax
.9:
        test esi, esi
        je short .10
        lea eax, [byte esp+05Ch]
        push eax
        lea eax, [byte esp+064h]
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+060h]
        push eax
        lea eax, [byte esp+068h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, updateerrmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.10:
        test esi, esi
        je short .12
        lea eax, [byte esp+04Ch]
        call DeleteDir
        jmp short .12
.11:
        lea eax, [byte esp+05Ch]
        push eax
        lea eax, [byte esp+064h]
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        push byte 0FFFFFFFFh
        lea eax, [byte esp+060h]
        push eax
        lea eax, [byte esp+068h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, lgexistsmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.12:
        test esi, esi
        je short .13
        lea eax, [byte esp+05Ch]
        push eax
        lea eax, [byte esp+064h]
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        push byte 0FFFFFFFFh
        lea eax, [byte esp+060h]
        push eax
        lea eax, [byte esp+068h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, importerrmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.13:
        test edi, edi
        je short .14
        mov esi, 0FFFFFFFFh
.14:
        mov eax, esi
        add esp, byte 74h
ImportMasterLeague_ret:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ImportPlayerTeam                             3C6E2  95 PC, medium confidence
; Imports one player's team from floppy: "The league X already exists for",
; "X has not been exported for the league", "X is in a save game in the
; league ... can not be imported until the game is finished!", stale-copy
; check
;-----------------------------------------------------------------------------
; C: src/pc/floppy_export/ImportMasterLeague.c (ImportPlayerTeam)
%ifdef CBUILD
%include "c/pc/floppy_export/ImportMasterLeague.ImportPlayerTeam.inc"
%else
ImportPlayerTeam:
        push dword 0E8h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 0B8h
        mov edx, 0FFFFFFFFh
        mov dword [dword esp+094h], edx
        mov dword [dword esp+0A4h], edx
        mov dword [dword esp+0A0h], edx
        xor ebp, ebp
        push ebp
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        mov ecx, str_extID
        mov ebx, str_PLAYER
        mov edx, str_floppydrv
        lea eax, [byte esp+02Ch]
        call MakePath
        lea edx, [dword esp+094h]
        lea eax, [byte esp+02Ch]
        call FileOpenRead
        mov esi, eax
        test eax, eax
        jne short .1
        mov ecx, 1
        xor ebx, ebx
        lea edx, [dword esp+0B4h]
        mov eax, dword [dword esp+094h]
        call FileReadAt
        mov esi, eax
.1:
        test esi, esi
        jne short .2
        mov ecx, 0Bh
        mov ebx, 1
        lea edx, [byte esp+07Ch]
        mov eax, dword [dword esp+094h]
        call FileReadAt
        mov esi, eax
.2:
        test esi, esi
        jne short .3
        mov ecx, 0Dh
        mov ebx, 0Ch
        mov edx, curleague
        mov eax, dword [dword esp+094h]
        call FileReadAt
        mov esi, eax
.3:
        test esi, esi
        jne short .4
        mov ecx, 4
        mov ebx, 19h
        lea edx, [dword esp+09Ch]
        mov eax, dword [dword esp+094h]
        call FileReadAt
        mov esi, eax
.4:
        lea eax, [dword esp+094h]
        call FileClose
        test esi, esi
        jne short .5
        mov eax, dword [dword esp+0B1h]
        sar eax, 18h
        push eax
        push str_02d3
        lea eax, [dword esp+0A0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [dword esp+098h]
        mov eax, str_extxx
        call strcpy_
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, str_floppydrv
        lea eax, [byte esp+02Ch]
        call MakePath
        lea edx, [dword esp+0A4h]
        lea eax, [byte esp+02Ch]
        call FileOpenRW
        mov esi, eax
.5:
        test esi, esi
        jne short .6
        mov ebx, dword [dword esp+0B1h]
        sar ebx, 18h
        lea edx, [byte esp+04Ch]
        mov eax, dword [dword esp+0A4h]
        call ReadLeagueTeamEntry
        mov esi, eax
.6:
        test esi, esi
        jne short .7
        mov ecx, 2
        mov ebx, 4
        lea edx, [dword esp+0B0h]
        mov eax, dword [dword esp+0A4h]
        call FileReadAt
        mov esi, eax
.7:
        lea eax, [dword esp+0A4h]
        call FileClose
        test esi, esi
        jne near .8
        cmp word [dword esp+0B0h], byte 0
        je near .8
        mov edx, curleague
        lea eax, [byte esp+06Ch]
        call strcpy_
        mov ecx, ds
        mov ebx, str_dot
        mov edx, ds
        lea eax, [byte esp+06Ch]
        call _fstrcspn_
        xor dh, dh
        mov byte [byte esp+eax+06Ch], dh
        push esi
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        lea eax, [byte esp+07Ch]
        mov dword [insavegamemsg], eax
        lea eax, [byte esp+06Ch]
        mov dword [insavegamemsg+8], eax
        lea eax, [dword esp+0A8h]
        push eax
        lea eax, [dword esp+094h]
        push eax
        lea eax, [dword esp+094h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0ACh]
        push eax
        lea eax, [dword esp+098h]
        push eax
        push esi
        push esi
        mov ecx, 5
        mov ebx, insavegamemsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp near .35
.8:
        test esi, esi
        jne near .35
        mov edx, curleague
        lea eax, [byte esp+06Ch]
        call strcpy_
        mov ebx, esp
        mov edx, 10h
        lea eax, [byte esp+06Ch]
        call unknown_libname_1
        mov edi, eax
        mov dword [dword esp+0ACh], eax
        mov ecx, ds
        mov ebx, str_dot
        mov edx, ds
        lea eax, [byte esp+06Ch]
        call _fstrcspn_
        xor dl, dl
        mov byte [byte esp+eax+06Ch], dl
        test edi, edi
        jne near .13
.9:
        xor edi, edi
        push savedname
        push leaguesaved
        push leagueflags
        push humancount
        mov ecx, leaguemaster
        mov ebx, masterpw
        mov edx, leagueteams
        mov eax, curleague
        call ReadLeagueInfo
        mov esi, eax
        push edi
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        lea eax, [dword esp+0A8h]
        push eax
        lea eax, [dword esp+094h]
        push eax
        lea eax, [dword esp+094h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        test byte [leagueflags], 0Ch
        je short .10
        lea eax, [byte esp+06Ch]
        mov dword [playerdbsmsg+4], eax
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0ACh]
        push eax
        lea eax, [dword esp+098h]
        push eax
        push byte 2
        push btn_MasterDB
        mov ecx, 4
        mov ebx, playerdbsmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        test eax, eax
        jne short .11
        call UpdateTeamDbs
        mov edi, 0FFFFFFFFh
        jmp short .12
.10:
        cmp dword [leaguesaved], byte 0
        je short .12
        lea eax, [byte esp+06Ch]
        mov dword [msg_SavedGame_arg], eax
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0ACh]
        push eax
        lea eax, [dword esp+098h]
        push eax
        push edi
        push edi
        mov ecx, 3
        mov ebx, msg_SavedGame
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.11:
        mov ebp, 0FFFFFFFFh
.12:
        test edi, edi
        jne near ImportPlayerTeam.9
.13:
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        test esi, esi
        jne near .34
        test ebp, ebp
        jne near .34
        lea edx, [dword esp+088h]
        mov eax, curleague
        call GetLeagueId
        mov edx, eax
        cmp byte [byte esp+062h], 2
        jne short .14
        cmp dword [dword esp+0ACh], byte 0
        jne near .16
        mov eax, dword [dword esp+0B1h]
        sar eax, 18h
        mov edi, eax
        shl edi, 4
        sub edi, eax
        add edi, edi
        cmp byte [dword edi+lgteamflags], 2
        je near .16
        mov eax, dword [byte esp+066h]
        cmp eax, dword [dword edi+lgteamver]
        ja short .16
.14:
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        lea eax, [byte esp+07Ch]
        mov dword [notexportedmsg], eax
        lea eax, [byte esp+06Ch]
        mov dword [notexportedmsg+8], eax
        lea eax, [dword esp+0A8h]
        push eax
        lea eax, [dword esp+094h]
        push eax
        lea eax, [dword esp+094h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0ACh]
        push eax
        lea eax, [dword esp+098h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, notexportedmsg
.15:
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp near .34
.16:
        cmp dword [dword esp+0ACh], byte 0
        jne near .27
        mov ebp, dword [dword esp+0B1h]
        sar ebp, 18h
        mov edi, ebp
        shl edi, 4
        sub edi, ebp
        mov eax, dword [byte esp+066h]
        cmp eax, dword [nosplit edi*2+lgteamver]
        jae short .17
        lea eax, [byte esp+06Ch]
        mov dword [oldcopymsg+8], eax
        lea eax, [dword esp+0A8h]
        push eax
        lea eax, [dword esp+094h]
        push eax
        lea eax, [dword esp+094h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0ACh]
        push eax
        lea eax, [dword esp+098h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, oldcopymsg
        jmp near ImportPlayerTeam.15
.17:
        test edx, edx
        jl near .24
        cmp edx, ebp
        je short .18
        lea eax, [byte esp+06Ch]
        mov dword [lgexistsformsg+4], eax
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        mov edx, leagueteams
        add edx, eax
        mov dword [lgexistsformsg+0Ch], edx
        lea eax, [dword esp+0A8h]
        push eax
        lea eax, [dword esp+094h]
        push eax
        lea eax, [dword esp+094h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0ACh]
        push eax
        lea eax, [dword esp+098h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 4
        mov ebx, lgexistsformsg
        jmp near ImportPlayerTeam.15
.18:
        lea eax, [byte esp+07Ch]
        call MsgCopyingDatabases
        mov byte [byte esp+062h], 1
        test esi, esi
        jne short .19
        mov edx, curleague
        mov eax, str_floppydrv
        call CopyLeagueFiles
        mov esi, eax
.19:
        test esi, esi
        jne short .20
        push curleague
        mov ecx, str_floppydrv
        mov ebx, str_SET2
        mov edx, ebx
        mov eax, str_GAME4
        call CopyFile
        mov esi, eax
.20:
        test esi, esi
        jne short .21
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, curleague
        lea eax, [byte esp+02Ch]
        call MakePath
        lea edx, [dword esp+0A0h]
        lea eax, [byte esp+02Ch]
        call FileOpenRW
        mov esi, eax
.21:
        test esi, esi
        jne short .22
        mov ebx, dword [dword esp+0B1h]
        sar ebx, 18h
        lea edx, [byte esp+04Ch]
        mov eax, dword [dword esp+0A0h]
        call WriteLeagueTeamEntry
        mov esi, eax
.22:
        lea eax, [dword esp+0A0h]
        call FileClose
        test esi, esi
        jne short .23
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, str_floppydrv
        lea eax, [byte esp+02Ch]
        call MakePath
        lea edx, [dword esp+0A4h]
        lea eax, [byte esp+02Ch]
        call FileOpenRW
        mov esi, eax
.23:
        test esi, esi
        jne near .33
        mov ebx, dword [dword esp+0B1h]
        sar ebx, 18h
        lea edx, [byte esp+04Ch]
        mov eax, dword [dword esp+0A4h]
        call WriteLeagueTeamEntry
        jmp near .33
.24:
        lea eax, [byte esp+07Ch]
        call MsgCopyingDatabases
        mov byte [byte esp+062h], 1
        xor ecx, ecx
        mov dword [dword esp+08Ch], ecx
        jmp short .26
.25:
        push curleague
        mov eax, dword [nosplit edi*4+leaguedbnames]
        mov ecx, str_floppydrv
        mov ebx, str_extxx
        mov edx, ebx
        call CopyFile
        mov esi, eax
        inc dword [dword esp+08Ch]
.26:
        mov edi, dword [dword esp+08Ch]
        cmp edi, byte 7
        jge near ImportPlayerTeam.19
        test esi, esi
        je short ImportPlayerTeam.25
        jmp near ImportPlayerTeam.19
.27:
        lea eax, [byte esp+07Ch]
        call MsgCopyingDatabases
        mov edx, curleague
        lea eax, [byte esp+06Ch]
        call strcpy_
        lea eax, [byte esp+06Ch]
        call mkdir_
        mov esi, eax
        mov byte [byte esp+062h], 1
        test eax, eax
        jne short .28
        mov edx, curleague
        mov eax, str_floppydrv
        call CopyLeagueFiles
        mov esi, eax
.28:
        test esi, esi
        jne short .29
        push curleague
        mov ecx, str_floppydrv
        mov ebx, str_SET2
        mov edx, ebx
        mov eax, str_GAME4
        call CopyFile
        mov esi, eax
.29:
        test esi, esi
        jne short .30
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, curleague
        lea eax, [byte esp+02Ch]
        call MakePath
        lea edx, [dword esp+0A0h]
        lea eax, [byte esp+02Ch]
        call FileOpenRW
        mov esi, eax
.30:
        test esi, esi
        jne short .31
        mov ebx, dword [dword esp+0B1h]
        sar ebx, 18h
        lea edx, [byte esp+04Ch]
        mov eax, dword [dword esp+0A0h]
        call WriteLeagueTeamEntry
        mov esi, eax
.31:
        lea eax, [dword esp+0A0h]
        call FileClose
        test esi, esi
        jne short .32
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, str_floppydrv
        lea eax, [byte esp+02Ch]
        call MakePath
        lea edx, [dword esp+0A4h]
        lea eax, [byte esp+02Ch]
        call FileOpenRW
        mov esi, eax
.32:
        test esi, esi
        jne short .33
        mov ebx, dword [dword esp+0B1h]
        sar ebx, 18h
        lea edx, [byte esp+04Ch]
        mov eax, dword [dword esp+0A4h]
        call WriteLeagueTeamEntry
.33:
        lea eax, [dword esp+0A4h]
        call FileClose
.34:
        test esi, esi
        je short .35
        cmp dword [dword esp+0ACh], byte 0
        je short .35
        mov edx, curleague
        lea eax, [byte esp+06Ch]
        call strcpy_
        lea eax, [byte esp+06Ch]
        call DeleteDir
.35:
        call RestoreDialogBg
        test esi, esi
        je short .36
        lea eax, [dword esp+0A8h]
        push eax
        lea eax, [dword esp+094h]
        push eax
        lea eax, [dword esp+094h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0ACh]
        push eax
        lea eax, [dword esp+098h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, importerrmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.36:
        mov eax, esi
        add esp, 0B8h
        jmp near ImportMasterLeague_ret
%endif ; C
;-----------------------------------------------------------------------------
; ImportDbs                                                       3CF5B  95 PC
; MenuImportDbs: "Put disk with league to import in any drive.",
; SelectFloppyDrive, "Import master copy of league or import for player on
; floppy disk?" (Master / Player) -> ImportMasterLeague / ImportPlayerTeam,
; then reloads the league
;-----------------------------------------------------------------------------
; C: src/pc/floppy_export/ImportDbs.c
%ifdef CBUILD
%include "c/pc/floppy_export/ImportDbs.inc"
%else
ImportDbs:
        push dword 54h
        call __CHK
        push ebx
        push ecx
        push edx
        sub esp, byte 30h
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        lea eax, [byte esp+020h]
        push eax
        lea eax, [byte esp+030h]
        push eax
        lea eax, [byte esp+02Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+024h]
        push eax
        lea eax, [byte esp+034h]
        push eax
        push byte 2
        push importtypebtns
        mov ecx, 2
        mov ebx, importtypemsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [byte esp+024h], eax
        test eax, eax
        jl near .7
        push byte 0FFFFFFFFh
        lea eax, [byte esp+024h]
        push eax
        lea eax, [byte esp+034h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, importdiskmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        test eax, eax
        jne short .1
        xor edx, edx
        call SelectFloppyDrive
.1:
        test eax, eax
        jne near .7
        cmp dword [byte esp+024h], byte 0
        jne short .2
        call ImportMasterLeague
        jmp short .3
.2:
        call ImportPlayerTeam
.3:
        test eax, eax
        jne near .6
        mov ecx, str_SET
        mov ebx, str_GAME3
        mov edx, curleague
        mov eax, esp
        call MakePath
        lea edx, [byte esp+028h]
        mov eax, esp
        call FileOpenRead
        test eax, eax
        jne short .5
        mov ecx, 75h
        mov ebx, 0FFFFFFFFh
        mov edx, lgstate
        mov eax, dword [byte esp+028h]
        call FileReadAt
        test eax, eax
        je short .4
        push str_L1
        call FatalError
        add esp, byte 4
.4:
        lea eax, [byte esp+028h]
        call FileClose
        test eax, eax
        je short .5
        push str_L22
        call FatalError
        add esp, byte 4
.5:
        mov eax, lgstate
        call LoadModeState
        call BuildSavedGameLabels
        xor eax, eax
        call SetupStatsSourceMenu
        mov dword [menuact_export], MenuExportDbs
        mov dword [menuact_nextlg], MenuNextLeagueGame
        mov dword [menusub_lgmgr], leaguemgrmenu
        jmp short .7
.6:
        xor ah, ah
        mov byte [lgstate+4], ah
        call BuildSavedGameLabels
        xor eax, eax
        call SetupStatsSourceMenu
        xor ebx, ebx
        mov dword [menuact_export], ebx
        mov dword [menuact_nextlg], ebx
        mov dword [menusub_lgmgr], ebx
.7:
        push byte 0
        mov ecx, 3Fh
        mov ebx, 17h
        mov edx, ecx
        mov eax, 2Ah
        call SetDialogColors
        add esp, byte 30h
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ExportDbs                                                       3D108  95 PC
; MenuExportDbs: "Select a team to export." (LeagueTeamSelect), "X has not
; been imported for Y / Do you want to force an export?", master password,
; SelectFloppyDrive, ExportTeamToFloppy, bumps the entry export count
;-----------------------------------------------------------------------------
; C: src/pc/floppy_export/ImportMasterLeague.c (ExportDbs)
%ifdef CBUILD
%include "c/pc/floppy_export/ImportMasterLeague.ExportDbs.inc"
%else
ExportDbs:
        push dword 78h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 48h
        mov edx, 3
        mov eax, curleague
        call LeagueCheckStub
        mov esi, eax
.1:
        xor edi, edi
        test esi, esi
        jne near .4
        push savedname
        push leaguesaved
        push leagueflags
        push humancount
        mov ecx, leaguemaster
        mov ebx, masterpw
        mov edx, leagueteams
        mov eax, curleague
        call ReadLeagueInfo
        mov esi, eax
        mov edx, curleague
        lea eax, [byte esp+020h]
        call strcpy_
        mov ecx, ds
        mov ebx, str_dot
        mov edx, ds
        lea eax, [byte esp+020h]
        call _fstrcspn_
        xor dl, dl
        mov byte [byte esp+eax+020h], dl
        push edi
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        lea eax, [byte esp+034h]
        push eax
        lea eax, [byte esp+048h]
        push eax
        lea eax, [byte esp+044h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        test byte [leagueflags], 0Ch
        je short .2
        lea eax, [byte esp+020h]
        mov dword [playerdbsmsg+4], eax
        push byte 0FFFFFFFFh
        lea eax, [byte esp+038h]
        push eax
        lea eax, [byte esp+04Ch]
        push eax
        push byte 2
        push btn_MasterDB
        mov ecx, 4
        mov ebx, playerdbsmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [byte esp+03Ch], eax
        test eax, eax
        jne short .3
        call UpdateTeamDbs
        mov edi, 0FFFFFFFFh
        jmp short .4
.2:
        cmp dword [leaguesaved], byte 0
        je short .4
        lea eax, [byte esp+020h]
        mov dword [msg_SavedGame_arg], eax
        push byte 0FFFFFFFFh
        lea eax, [byte esp+038h]
        push eax
        lea eax, [byte esp+04Ch]
        push eax
        push edi
        push edi
        mov ecx, 3
        mov ebx, msg_SavedGame
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.3:
        mov esi, 0FFFFFFFFh
.4:
        test edi, edi
        jne near ExportDbs.1
        test esi, esi
        jne near .14
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        mov ebx, 1
        mov edx, treeteamnames
        mov eax, esp
        call ReadTeamNames
        test eax, eax
        jne near .14
        mov ebp, 0FFFFFFFFh
        lea edx, [byte esp+038h]
        mov eax, curleague
        call GetLeagueId
        mov dword [byte esp+040h], eax
        test eax, eax
        jge short .5
        lea eax, [byte esp+040h]
        push eax
        push str_SelectATeamTo2
        push byte 8
        mov ecx, leagueteams
        mov ebx, treeteamnames
        mov edx, humancount
        mov eax, curleague
        call LeagueTeamSelect
        cmp dword [humancount], byte 1
        jne short .6
        push edi
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        jmp short .6
.5:
        xor ebp, ebp
.6:
        mov ecx, dword [byte esp+040h]
        test ecx, ecx
        jl near .9
        mov eax, ecx
        shl eax, 4
        sub eax, ecx
        add eax, eax
        cmp byte [dword eax+lgteamflags], 2
        jne near .9
        lea edx, [byte esp+020h]
        mov dword [forceexportmsg], edx
        mov edx, leagueteams
        add edx, eax
        mov dword [forceexportmsg+8], edx
        lea eax, [byte esp+034h]
        push eax
        lea eax, [byte esp+048h]
        push eax
        lea eax, [byte esp+044h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+038h]
        push eax
        lea eax, [byte esp+04Ch]
        push eax
        push byte 2
        push forceexportbtns
        mov ecx, 4
        mov ebx, forceexportmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [byte esp+03Ch], eax
        mov esi, 0FFFFFFFFh
        test eax, eax
        jne short .7
        mov eax, dword [leaguemaster]
        mov ebx, masterpw
        mov edx, leagueteams
        call AskMasterPassword
        mov esi, eax
.7:
        test esi, esi
        jne short .8
        mov edi, 0FFFFFFFFh
        mov eax, dword [byte esp+040h]
        shl eax, 4
        sub eax, dword [byte esp+040h]
        inc word [nosplit eax*2+lgteamver_hi]
        jmp short .9
.8:
        mov dword [byte esp+040h], 0FFFFFFFFh
.9:
        cmp dword [byte esp+040h], byte 0
        jl near .14
        cmp dword [humancount], byte 1
        je short .10
        test ebp, ebp
        jne short .11
.10:
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
.11:
        mov esi, dword [byte esp+040h]
        push esi
        push str_02d3
        lea eax, [byte esp+038h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [byte esp+030h]
        mov eax, str_extxx
        call strcpy_
        test edi, edi
        je short .12
        mov esi, str_extDB
        jmp short .13
.12:
        mov esi, str_extxx
.13:
        mov eax, dword [byte esp+040h]
        shl eax, 4
        sub eax, dword [byte esp+040h]
        add eax, eax
        mov edx, leagueteams
        add edx, eax
        mov eax, curleague
        call SelectFloppyDrive
        test eax, eax
        jne short .14
        push byte 0FFFFFFFFh
        push edi
        push leagueteams
        mov ecx, dword [byte esp+04Ch]
        mov ebx, str_extxx
        mov edx, esi
        mov eax, curleague
        call ExportTeamToFloppy
.14:
        push byte 0
        mov ecx, 3Fh
        mov ebx, 17h
        mov edx, ecx
        mov eax, 2Ah
        call SetDialogColors
        add esp, byte 48h
        jmp near ImportMasterLeague_ret
%endif ; C
;-----------------------------------------------------------------------------
; SelectFloppyDrive                                               3D46D  95 PC
; Probes A: and B: (_dos_getdiskfree_), prefers a disk whose PLAYER.ID
; matches league/team, else "Please put a floppy disk in any drive." / "Use
; floppy drive A or B?"; sets str_floppydrv
;-----------------------------------------------------------------------------
; C: src/pc/floppy_export/SelectFloppyDrive.c
%ifdef CBUILD
%include "c/pc/floppy_export/SelectFloppyDrive.inc"
%else
SelectFloppyDrive:
        push dword 84h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 58h
        mov edi, eax
        mov esi, edx
        mov edx, 0FFFFFFFFh
        mov dword [byte esp+044h], edx
        mov dword [floppyprobe], edx
.1:
        xor ecx, ecx
        mov dword [byte esp+054h], ecx
        xor ebp, ebp
        mov dword [byte esp+050h], ecx
        jmp near .6
.2:
        mov dword [criterrflag], ebp
        mov dword [nosplit edx*4+floppyok], 0FFFFFFFFh
        lea eax, [byte edx+01h]
        lea edx, [byte esp+03Ch]
        call _dos_getdiskfree_
        cmp dword [criterrflag], byte 0
        je short .3
        mov eax, dword [byte esp+050h]
        mov dword [nosplit eax*4+floppyok], ebp
        jmp near .5
.3:
        test edi, edi
        je near .5
        test esi, esi
        je near .5
        mov al, byte [byte esp+050h]
        add al, 41h
        mov byte [str_floppydrv], al
        mov ecx, str_extID
        mov ebx, str_PLAYER
        mov edx, str_floppydrv
        mov eax, esp
        call MakePath
        lea edx, [byte esp+044h]
        mov eax, esp
        call FileOpenRead
        test eax, eax
        jne short .4
        mov ecx, 0Bh
        mov ebx, 1
        lea edx, [byte esp+030h]
        mov eax, dword [byte esp+044h]
        call FileReadAt
        mov ecx, 0Dh
        mov ebx, 0FFFFFFFFh
        lea edx, [byte esp+020h]
        mov eax, dword [byte esp+044h]
        call FileReadAt
        lea edx, [byte esp+030h]
        mov eax, esi
        call stricmp_
        test eax, eax
        jne short .4
        lea edx, [byte esp+020h]
        mov eax, edi
        call stricmp_
        test eax, eax
        jne short .4
        mov ebp, 0FFFFFFFFh
.4:
        lea eax, [byte esp+044h]
        call FileClose
.5:
        inc dword [byte esp+050h]
.6:
        mov edx, dword [byte esp+050h]
        cmp edx, byte 2
        jge short .7
        test ebp, ebp
        je near SelectFloppyDrive.2
.7:
        cmp dword [floppyok], byte 0
        jne short .8
        cmp dword [floppyok+4], byte 0
        jne short .8
        lea eax, [byte esp+048h]
        push eax
        lea eax, [byte esp+050h]
        push eax
        lea eax, [byte esp+058h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+04Ch]
        push eax
        lea eax, [byte esp+054h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, insertfloppymsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [byte esp+054h], eax
.8:
        cmp dword [floppyok], byte 0
        jne short .9
        cmp dword [floppyok+4], byte 0
        jne short .9
        cmp dword [byte esp+054h], byte 4
        jne near SelectFloppyDrive.1
.9:
        xor ecx, ecx
        mov dword [floppyprobe], ecx
        test ebp, ebp
        jne near .12
        cmp dword [byte esp+054h], byte 4
        je near .12
        cmp dword [floppyok], byte 0
        je short .10
        cmp dword [floppyok+4], byte 0
        je short .10
        lea eax, [byte esp+048h]
        push eax
        lea eax, [byte esp+050h]
        push eax
        lea eax, [byte esp+058h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+04Ch]
        push eax
        lea eax, [byte esp+054h]
        push eax
        push byte 2
        push drivebtns
        mov ecx, 1
        mov ebx, whichdrivemsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        add al, 41h
        mov byte [str_floppydrv], al
        jmp short .12
.10:
        cmp dword [floppyok], byte 0
        je short .11
        mov byte [str_floppydrv], 41h
        jmp short .12
.11:
        mov byte [str_floppydrv], 42h
.12:
        mov eax, dword [byte esp+054h]
        add esp, byte 58h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FindLeagueFloppy                             3D694  95 PC, medium confidence
; Probes A: / B: for a PLAYER.ID matching the league and team; "That floppy
; disk is not for <league>"
;-----------------------------------------------------------------------------
; C: src/pc/floppy_export/FindLeagueFloppy.c
%ifdef CBUILD
%include "c/pc/floppy_export/FindLeagueFloppy.inc"
%else
FindLeagueFloppy:
        push dword 0C0h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 98h
        mov ebp, eax
        mov edi, edx
        mov dword [dword esp+090h], 0FFFFFFFFh
.1:
        mov esi, 0FFFFFFFFh
        mov dword [floppyprobe], esi
        xor ecx, ecx
        mov dword [dword esp+08Ch], ecx
        jmp near .7
.2:
        xor esi, esi
        mov dword [criterrflag], esi
        mov ecx, 0FFFFFFFFh
        mov dword [nosplit eax*4+floppyok], ecx
        inc eax
        lea edx, [byte esp+07Ch]
        call _dos_getdiskfree_
        cmp dword [criterrflag], byte 0
        jne near .5
        mov al, byte [dword esp+08Ch]
        add al, 41h
        mov byte [str_floppydrv], al
        mov ecx, str_extID
        mov ebx, str_PLAYER
        mov edx, str_floppydrv
        lea eax, [byte esp+040h]
        call MakePath
        lea edx, [dword esp+090h]
        lea eax, [byte esp+040h]
        call FileOpenRead
        mov dword [dword esp+094h], eax
        test eax, eax
        jne short .3
        mov ecx, 0Bh
        mov ebx, 1
        lea edx, [byte esp+070h]
        mov eax, dword [dword esp+090h]
        call FileReadAt
        mov ecx, 0Dh
        mov ebx, 0FFFFFFFFh
        lea edx, [byte esp+060h]
        mov eax, dword [dword esp+090h]
        call FileReadAt
        lea edx, [byte esp+070h]
        mov eax, edi
        call stricmp_
        test eax, eax
        jne short .3
        lea edx, [byte esp+060h]
        mov eax, ebp
        call stricmp_
        test eax, eax
        je short .4
.3:
        mov esi, 0FFFFFFFFh
.4:
        lea eax, [dword esp+090h]
        call FileClose
        jmp short .6
.5:
        mov esi, ecx
.6:
        inc dword [dword esp+08Ch]
.7:
        mov eax, dword [dword esp+08Ch]
        cmp eax, byte 2
        jge short .8
        test esi, esi
        jne near FindLeagueFloppy.2
.8:
        xor edx, edx
        mov dword [floppyprobe], edx
        test esi, esi
        je short .9
        mov ebx, ebp
        mov edx, edi
        mov eax, esp
        call FmtFromLeague
        mov eax, esp
        mov dword [notforlgmsg+4], eax
        lea eax, [dword esp+084h]
        push eax
        lea eax, [dword esp+08Ch]
        push eax
        lea eax, [dword esp+094h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+088h]
        push eax
        lea eax, [dword esp+090h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 6
        mov ebx, notforlgmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [dword esp+094h], eax
        test eax, eax
        je short .9
        xor esi, esi
.9:
        test esi, esi
        jne near FindLeagueFloppy.1
        mov eax, dword [dword esp+094h]
        add esp, 98h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; WaitLeagueFloppy                             3D84F  95 PC, medium confidence
; "Insert disk" prompt for the team's league floppy, repeats FindLeagueFloppy
; until found or cancelled (4)
;-----------------------------------------------------------------------------
; C: src/pc/floppy_export/WaitLeagueFloppy.c
%ifdef CBUILD
%include "c/pc/floppy_export/WaitLeagueFloppy.inc"
%else
WaitLeagueFloppy:
        push dword 74h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4Ch
        mov esi, eax
        mov edi, edx
        mov ebp, ebx
        mov ebx, eax
        mov eax, esp
        call FmtFromLeague
        mov eax, esp
        mov dword [msg_InsertDisk_arg], eax
        lea eax, [byte esp+040h]
        push eax
        lea eax, [byte esp+048h]
        push eax
        lea eax, [byte esp+050h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+044h]
        push eax
        lea eax, [byte esp+04Ch]
        push eax
        push byte 0
        push byte 0
        mov ecx, 4
        mov ebx, msg_InsertDisk
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov edx, eax
        cmp eax, byte 4
        je short .1
        mov ebx, ebp
        mov edx, edi
        mov eax, esi
        call FindLeagueFloppy
        mov edx, eax
.1:
        cmp edx, byte 4
        jne short .2
        mov eax, 0FFFFFFFFh
        jmp short .x
.2:
        mov eax, edx
.x:
        add esp, byte 4Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadLeagueInfo                               3D8DD  95 PC, medium confidence
; Opens <league>\PINFO.DB and reads the fields WriteLeagueInfo writes into
; the caller's pointers (humancount, leaguemaster, leaguesaved, leagueflags,
; leagueteams, masterpw, savedname)
;-----------------------------------------------------------------------------
; C: src/pc/floppy_export/ReadLeagueInfo.c
%ifdef CBUILD
%include "c/pc/floppy_export/ReadLeagueInfo.inc"
%else
ReadLeagueInfo:
        push dword 6Ch
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 48h
        mov edi, eax
        mov dword [byte esp+044h], edx
        mov dword [byte esp+040h], ebx
        mov ebp, ecx
        mov dword [byte esp+038h], 0FFFFFFFFh
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, eax
        mov eax, esp
        call MakePath
        mov eax, esp
        push eax
        call sub_B3CC8
        add esp, byte 4
        test eax, eax
        jne near .1
        mov esi, 1
        mov edx, curleague
        lea eax, [byte esp+020h]
        call strcpy_
        mov ecx, ds
        mov ebx, str_dot
        mov edx, ds
        lea eax, [byte esp+020h]
        call _fstrcspn_
        xor dl, dl
        mov byte [byte esp+eax+020h], dl
        lea eax, [byte esp+020h]
        mov dword [lgreaderrmsg+4], eax
        push byte 0
        mov ecx, 11h
        mov ebx, 5
        mov edx, ecx
        mov eax, 0Bh
        call SetDialogColors
        lea eax, [byte esp+03Ch]
        push eax
        lea eax, [byte esp+034h]
        push eax
        lea eax, [byte esp+03Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+040h]
        push eax
        lea eax, [byte esp+038h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, lgreaderrmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp near .9
.1:
        lea edx, [byte esp+038h]
        mov eax, esp
        call FileOpenRead
        mov esi, eax
        test eax, eax
        jne short .2
        mov ecx, 2
        xor ebx, ebx
        mov edx, dword [byte esp+058h]
        mov eax, dword [byte esp+038h]
        call FileReadAt
        mov esi, eax
.2:
        test esi, esi
        jne short .3
        mov ecx, 2
        mov ebx, ecx
        mov edx, ebp
        mov eax, dword [byte esp+038h]
        call FileReadAt
        mov esi, eax
.3:
        test esi, esi
        jne short .4
        mov ecx, 2
        mov ebx, 4
        mov edx, dword [byte esp+060h]
        mov eax, dword [byte esp+038h]
        call FileReadAt
        mov esi, eax
.4:
        test esi, esi
        jne short .5
        mov ecx, 0Dh
        mov ebx, 6
        mov edx, dword [byte esp+064h]
        mov eax, dword [byte esp+038h]
        call FileReadAt
        mov esi, eax
.5:
        test esi, esi
        jne short .6
        mov ecx, 2
        mov ebx, 13h
        mov edx, dword [byte esp+05Ch]
        mov eax, dword [byte esp+038h]
        call FileReadAt
        mov esi, eax
.6:
        test esi, esi
        jne short .7
        mov ecx, 0Bh
        mov ebx, 15h
        mov edx, dword [byte esp+040h]
        mov eax, dword [byte esp+038h]
        call FileReadAt
        mov esi, eax
.7:
        test esi, esi
        jne short .8
        mov ecx, 30Ch
        mov ebx, 20h
        mov edx, dword [byte esp+044h]
        mov eax, dword [byte esp+038h]
        call FileReadAt
        mov esi, eax
.8:
        lea eax, [byte esp+038h]
        call FileClose
        mov ecx, str_Sav2
        mov ebx, str_Game2
        mov edx, edi
        mov eax, esp
        call MakePath
        mov eax, esp
        call FileExists
        mov edx, dword [byte esp+060h]
        mov dword [edx], eax
.9:
        mov eax, esi
        add esp, byte 48h
        pop ebp
        pop edi
        pop esi
        ret 10h
%endif ; C
;-----------------------------------------------------------------------------
; ReadTeamNames                                                   3DAB9  95 PC
; (path, dst, full): reads the 26 team names from the team DB (2E8h records,
; +05h 15h-byte full name or +1Ah 0Dh-byte short name) into dst[21 * i]
;-----------------------------------------------------------------------------
; C: src/pc/floppy_export/ReadTeamNames.c
%ifdef CBUILD
%include "c/pc/floppy_export/ReadTeamNames.inc"
%else
ReadTeamNames:
        push dword 18h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ebp, edx
        mov edi, ebx
        mov dword [esp], 0FFFFFFFFh
        mov edx, esp
        call FileOpenRead
        mov edx, eax
        test eax, eax
        jne short .5
        xor esi, esi
        jmp short .4
.1:
        mov ebx, esi
        shl ebx, 2
        add ebx, esi
        shl ebx, 2
        add ebx, esi
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        lea edx, [ebx+ebp]
        test edi, edi
        je short .2
        lea ebx, [byte eax+05h]
        mov ecx, 15h
        jmp short .3
.2:
        lea ebx, [byte eax+01Ah]
        mov ecx, 0Dh
.3:
        mov eax, dword [esp]
        call FileReadAt
        mov edx, eax
        inc esi
.4:
        cmp esi, byte 1Ah
        jge short .5
        test edx, edx
        je short ReadTeamNames.1
.5:
        mov eax, esp
        call FileClose
        mov eax, edx
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
