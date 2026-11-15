; Files. Opening and copying the databases, the record readers and writers, and checking free disk space.
bits 32
%include "hockey.inc"
section s_1431E progbits alloc exec nowrite align=1
extern __CHK, _dos_close_, _dos_creat_, _dos_getdiskfree_, _dos_open_, _dos_read_, _dos_write_, awlineind
extern awpanelspr, clockcolon, clockdigits, curleague, DrawEnergyBar, DrawLineGroupBars, DrawPanelClockDigits, DrawPanelPenalties
extern awlineenergies, hmlineenergies, panelprevmin, panelprevsec, panelprevhund, panelhund, hmpanellines, awpanellines
extern hmpanelpens, awpanelpens, hmlinetimer, awlinetimer, FatalError, gmode, hmlineind, hmpanelspr
extern hudawayline, hudclockhund, hudclockmin, hudclocksec, hudhomeline, hudhundstep, hudpenaway, hudpenhome
extern j_unlink_, lcboxon, leaguedbnames, linesprites, lseek_, MessageBox, MouseSetPos, msg_NeedKbytes
extern msg_GameDiskSpace, rmdir_, scoredigits, SelectRinkBM, SelectScreenBM, sprintf_, str_backslash2, str_dot
extern str_ErrDiskFree4, str_ErrDiskFree5, str_GsummaryDb, str_NeedKbytesFmt, str_star, strcat_, strcpy_, sub_B4CD8
extern sub_B4CF2, TeamLineEnergy, TickPanelClock, TickPanelPenalties, unknown_libname_1, unknown_libname_2
global MakePath, DeleteFiles, DeleteDir, FileOpenRead, FileOpenRead_x, FileOpenWrite, FileOpenRW, FileCreate
global FileClose, FileReadAt, FileReadAt_x, FileReadAt_x2, FileWriteAt, ReadKeyRec, ReadKeyRec_x, WriteKeyRec
global CopyFile, ReadSeasonRec, ReadSchedGame, ReadTeamRec, ReadTeamRec_x, ReadGSummaryRec, DiskSpaceShort, CheckGameDiskSpace
global GetLeagueDBSizes
;-----------------------------------------------------------------------------
; MakePath                                                        1431E  95 PC
; Dst = dir + '\' (when dir non-empty) + name + ext
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/MakePath.c
%ifdef CBUILD
%include "c/pc/file_utils/MakePath.inc"
%else
MakePath:
        push dword 8
        call __CHK
        push esi
        mov esi, eax
        test edx, edx
        je short .1
        cmp byte [edx], 0
        je short .1
        mov eax, esi
        call strcpy_
        mov edx, str_backslash2
        mov eax, esi
        call strcat_
        jmp short .2
.1:
        mov byte [esi], 0
.2:
        test ebx, ebx
        je short .3
        mov edx, ebx
        mov eax, esi
        call strcat_
.3:
        test ecx, ecx
        je short .x
        mov edx, ecx
        mov eax, esi
        call strcat_
.x:
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DeleteFiles                                                     14368  95 PC
; (dir, name, ext): _dos_findfirst / _dos_findnext on dir\name.ext and
; unlinks every match
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/DeleteFiles.c
%ifdef CBUILD
%include "c/pc/file_utils/DeleteFiles.inc"
%else
DeleteFiles:
        push dword 58h
        call __CHK
        push ecx
        push esi
        sub esp, byte 4Ch
        mov ecx, eax
        mov esi, edx
        mov edx, eax
        lea eax, [byte esp+02Ch]
        call strcpy_
        mov edx, str_backslash2
        lea eax, [byte esp+02Ch]
        call strcat_
        mov edx, esi
        lea eax, [byte esp+02Ch]
        call strcat_
        mov edx, str_dot
        lea eax, [byte esp+02Ch]
        call strcat_
        mov edx, ebx
        lea eax, [byte esp+02Ch]
        call strcat_
        mov ebx, esp
        xor edx, edx
        lea eax, [byte esp+02Ch]
        call unknown_libname_1
        mov ebx, eax
        test eax, eax
        jne short .3
        mov edx, ecx
        lea eax, [byte esp+02Ch]
        call strcpy_
        mov edx, str_backslash2
        lea eax, [byte esp+02Ch]
        call strcat_
        lea edx, [byte esp+01Eh]
        lea eax, [byte esp+02Ch]
        call strcat_
        lea eax, [byte esp+02Ch]
        call j_unlink_
.1:
        mov eax, esp
        call unknown_libname_2
        mov ebx, eax
        test eax, eax
        jne short .2
        mov edx, ecx
        lea eax, [byte esp+02Ch]
        call strcpy_
        mov edx, str_backslash2
        lea eax, [byte esp+02Ch]
        call strcat_
        lea edx, [byte esp+01Eh]
        lea eax, [byte esp+02Ch]
        call strcat_
        lea eax, [byte esp+02Ch]
        call j_unlink_
.2:
        test ebx, ebx
        je short DeleteFiles.1
.3:
        mov eax, ebx
        add esp, byte 4Ch
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DeleteDir                                                       14442  95 PC
; (dir): unlinks dir\*.* (_dos_findfirst / _dos_findnext) then rmdir
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/DeleteDir.c
%ifdef CBUILD
%include "c/pc/file_utils/DeleteDir.inc"
%else
DeleteDir:
        push dword 5Ch
        call __CHK
        push ebx
        push ecx
        push edx
        sub esp, byte 4Ch
        mov ecx, eax
        mov edx, eax
        lea eax, [byte esp+02Ch]
        call strcpy_
        mov edx, str_backslash2
        lea eax, [byte esp+02Ch]
        call strcat_
        mov edx, str_star
        lea eax, [byte esp+02Ch]
        call strcat_
        mov edx, str_dot
        lea eax, [byte esp+02Ch]
        call strcat_
        mov edx, str_star
        lea eax, [byte esp+02Ch]
        call strcat_
        mov ebx, esp
        xor edx, edx
        lea eax, [byte esp+02Ch]
        call unknown_libname_1
        test eax, eax
        jne short .3
        mov edx, ecx
        lea eax, [byte esp+02Ch]
        call strcpy_
        mov edx, str_backslash2
        lea eax, [byte esp+02Ch]
        call strcat_
        lea edx, [byte esp+01Eh]
        lea eax, [byte esp+02Ch]
        call strcat_
        lea eax, [byte esp+02Ch]
        call j_unlink_
.1:
        mov eax, esp
        call unknown_libname_2
        mov ebx, eax
        test eax, eax
        jne short .2
        mov edx, ecx
        lea eax, [byte esp+02Ch]
        call strcpy_
        mov edx, str_backslash2
        lea eax, [byte esp+02Ch]
        call strcat_
        lea edx, [byte esp+01Eh]
        lea eax, [byte esp+02Ch]
        call strcat_
        lea eax, [byte esp+02Ch]
        call j_unlink_
.2:
        test ebx, ebx
        je short DeleteDir.1
.3:
        mov eax, ecx
        call rmdir_
        add esp, byte 4Ch
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FileOpenRead                                                    14525  95 PC
; _dos_open(path, 40h read/deny-none, &handle)
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/FileOpenRead.c
%ifdef CBUILD
%include "c/pc/file_utils/FileOpenRead.inc"
%else
FileOpenRead:
        push dword 8
        call __CHK
        push ebx
        mov ebx, edx
        mov edx, 40h
FileOpenRead_x:
        call _dos_open_
        pop ebx
        ret
;-----------------------------------------------------------------------------
; FileOpenWrite                                                   1453E  95 PC
; _dos_open(path, 41h write/deny-none, &handle)
;-----------------------------------------------------------------------------
FileOpenWrite:
        push dword 8
        call __CHK
        push ebx
        mov ebx, edx
        mov edx, 41h
        jmp short FileOpenRead_x
;-----------------------------------------------------------------------------
; FileOpenRW                                                      14552  95 PC
; _dos_open(path, 42h read-write/deny-none, &handle)
;-----------------------------------------------------------------------------
FileOpenRW:
        push dword 8
        call __CHK
        push ebx
        mov ebx, edx
        mov edx, 42h
        jmp short FileOpenRead_x
%endif ; C
;-----------------------------------------------------------------------------
; FileCreate                                                      14566  95 PC
; _dos_creat(path, 0, &handle)
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/FileCreate.c
%ifdef CBUILD
%include "c/pc/file_utils/FileCreate.inc"
%else
FileCreate:
        push dword 8
        call __CHK
        push ebx
        mov ebx, edx
        xor edx, edx
        call _dos_creat_
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FileClose                                                       1457C  95 PC
; _dos_close(*handle) when >= 0, then *handle = -1
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/FileClose.c
%ifdef CBUILD
%include "c/pc/file_utils/FileClose.inc"
%else
FileClose:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, eax
        xor eax, eax
        mov ebx, dword [edx]
        test ebx, ebx
        jl short .1
        mov eax, ebx
        call _dos_close_
.1:
        mov dword [edx], 0FFFFFFFFh
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FileReadAt                                                      145A2  95 PC
; (handle, buf, offset (<0 = current), len): lseek then _dos_read; 0 ok, 1
; short read, -1 seek error
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/FileReadAt.c
%ifdef CBUILD
%include "c/pc/file_utils/FileReadAt.inc"
%else
FileReadAt:
        push dword 18h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov ebp, edx
        mov edx, ebx
        mov edi, ecx
        xor ecx, ecx
        test ebx, ebx
        jl short .1
        xor ebx, ebx
        call lseek_
        test eax, eax
        jge short .1
        mov ecx, 0FFFFFFFFh
.1:
        test ecx, ecx
        jne short FileReadAt_x2
        mov eax, esp
        push eax
        mov ecx, ds
        mov edx, edi
        mov ebx, ebp
        mov eax, esi
        call _dos_read_
FileReadAt_x:
        mov ecx, eax
FileReadAt_x2:
        cmp edi, dword [esp]
        je short .4
        mov ecx, 1
.4:
        mov eax, ecx
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FileWriteAt                                                     145F9  95 PC
; (handle, buf, offset (<0 = current), len): lseek then _dos_write; 0 ok, 1
; short write
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/FileReadAt.c (FileWriteAt)
%ifdef CBUILD
%include "c/pc/file_utils/FileReadAt.FileWriteAt.inc"
%else
FileWriteAt:
        push dword 18h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov ebp, edx
        mov edx, ebx
        mov edi, ecx
        xor ecx, ecx
        test ebx, ebx
        jl short .1
        xor ebx, ebx
        call lseek_
        test eax, eax
        jge short .1
        mov ecx, 0FFFFFFFFh
.1:
        test ecx, ecx
        jne short FileReadAt_x2
        mov eax, esp
        push eax
        mov ecx, ds
        mov edx, edi
        mov ebx, ebp
        mov eax, esi
        call _dos_write_
        jmp short FileReadAt_x
%endif ; C
;-----------------------------------------------------------------------------
; ReadKeyRec                                   1463D  95 PC, medium confidence
; FileReadAt(handle, buf, offset, 34h): one KEY.DB player record
; (PickAwardWinners and game_setup pass the leaguedbnames[0] KEY handle)
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/ReadKeyRec.c
%ifdef CBUILD
%include "c/pc/file_utils/ReadKeyRec.inc"
%else
ReadKeyRec:
        push dword 8
        call __CHK
        push ecx
        mov ecx, 34h
ReadKeyRec_x:
        call FileReadAt
        pop ecx
        ret
;-----------------------------------------------------------------------------
; WriteKeyRec                                  14654  95 PC, medium confidence
; FileWriteAt(handle, buf, offset, 34h): KEY.DB record write counterpart of
; ReadKeyRec (roster_jersey)
;-----------------------------------------------------------------------------
WriteKeyRec:
        push dword 8
        call __CHK
        push ecx
        mov ecx, 34h
        call FileWriteAt
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CopyFile                                                        1466B  95 PC
; Builds the source and destination paths with MakePath, FileOpenRead /
; FileCreate, copies in 400h-byte _dos_read / _dos_write blocks; returns 0
; ok, else the error
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/ReadKeyRec.c (CopyFile)
%ifdef CBUILD
%include "c/pc/file_utils/ReadKeyRec.CopyFile.inc"
%else
CopyFile:
        push dword 460h
        call __CHK
        push esi
        push edi
        sub esp, 450h
        mov esi, eax
        mov edi, ebx
        mov eax, ecx
        mov ebx, 0FFFFFFFFh
        mov dword [dword esp+0444h], ebx
        mov dword [dword esp+044Ch], ebx
        mov ecx, edx
        mov ebx, esi
        mov edx, eax
        lea eax, [dword esp+0400h]
        call MakePath
        lea edx, [dword esp+0444h]
        lea eax, [dword esp+0400h]
        call FileOpenRead
        mov edx, eax
        test eax, eax
        jne short .1
        mov ecx, edi
        mov ebx, esi
        mov edx, dword [dword esp+045Ch]
        lea eax, [dword esp+0420h]
        call MakePath
        lea edx, [dword esp+044Ch]
        lea eax, [dword esp+0420h]
        call FileCreate
        mov edx, eax
.1:
        test edx, edx
        jne near .4
.2:
        lea eax, [dword esp+0440h]
        push eax
        mov edx, 400h
        mov ecx, ds
        lea ebx, [byte esp+04h]
        mov eax, dword [dword esp+0448h]
        call _dos_read_
        mov edx, eax
        test eax, eax
        jne short .3
        mov esi, dword [dword esp+0440h]
        test esi, esi
        jbe short .3
        lea eax, [dword esp+0448h]
        push eax
        mov edx, esi
        mov ecx, ds
        lea ebx, [byte esp+04h]
        mov eax, dword [dword esp+0450h]
        call _dos_write_
        mov edx, eax
        mov eax, dword [dword esp+0448h]
        cmp eax, dword [dword esp+0440h]
        je short .3
        mov edx, 1
.3:
        cmp dword [dword esp+0440h], byte 0
        jbe short .4
        test edx, edx
        je short CopyFile.2
.4:
        lea eax, [dword esp+044Ch]
        call FileClose
        lea eax, [dword esp+0444h]
        call FileClose
        mov eax, edx
        add esp, 450h
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; ReadSeasonRec                                1478B  95 PC, medium confidence
; FileReadAt(handle, buf, offset, 2Fh): one SEASON.DB player stat record
; (PickAwardWinners passes the leaguedbnames+14h SEASON handle)
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/ReadKeyRec.c (ReadSeasonRec)
%ifdef CBUILD
%include "c/pc/file_utils/ReadKeyRec.ReadSeasonRec.inc"
%else
ReadSeasonRec:
        push dword 8
        call __CHK
        push ecx
        mov ecx, 2Fh
        jmp near ReadKeyRec_x
%endif ; C
;-----------------------------------------------------------------------------
; ReadSchedGame                                                   147A0  95 PC
; FileReadAt(handle, buf, 2 + index*6, 6): one SCHEDULE.DB game (month, day,
; home, away, home score, away score; FFh = unplayed)
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/ReadSchedGame.c
%ifdef CBUILD
%include "c/pc/file_utils/ReadSchedGame.inc"
%else
ReadSchedGame:
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
        mov eax, esi
        call FileReadAt
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadTeamRec                                                     147C9  95 PC
; FileReadAt(handle, buf, index*2E8h, 2E8h): one TEAMS.DB record
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/ReadTeamRec.c
%ifdef CBUILD
%include "c/pc/file_utils/ReadTeamRec.inc"
%else
ReadTeamRec:
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
ReadTeamRec_x:
        call FileReadAt
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; ReadGSummaryRec                              147FF  95 PC, medium confidence
; FileReadAt(handle, buf, index*0Bh, 0Bh): one gsummary.db record (game_setup
; opens <league>\gsummary.db for it)
;-----------------------------------------------------------------------------
ReadGSummaryRec:
        push dword 10h
        call __CHK
        push ecx
        push esi
        push edi
        mov edi, eax
        mov esi, edx
        mov edx, ebx
        shl ebx, 2
        sub ebx, edx
        shl ebx, 2
        sub ebx, edx
        mov ecx, 0Bh
        mov edx, esi
        jmp short ReadTeamRec_x
%endif ; C
;-----------------------------------------------------------------------------
; DiskSpaceShort                               14825  95 PC, medium confidence
; (drive, 0-terminated file-size list): _dos_getdiskfree ("error getting disk
; space free" -> FatalError), rounds each size up to clusters; returns 0 when
; they fit, else the bytes needed
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/DiskSpaceShort.c
%ifdef CBUILD
%include "c/pc/file_utils/DiskSpaceShort.inc"
%else
DiskSpaceShort:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 8
        mov esi, edx
        xor edi, edi
        mov edx, esp
        call _dos_getdiskfree_
        test eax, eax
        je short .1
        push str_ErrDiskFree4
        call FatalError
        add esp, byte 4
.1:
        xor edx, edx
        mov dx, word [byte esp+06h]
        xor eax, eax
        mov ax, word [byte esp+04h]
        imul edx, eax
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        mov ebx, eax
        jmp short .3
.2:
        add edx, ebx
        dec edx
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        add edi, eax
        add esi, byte 4
.3:
        mov edx, dword [esi]
        test edx, edx
        jne short DiskSpaceShort.2
        xor eax, eax
        mov ax, word [byte esp+02h]
        cmp edi, eax
        jg short .4
        xor eax, eax
        jmp short .x
.4:
        mov eax, edi
        imul eax, ebx
.x:
        add esp, byte 8
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CheckGameDiskSpace                           148A5  95 PC, medium confidence
; Free space on the current drive against the growth of <league>\gsummary.db;
; when short, centres the mouse and shows the "To play the game, you require
; %2d Kbytes" MessageBox and returns 1, else 0
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/CheckGameDiskSpace.c
%ifdef CBUILD
%include "c/pc/file_utils/CheckGameDiskSpace.inc"
%else
CheckGameDiskSpace:
        push dword 88h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 5Ch
        mov dword [byte esp+058h], 140h
        mov dword [byte esp+054h], 0F0h
        lea edx, [byte esp+04Ch]
        xor eax, eax
        call _dos_getdiskfree_
        test eax, eax
        je short .1
        push str_ErrDiskFree5
        call FatalError
        add esp, byte 4
.1:
        xor eax, eax
        mov ax, word [byte esp+050h]
        xor esi, esi
        mov si, word [byte esp+052h]
        imul esi, eax
        lea edx, [dword esi+01FFFh]
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        mov edi, eax
        xor ecx, ecx
        mov ebx, str_GsummaryDb
        mov edx, curleague
        lea eax, [byte esp+02Ch]
        call MakePath
        mov ebx, esp
        xor edx, edx
        lea eax, [byte esp+02Ch]
        call unknown_libname_1
        test eax, eax
        jne short .2
        cmp esi, 2000h
        jge near .x
        mov eax, dword [byte esp+01Ah]
        add eax, esi
        dec eax
        xor edx, edx
        div esi
        sub edi, eax
.2:
        xor eax, eax
        mov ax, word [byte esp+04Eh]
        cmp edi, eax
        jg short .3
        xor eax, eax
        jmp short .x
.3:
        mov edx, edi
        imul edx, esi
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        push eax
        push str_NeedKbytesFmt
        push msg_NeedKbytes
        call sprintf_
        add esp, byte 0Ch
        mov ecx, dword [byte esp+054h]
        push ecx
        mov esi, dword [byte esp+05Ch]
        push esi
        call MouseSetPos
        add esp, byte 8
        push dword 320h
        lea eax, [byte esp+058h]
        push eax
        lea eax, [byte esp+060h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msg_GameDiskSpace
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov eax, 1
.x:
        add esp, byte 5Ch
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GetLeagueDBSizes                                                149BF  95 PC
; (out[7], ?, league dir): size in Kbytes of each of the 7 league DB files
; (leaguedbnames: KEY, CAREER, ATT, CARTEAMS, TEAMS, SEASON, SCHEDULE) via
; _dos_findfirst
;-----------------------------------------------------------------------------
; C: src/pc/file_utils/GetLeagueDBSizes.c
%ifdef CBUILD
%include "c/pc/file_utils/GetLeagueDBSizes.inc"
%else
GetLeagueDBSizes:
        push dword 68h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4Ch
        push eax
        push edx
        mov ebp, ebx
        xor esi, esi
.1:
        mov edi, esi
        shl edi, 2
        mov ebx, dword [dword edi+leaguedbnames]
        mov ecx, ebp
        mov edx, dword [byte esp+04h]
        lea eax, [byte esp+034h]
        call MakePath
        lea ebx, [byte esp+08h]
        xor edx, edx
        lea eax, [byte esp+034h]
        call unknown_libname_1
        mov eax, dword [byte esp+022h]
        add eax, 3FFh
        shr eax, 0Ah
        add edi, dword [esp]
        mov dword [edi], eax
        inc esi
        cmp esi, byte 7
        jl short GetLeagueDBSizes.1
        xor eax, eax
        add esp, byte 54h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
