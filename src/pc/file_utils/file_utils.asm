; Files. Opening and copying the databases, the record readers and writers, and checking free disk space.
bits 32
%include "hockey.inc"
section s_1431E progbits alloc exec nowrite align=1
extern __CHK, _dos_close_, _dos_creat_, _dos_getdiskfree_, _dos_open_, _dos_read_, _dos_write_, awlineind
extern awpanelspr, clockcolon, clockdigits, curleague, DrawEnergyBar, DrawLineGroupBars, DrawPanelClockDigits, DrawPanelPenalties
extern dword_C56C4, dword_C56E4, dword_C5710, dword_C5714, dword_C5718, dword_C583C, dword_C5844, dword_C5848
extern dword_C5854, dword_C5858, dword_C585C, dword_C5860, FatalError, gmode, hmlineind, hmpanelspr
extern hudawayline, hudclockhund, hudclockmin, hudclocksec, hudhomeline, hudhundstep, hudpenaway, hudpenhome
extern j_unlink_, lcboxon, leaguedbnames, linesprites, lseek_, MessageBox, MouseSetPos, msg_NeedKbytes
extern off_C56B5, rmdir_, scoredigits, SelectRinkBM, SelectScreenBM, sprintf_, str_backslash2, str_dot
extern str_ErrDiskFree4, str_ErrDiskFree5, str_GsummaryDb, str_NeedKbytesFmt, str_star, strcat_, strcpy_, sub_B4CD8
extern sub_B4CF2, TeamLineEnergy, TickPanelClock, TickPanelPenalties, unknown_libname_1, unknown_libname_2
global MakePath, DeleteFiles, DeleteDir, FileOpenRead, FileOpenRead_x, FileOpenWrite, FileOpenRW, FileCreate
global FileClose, FileReadAt, FileReadAt_x, FileReadAt_x2, FileWriteAt, ReadKeyRec, ReadKeyRec_x, WriteKeyRec
global CopyFile, ReadSeasonRec, ReadSchedGame, ReadTeamRec, ReadTeamRec_x, ReadGSummaryRec, DiskSpaceShort, CheckGameDiskSpace
global GetLeagueDBSizes
; C: src/pc/file_utils/MakePath.c
%ifdef CBUILD
%include "c/pc/file_utils/MakePath.inc"
%else
MakePath:
push dword 8	; 1431E
call __CHK	; 14323
push esi	; 14328
mov esi, eax	; 14329
test edx, edx	; 1432B
je short .1	; 1432D
cmp byte [edx], 0	; 1432F
je short .1	; 14332
mov eax, esi	; 14334
call strcpy_	; 14336
mov edx, str_backslash2	; 1433B
mov eax, esi	; 14340
call strcat_	; 14342
jmp short .2	; 14347
.1:
mov byte [esi], 0	; 14349
.2:
test ebx, ebx	; 1434C
je short .3	; 1434E
mov edx, ebx	; 14350
mov eax, esi	; 14352
call strcat_	; 14354
.3:
test ecx, ecx	; 14359
je short .x	; 1435B
mov edx, ecx	; 1435D
mov eax, esi	; 1435F
call strcat_	; 14361
.x:
pop esi	; 14366
ret	; 14367
%endif ; C
; C: src/pc/file_utils/DeleteFiles.c
%ifdef CBUILD
%include "c/pc/file_utils/DeleteFiles.inc"
%else
DeleteFiles:
push dword 58h	; 14368
call __CHK	; 1436D
push ecx	; 14372
push esi	; 14373
sub esp, byte 4Ch	; 14374
mov ecx, eax	; 14377
mov esi, edx	; 14379
mov edx, eax	; 1437B
lea eax, [byte esp+02Ch]	; 1437D
call strcpy_	; 14381
mov edx, str_backslash2	; 14386
lea eax, [byte esp+02Ch]	; 1438B
call strcat_	; 1438F
mov edx, esi	; 14394
lea eax, [byte esp+02Ch]	; 14396
call strcat_	; 1439A
mov edx, str_dot	; 1439F
lea eax, [byte esp+02Ch]	; 143A4
call strcat_	; 143A8
mov edx, ebx	; 143AD
lea eax, [byte esp+02Ch]	; 143AF
call strcat_	; 143B3
mov ebx, esp	; 143B8
xor edx, edx	; 143BA
lea eax, [byte esp+02Ch]	; 143BC
call unknown_libname_1	; 143C0
mov ebx, eax	; 143C5
test eax, eax	; 143C7
jne short .3	; 143C9
mov edx, ecx	; 143CB
lea eax, [byte esp+02Ch]	; 143CD
call strcpy_	; 143D1
mov edx, str_backslash2	; 143D6
lea eax, [byte esp+02Ch]	; 143DB
call strcat_	; 143DF
lea edx, [byte esp+01Eh]	; 143E4
lea eax, [byte esp+02Ch]	; 143E8
call strcat_	; 143EC
lea eax, [byte esp+02Ch]	; 143F1
call j_unlink_	; 143F5
.1:
mov eax, esp	; 143FA
call unknown_libname_2	; 143FC
mov ebx, eax	; 14401
test eax, eax	; 14403
jne short .2	; 14405
mov edx, ecx	; 14407
lea eax, [byte esp+02Ch]	; 14409
call strcpy_	; 1440D
mov edx, str_backslash2	; 14412
lea eax, [byte esp+02Ch]	; 14417
call strcat_	; 1441B
lea edx, [byte esp+01Eh]	; 14420
lea eax, [byte esp+02Ch]	; 14424
call strcat_	; 14428
lea eax, [byte esp+02Ch]	; 1442D
call j_unlink_	; 14431
.2:
test ebx, ebx	; 14436
je short DeleteFiles.1	; 14438
.3:
mov eax, ebx	; 1443A
add esp, byte 4Ch	; 1443C
pop esi	; 1443F
pop ecx	; 14440
ret	; 14441
%endif ; C
; C: src/pc/file_utils/DeleteDir.c
%ifdef CBUILD
%include "c/pc/file_utils/DeleteDir.inc"
%else
DeleteDir:
push dword 5Ch	; 14442
call __CHK	; 14447
push ebx	; 1444C
push ecx	; 1444D
push edx	; 1444E
sub esp, byte 4Ch	; 1444F
mov ecx, eax	; 14452
mov edx, eax	; 14454
lea eax, [byte esp+02Ch]	; 14456
call strcpy_	; 1445A
mov edx, str_backslash2	; 1445F
lea eax, [byte esp+02Ch]	; 14464
call strcat_	; 14468
mov edx, str_star	; 1446D
lea eax, [byte esp+02Ch]	; 14472
call strcat_	; 14476
mov edx, str_dot	; 1447B
lea eax, [byte esp+02Ch]	; 14480
call strcat_	; 14484
mov edx, str_star	; 14489
lea eax, [byte esp+02Ch]	; 1448E
call strcat_	; 14492
mov ebx, esp	; 14497
xor edx, edx	; 14499
lea eax, [byte esp+02Ch]	; 1449B
call unknown_libname_1	; 1449F
test eax, eax	; 144A4
jne short .3	; 144A6
mov edx, ecx	; 144A8
lea eax, [byte esp+02Ch]	; 144AA
call strcpy_	; 144AE
mov edx, str_backslash2	; 144B3
lea eax, [byte esp+02Ch]	; 144B8
call strcat_	; 144BC
lea edx, [byte esp+01Eh]	; 144C1
lea eax, [byte esp+02Ch]	; 144C5
call strcat_	; 144C9
lea eax, [byte esp+02Ch]	; 144CE
call j_unlink_	; 144D2
.1:
mov eax, esp	; 144D7
call unknown_libname_2	; 144D9
mov ebx, eax	; 144DE
test eax, eax	; 144E0
jne short .2	; 144E2
mov edx, ecx	; 144E4
lea eax, [byte esp+02Ch]	; 144E6
call strcpy_	; 144EA
mov edx, str_backslash2	; 144EF
lea eax, [byte esp+02Ch]	; 144F4
call strcat_	; 144F8
lea edx, [byte esp+01Eh]	; 144FD
lea eax, [byte esp+02Ch]	; 14501
call strcat_	; 14505
lea eax, [byte esp+02Ch]	; 1450A
call j_unlink_	; 1450E
.2:
test ebx, ebx	; 14513
je short DeleteDir.1	; 14515
.3:
mov eax, ecx	; 14517
call rmdir_	; 14519
add esp, byte 4Ch	; 1451E
pop edx	; 14521
pop ecx	; 14522
pop ebx	; 14523
ret	; 14524
%endif ; C
; C: src/pc/file_utils/FileOpenRead.c
%ifdef CBUILD
%include "c/pc/file_utils/FileOpenRead.inc"
%else
FileOpenRead:
push dword 8	; 14525
call __CHK	; 1452A
push ebx	; 1452F
mov ebx, edx	; 14530
mov edx, 40h	; 14532
FileOpenRead_x:
call _dos_open_	; 14537
pop ebx	; 1453C
ret	; 1453D
FileOpenWrite:
push dword 8	; 1453E
call __CHK	; 14543
push ebx	; 14548
mov ebx, edx	; 14549
mov edx, 41h	; 1454B
jmp short FileOpenRead_x	; 14550
FileOpenRW:
push dword 8	; 14552
call __CHK	; 14557
push ebx	; 1455C
mov ebx, edx	; 1455D
mov edx, 42h	; 1455F
jmp short FileOpenRead_x	; 14564
%endif ; C
; C: src/pc/file_utils/FileCreate.c
%ifdef CBUILD
%include "c/pc/file_utils/FileCreate.inc"
%else
FileCreate:
push dword 8	; 14566
call __CHK	; 1456B
push ebx	; 14570
mov ebx, edx	; 14571
xor edx, edx	; 14573
call _dos_creat_	; 14575
pop ebx	; 1457A
ret	; 1457B
%endif ; C
; C: src/pc/file_utils/FileClose.c
%ifdef CBUILD
%include "c/pc/file_utils/FileClose.inc"
%else
FileClose:
push dword 0Ch	; 1457C
call __CHK	; 14581
push ebx	; 14586
push edx	; 14587
mov edx, eax	; 14588
xor eax, eax	; 1458A
mov ebx, dword [edx]	; 1458C
test ebx, ebx	; 1458E
jl short .1	; 14590
mov eax, ebx	; 14592
call _dos_close_	; 14594
.1:
mov dword [edx], 0FFFFFFFFh	; 14599
pop edx	; 1459F
pop ebx	; 145A0
ret	; 145A1
%endif ; C
; C: src/pc/file_utils/FileReadAt.c
%ifdef CBUILD
%include "c/pc/file_utils/FileReadAt.inc"
%else
FileReadAt:
push dword 18h	; 145A2
call __CHK	; 145A7
push esi	; 145AC
push edi	; 145AD
push ebp	; 145AE
sub esp, byte 4	; 145AF
mov esi, eax	; 145B2
mov ebp, edx	; 145B4
mov edx, ebx	; 145B6
mov edi, ecx	; 145B8
xor ecx, ecx	; 145BA
test ebx, ebx	; 145BC
jl short .1	; 145BE
xor ebx, ebx	; 145C0
call lseek_	; 145C2
test eax, eax	; 145C7
jge short .1	; 145C9
mov ecx, 0FFFFFFFFh	; 145CB
.1:
test ecx, ecx	; 145D0
jne short FileReadAt_x2	; 145D2
mov eax, esp	; 145D4
push eax	; 145D6
mov ecx, ds	; 145D7
mov edx, edi	; 145D9
mov ebx, ebp	; 145DB
mov eax, esi	; 145DD
call _dos_read_	; 145DF
FileReadAt_x:
mov ecx, eax	; 145E4
FileReadAt_x2:
cmp edi, dword [esp]	; 145E6
je short .4	; 145E9
mov ecx, 1	; 145EB
.4:
mov eax, ecx	; 145F0
add esp, byte 4	; 145F2
pop ebp	; 145F5
pop edi	; 145F6
pop esi	; 145F7
ret	; 145F8
%endif ; C
; C: src/pc/file_utils/FileReadAt.c (FileWriteAt)
%ifdef CBUILD
%include "c/pc/file_utils/FileReadAt.FileWriteAt.inc"
%else
FileWriteAt:
push dword 18h	; 145F9
call __CHK	; 145FE
push esi	; 14603
push edi	; 14604
push ebp	; 14605
sub esp, byte 4	; 14606
mov esi, eax	; 14609
mov ebp, edx	; 1460B
mov edx, ebx	; 1460D
mov edi, ecx	; 1460F
xor ecx, ecx	; 14611
test ebx, ebx	; 14613
jl short .1	; 14615
xor ebx, ebx	; 14617
call lseek_	; 14619
test eax, eax	; 1461E
jge short .1	; 14620
mov ecx, 0FFFFFFFFh	; 14622
.1:
test ecx, ecx	; 14627
jne short FileReadAt_x2	; 14629
mov eax, esp	; 1462B
push eax	; 1462D
mov ecx, ds	; 1462E
mov edx, edi	; 14630
mov ebx, ebp	; 14632
mov eax, esi	; 14634
call _dos_write_	; 14636
jmp short FileReadAt_x	; 1463B
%endif ; C
; C: src/pc/file_utils/ReadKeyRec.c
%ifdef CBUILD
%include "c/pc/file_utils/ReadKeyRec.inc"
%else
ReadKeyRec:
push dword 8	; 1463D
call __CHK	; 14642
push ecx	; 14647
mov ecx, 34h	; 14648
ReadKeyRec_x:
call FileReadAt	; 1464D
pop ecx	; 14652
ret	; 14653
WriteKeyRec:
push dword 8	; 14654
call __CHK	; 14659
push ecx	; 1465E
mov ecx, 34h	; 1465F
call FileWriteAt	; 14664
pop ecx	; 14669
ret	; 1466A
%endif ; C
; C: src/pc/file_utils/ReadKeyRec.c (CopyFile)
%ifdef CBUILD
%include "c/pc/file_utils/ReadKeyRec.CopyFile.inc"
%else
CopyFile:
push dword 460h	; 1466B
call __CHK	; 14670
push esi	; 14675
push edi	; 14676
sub esp, 450h	; 14677
mov esi, eax	; 1467D
mov edi, ebx	; 1467F
mov eax, ecx	; 14681
mov ebx, 0FFFFFFFFh	; 14683
mov dword [dword esp+0444h], ebx	; 14688
mov dword [dword esp+044Ch], ebx	; 1468F
mov ecx, edx	; 14696
mov ebx, esi	; 14698
mov edx, eax	; 1469A
lea eax, [dword esp+0400h]	; 1469C
call MakePath	; 146A3
lea edx, [dword esp+0444h]	; 146A8
lea eax, [dword esp+0400h]	; 146AF
call FileOpenRead	; 146B6
mov edx, eax	; 146BB
test eax, eax	; 146BD
jne short .1	; 146BF
mov ecx, edi	; 146C1
mov ebx, esi	; 146C3
mov edx, dword [dword esp+045Ch]	; 146C5
lea eax, [dword esp+0420h]	; 146CC
call MakePath	; 146D3
lea edx, [dword esp+044Ch]	; 146D8
lea eax, [dword esp+0420h]	; 146DF
call FileCreate	; 146E6
mov edx, eax	; 146EB
.1:
test edx, edx	; 146ED
jne near .4	; 146EF
.2:
lea eax, [dword esp+0440h]	; 146F5
push eax	; 146FC
mov edx, 400h	; 146FD
mov ecx, ds	; 14702
lea ebx, [byte esp+04h]	; 14704
mov eax, dword [dword esp+0448h]	; 14708
call _dos_read_	; 1470F
mov edx, eax	; 14714
test eax, eax	; 14716
jne short .3	; 14718
mov esi, dword [dword esp+0440h]	; 1471A
test esi, esi	; 14721
jbe short .3	; 14723
lea eax, [dword esp+0448h]	; 14725
push eax	; 1472C
mov edx, esi	; 1472D
mov ecx, ds	; 1472F
lea ebx, [byte esp+04h]	; 14731
mov eax, dword [dword esp+0450h]	; 14735
call _dos_write_	; 1473C
mov edx, eax	; 14741
mov eax, dword [dword esp+0448h]	; 14743
cmp eax, dword [dword esp+0440h]	; 1474A
je short .3	; 14751
mov edx, 1	; 14753
.3:
cmp dword [dword esp+0440h], byte 0	; 14758
jbe short .4	; 14760
test edx, edx	; 14762
je short CopyFile.2	; 14764
.4:
lea eax, [dword esp+044Ch]	; 14766
call FileClose	; 1476D
lea eax, [dword esp+0444h]	; 14772
call FileClose	; 14779
mov eax, edx	; 1477E
add esp, 450h	; 14780
pop edi	; 14786
pop esi	; 14787
ret 4	; 14788
%endif ; C
; C: src/pc/file_utils/ReadKeyRec.c (ReadSeasonRec)
%ifdef CBUILD
%include "c/pc/file_utils/ReadKeyRec.ReadSeasonRec.inc"
%else
ReadSeasonRec:
push dword 8	; 1478B
call __CHK	; 14790
push ecx	; 14795
mov ecx, 2Fh	; 14796
jmp near ReadKeyRec_x	; 1479B
%endif ; C
; C: src/pc/file_utils/ReadSchedGame.c
%ifdef CBUILD
%include "c/pc/file_utils/ReadSchedGame.inc"
%else
ReadSchedGame:
push dword 0Ch	; 147A0
call __CHK	; 147A5
push ecx	; 147AA
push esi	; 147AB
mov esi, eax	; 147AC
mov eax, ebx	; 147AE
shl eax, 2	; 147B0
sub eax, ebx	; 147B3
add eax, eax	; 147B5
lea ebx, [byte eax+02h]	; 147B7
mov ecx, 6	; 147BA
mov eax, esi	; 147BF
call FileReadAt	; 147C1
pop esi	; 147C6
pop ecx	; 147C7
ret	; 147C8
%endif ; C
; C: src/pc/file_utils/ReadTeamRec.c
%ifdef CBUILD
%include "c/pc/file_utils/ReadTeamRec.inc"
%else
ReadTeamRec:
push dword 10h	; 147C9
call __CHK	; 147CE
push ecx	; 147D3
push esi	; 147D4
push edi	; 147D5
mov edi, eax	; 147D6
mov esi, edx	; 147D8
mov edx, ebx	; 147DA
mov eax, ebx	; 147DC
shl eax, 2	; 147DE
sub eax, ebx	; 147E1
shl eax, 3	; 147E3
mov ebx, eax	; 147E6
shl ebx, 5	; 147E8
sub ebx, eax	; 147EB
mov ecx, 2E8h	; 147ED
mov edx, esi	; 147F2
mov eax, edi	; 147F4
ReadTeamRec_x:
call FileReadAt	; 147F6
pop edi	; 147FB
pop esi	; 147FC
pop ecx	; 147FD
ret	; 147FE
ReadGSummaryRec:
push dword 10h	; 147FF
call __CHK	; 14804
push ecx	; 14809
push esi	; 1480A
push edi	; 1480B
mov edi, eax	; 1480C
mov esi, edx	; 1480E
mov edx, ebx	; 14810
shl ebx, 2	; 14812
sub ebx, edx	; 14815
shl ebx, 2	; 14817
sub ebx, edx	; 1481A
mov ecx, 0Bh	; 1481C
mov edx, esi	; 14821
jmp short ReadTeamRec_x	; 14823
%endif ; C
; C: src/pc/file_utils/DiskSpaceShort.c
%ifdef CBUILD
%include "c/pc/file_utils/DiskSpaceShort.inc"
%else
DiskSpaceShort:
push dword 20h	; 14825
call __CHK	; 1482A
push ebx	; 1482F
push ecx	; 14830
push esi	; 14831
push edi	; 14832
sub esp, byte 8	; 14833
mov esi, edx	; 14836
xor edi, edi	; 14838
mov edx, esp	; 1483A
call _dos_getdiskfree_	; 1483C
test eax, eax	; 14841
je short .1	; 14843
push str_ErrDiskFree4	; 14845
call FatalError	; 1484A
add esp, byte 4	; 1484F
.1:
xor edx, edx	; 14852
mov dx, word [byte esp+06h]	; 14854
xor eax, eax	; 14859
mov ax, word [byte esp+04h]	; 1485B
imul edx, eax	; 14860
mov eax, edx	; 14863
sar edx, 1Fh	; 14865
shl edx, 0Ah	; 14868
LD sbb, eax, edx	; 1486B
sar eax, 0Ah	; 1486D
mov ebx, eax	; 14870
jmp short .3	; 14872
.2:
add edx, ebx	; 14874
dec edx	; 14876
mov eax, edx	; 14877
sar edx, 1Fh	; 14879
idiv ebx	; 1487C
add edi, eax	; 1487E
add esi, byte 4	; 14880
.3:
mov edx, dword [esi]	; 14883
test edx, edx	; 14885
jne short DiskSpaceShort.2	; 14887
xor eax, eax	; 14889
mov ax, word [byte esp+02h]	; 1488B
cmp edi, eax	; 14890
jg short .4	; 14892
xor eax, eax	; 14894
jmp short .x	; 14896
.4:
mov eax, edi	; 14898
imul eax, ebx	; 1489A
.x:
add esp, byte 8	; 1489D
pop edi	; 148A0
pop esi	; 148A1
pop ecx	; 148A2
pop ebx	; 148A3
ret	; 148A4
%endif ; C
; C: src/pc/file_utils/CheckGameDiskSpace.c
%ifdef CBUILD
%include "c/pc/file_utils/CheckGameDiskSpace.inc"
%else
CheckGameDiskSpace:
push dword 88h	; 148A5
call __CHK	; 148AA
push ebx	; 148AF
push ecx	; 148B0
push edx	; 148B1
push esi	; 148B2
push edi	; 148B3
sub esp, byte 5Ch	; 148B4
mov dword [byte esp+058h], 140h	; 148B7
mov dword [byte esp+054h], 0F0h	; 148BF
lea edx, [byte esp+04Ch]	; 148C7
xor eax, eax	; 148CB
call _dos_getdiskfree_	; 148CD
test eax, eax	; 148D2
je short .1	; 148D4
push str_ErrDiskFree5	; 148D6
call FatalError	; 148DB
add esp, byte 4	; 148E0
.1:
xor eax, eax	; 148E3
mov ax, word [byte esp+050h]	; 148E5
xor esi, esi	; 148EA
mov si, word [byte esp+052h]	; 148EC
imul esi, eax	; 148F1
lea edx, [dword esi+01FFFh]	; 148F4
mov eax, edx	; 148FA
sar edx, 1Fh	; 148FC
idiv esi	; 148FF
mov edi, eax	; 14901
xor ecx, ecx	; 14903
mov ebx, str_GsummaryDb	; 14905
mov edx, curleague	; 1490A
lea eax, [byte esp+02Ch]	; 1490F
call MakePath	; 14913
mov ebx, esp	; 14918
xor edx, edx	; 1491A
lea eax, [byte esp+02Ch]	; 1491C
call unknown_libname_1	; 14920
test eax, eax	; 14925
jne short .2	; 14927
cmp esi, 2000h	; 14929
jge near .x	; 1492F
mov eax, dword [byte esp+01Ah]	; 14935
add eax, esi	; 14939
dec eax	; 1493B
xor edx, edx	; 1493C
div esi	; 1493E
sub edi, eax	; 14940
.2:
xor eax, eax	; 14942
mov ax, word [byte esp+04Eh]	; 14944
cmp edi, eax	; 14949
jg short .3	; 1494B
xor eax, eax	; 1494D
jmp short .x	; 1494F
.3:
mov edx, edi	; 14951
imul edx, esi	; 14953
mov eax, edx	; 14956
sar edx, 1Fh	; 14958
shl edx, 0Ah	; 1495B
LD sbb, eax, edx	; 1495E
sar eax, 0Ah	; 14960
push eax	; 14963
push str_NeedKbytesFmt	; 14964
push msg_NeedKbytes	; 14969
call sprintf_	; 1496E
add esp, byte 0Ch	; 14973
mov ecx, dword [byte esp+054h]	; 14976
push ecx	; 1497A
mov esi, dword [byte esp+05Ch]	; 1497B
push esi	; 1497F
call MouseSetPos	; 14980
add esp, byte 8	; 14985
push dword 320h	; 14988
lea eax, [byte esp+058h]	; 1498D
push eax	; 14991
lea eax, [byte esp+060h]	; 14992
push eax	; 14996
push byte 0	; 14997
push byte 0	; 14999
mov ecx, 3	; 1499B
mov ebx, off_C56B5	; 149A0
mov edx, 0FFFFFFFFh	; 149A5
mov eax, edx	; 149AA
call MessageBox	; 149AC
mov eax, 1	; 149B1
.x:
add esp, byte 5Ch	; 149B6
pop edi	; 149B9
pop esi	; 149BA
pop edx	; 149BB
pop ecx	; 149BC
pop ebx	; 149BD
ret	; 149BE
%endif ; C
; C: src/pc/file_utils/GetLeagueDBSizes.c
%ifdef CBUILD
%include "c/pc/file_utils/GetLeagueDBSizes.inc"
%else
GetLeagueDBSizes:
push dword 68h	; 149BF
call __CHK	; 149C4
push ecx	; 149C9
push esi	; 149CA
push edi	; 149CB
push ebp	; 149CC
sub esp, byte 4Ch	; 149CD
push eax	; 149D0
push edx	; 149D1
mov ebp, ebx	; 149D2
xor esi, esi	; 149D4
.1:
mov edi, esi	; 149D6
shl edi, 2	; 149D8
mov ebx, dword [dword edi+leaguedbnames]	; 149DB
mov ecx, ebp	; 149E1
mov edx, dword [byte esp+04h]	; 149E3
lea eax, [byte esp+034h]	; 149E7
call MakePath	; 149EB
lea ebx, [byte esp+08h]	; 149F0
xor edx, edx	; 149F4
lea eax, [byte esp+034h]	; 149F6
call unknown_libname_1	; 149FA
mov eax, dword [byte esp+022h]	; 149FF
add eax, 3FFh	; 14A03
shr eax, 0Ah	; 14A08
add edi, dword [esp]	; 14A0B
mov dword [edi], eax	; 14A0E
inc esi	; 14A10
cmp esi, byte 7	; 14A11
jl short GetLeagueDBSizes.1	; 14A14
xor eax, eax	; 14A16
add esp, byte 54h	; 14A18
pop ebp	; 14A1B
pop edi	; 14A1C
pop esi	; 14A1D
pop ecx	; 14A1E
ret	; 14A1F
%endif ; C
