; Reading a file off the CD as a stream of blocks.
bits 32
%include "hockey.inc"
section s_1B0F3 progbits alloc exec nowrite align=1
extern __CHK, addtimer, str_CDSTREAM, str_IllegalSecondaryStreamNumber, str_SECCDSTREAM, str_IllegalChunkSizeD, bannertimer, CrowdNoiseOff
extern cupseries, dword_C66B0, dword_DC8A0, dword_DC8C8, ovlartbank, FatalError, FreeMemBlock, FreeRinkGfx
extern FreeRockMusic, GameOver, hilightfont, joyq_flush, joysampling, numshpbank, ovlseq, photobankf
extern photobanks, RemoveTimerCallback, rinkbm, rinkendbank, s1font, scrbrdshapes, scrpitch, AllocMemBlock
extern sub_8DAB8, TextSetFont, sub_91FA4, bcopy, openhandle, DosCloseFile, DosReadFile, DosSeekFile
global sub_1B0F3, sub_1B18B, loc_1B1B7, sub_1B1C2, sub_1B1DF, sub_1B201, loc_1B218, loc_1B225
global jpt_1B283, sub_1B2A7, loc_1B2B4, loc_1B2D5, loc_1B2DC, loc_1B2E0, loc_1B2F0, loc_1B334
global loc_1B3AE, loc_1B42A, loc_1B468, loc_1B46D, loc_1B485, loc_1B49D, loc_1B4BC, loc_1B534
global loc_1B588, loc_1B5EB, loc_1B681, loc_1B721, loc_1B789, loc_1B799, loc_1B80C, sub_1B818
global sub_1B82B, loc_1B84F, loc_1B856, loc_1B859, loc_1B868, loc_1B86A, sub_1B871, sub_1B88A
global loc_1B8A7, sub_1B8AC, loc_1B8D0, loc_1B8E9, loc_1B8F9, loc_1B904, loc_1B908, loc_1B920
global loc_1B926, loc_1B92B, loc_1B92C, sub_1B92E, loc_1B94C, loc_1B963, loc_1B972, loc_1B977
global sub_1B982, loc_1B9C4, loc_1B9E4, loc_1B9FE, loc_1BA19, loc_1BA34, loc_1BA54, loc_1BA7E
global loc_1BA7F, sub_1BA85, loc_1BAA5, sub_1BAB1, loc_1BACC, loc_1BAEC, loc_1BAED, sub_1BAF3
global loc_1BB0E, loc_1BB18, loc_1BB33, loc_1BB71, loc_1BB86, loc_1BBB3, loc_1BBB4
sub_1B0F3:
        push dword 14h
        call __CHK
        push esi
        mov edx, dword [byte esp+010h]
        push edx
        mov eax, dword [byte esp+0Ch]
        add eax, byte 54h
        push eax
        push str_CDSTREAM
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        mov eax, dword [byte esp+08h]
        mov dword [byte esi+020h], eax
        mov eax, esi
        add eax, byte 54h
        mov dword [esi], eax
        mov edx, dword [byte esp+08h]
        add edx, eax
        mov dword [byte esi+04h], edx
        mov eax, dword [esi]
        mov dword [byte esi+014h], eax
        mov dword [byte esi+010h], eax
        mov dword [byte esi+08h], eax
        mov dword [byte esi+0Ch], eax
        mov eax, dword [byte esp+0Ch]
        mov dword [byte esi+024h], eax
        mov dword [byte esi+018h], 0
        mov dword [dword_DC8C8], esi
        mov dword [dword_DC8A0], esi
        mov dword [byte esi+01Ch], 7
        mov ebx, dword [dword_C66B0]
        push ebx
        push eax
        call sub_91FA4
        add esp, byte 8
        mov dword [byte esi+050h], eax
        mov dword [byte esi+04Ch], 0
        push sub_1B818
        call addtimer
        add esp, byte 4
        mov eax, esi
        pop esi
        ret
sub_1B18B:
        push dword 0Ch
        call __CHK
        push esi
        mov esi, dword [byte esp+08h]
        push sub_1B818
        call RemoveTimerCallback
        add esp, byte 4
        mov edx, dword [byte esi+018h]
        test edx, edx
        je short loc_1B1B7
        push edx
        call DosCloseFile
        add esp, byte 4
loc_1B1B7:
        push esi
        call FreeMemBlock
        add esp, byte 4
        pop esi
        ret
sub_1B1C2:
        push dword 4
        call __CHK
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov dword [byte eax+048h], edx
        mov dword [byte eax+01Ch], 1
        ret
sub_1B1DF:
        push dword 4
        call __CHK
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+034h]
        mov ebx, dword [byte esp+08h]
        add eax, ebx
        mov dword [byte edx+044h], eax
        mov dword [byte edx+01Ch], 2
        ret
sub_1B201:
        push dword 10h
        call __CHK
        mov edx, dword [byte esp+04h]
        test edx, edx
        jl short loc_1B218
        cmp edx, byte 9
        jle short loc_1B225
loc_1B218:
        push str_IllegalSecondaryStreamNumber
        call FatalError
        add esp, byte 4
loc_1B225:
        mov ecx, dword [byte esp+0Ch]
        push ecx
        mov eax, dword [byte esp+0Ch]
        add eax, byte 54h
        push eax
        push str_SECCDSTREAM
        call AllocMemBlock
        add esp, byte 0Ch
        mov edx, dword [byte esp+08h]
        mov dword [byte eax+020h], edx
        lea edx, [byte eax+054h]
        mov dword [eax], edx
        mov ebx, dword [byte esp+08h]
        add ebx, edx
        mov dword [byte eax+04h], ebx
        mov edx, dword [eax]
        mov dword [byte eax+014h], edx
        mov dword [byte eax+010h], edx
        mov dword [byte eax+08h], edx
        mov dword [byte eax+0Ch], edx
        mov dword [byte eax+024h], 0
        mov dword [byte eax+040h], 0
        mov dword [byte eax+038h], 1
        mov edx, dword [byte esp+04h]
        mov dword [nosplit edx*4+dword_DC8A0], eax
        ret
jpt_1B283:
        dd loc_1B2E0
        dd loc_1B334
        dd loc_1B3AE
        dd loc_1B4BC
        dd loc_1B5EB
        dd loc_1B681
        dd loc_1B2D5
        dd loc_1B2B4
        dd loc_1B799
sub_1B2A7:
        push dword 20h
        call __CHK
        push esi
        push edi
        push ebp
loc_1B2B4:
        mov edx, dword [dword_DC8A0]
        cmp dword [byte edx+04Ch], byte 0
        jg near loc_1B2DC
        mov eax, dword [byte edx+01Ch]
        dec eax
        cmp eax, byte 8
        ja short loc_1B2B4
        jmp dword [nosplit cs:eax*4+jpt_1B283]
loc_1B2D5:
        mov dword [byte edx+04Ch], 0
loc_1B2DC:
        pop ebp
        pop edi
        pop esi
        ret
loc_1B2E0:
        mov esi, dword [byte edx+018h]
        test esi, esi
        je short loc_1B2F0
        push esi
        call DosCloseFile
        add esp, byte 4
loc_1B2F0:
        mov eax, dword [dword_DC8A0]
        lea edx, [byte eax+03Ch]
        push edx
        lea edx, [byte eax+034h]
        push edx
        lea edx, [byte eax+018h]
        push edx
        mov ebp, dword [byte eax+048h]
        push ebp
        call openhandle
        add esp, byte 10h
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+034h]
        mov dword [byte eax+044h], edx
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+034h]
        mov ebx, dword [byte eax+03Ch]
        add edx, ebx
        mov dword [byte eax+038h], edx
        mov eax, dword [dword_DC8A0]
        mov dword [byte eax+01Ch], 2
loc_1B334:
        mov edx, dword [dword_DC8A0]
        mov eax, edx
        call sub_1B82B
        cmp eax, dword [byte edx+024h]
        jl short loc_1B2DC
        mov eax, dword [dword_DC8A0]
        mov dword [byte eax+01Ch], 3
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+0Ch]
        mov dword [byte eax+08h], edx
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+044h]
        mov dword [byte eax+040h], edx
        mov eax, dword [dword_DC8A0]
        mov esi, dword [byte eax+040h]
        push esi
        mov edi, dword [byte eax+018h]
        push edi
        call DosSeekFile
        add esp, byte 8
        mov eax, dword [dword_DC8A0]
        mov dword [byte eax+030h], 0
        mov ebp, dword [dword_C66B0]
        push ebp
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+024h]
        push edx
        call sub_91FA4
        add esp, byte 8
        mov edx, dword [dword_DC8A0]
        mov dword [byte edx+04Ch], eax
        pop ebp
        pop edi
        pop esi
        ret
loc_1B3AE:
        cmp dword [byte edx+030h], byte 8
        jae short loc_1B42A
        mov eax, edx
        call sub_1B82B
        cmp eax, dword [byte edx+024h]
        jl near loc_1B2DC
        mov eax, dword [dword_DC8A0]
        mov esi, dword [byte eax+04Ch]
        mov edi, dword [byte eax+024h]
        push edi
        mov ebp, dword [byte eax+08h]
        push ebp
        mov edx, dword [byte eax+018h]
        push edx
        call DosReadFile
        add esp, byte 0Ch
        mov eax, dword [dword_DC8A0]
        mov dword [byte eax+04Ch], esi
        mov ebx, dword [dword_C66B0]
        push ebx
        mov eax, dword [dword_DC8A0]
        mov ecx, dword [byte eax+024h]
        push ecx
        call sub_91FA4
        add esp, byte 8
        mov edx, dword [dword_DC8A0]
        mov dword [byte edx+04Ch], eax
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+024h]
        add dword [byte eax+08h], edx
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+024h]
        add dword [byte eax+040h], edx
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+024h]
        add dword [byte eax+030h], edx
loc_1B42A:
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+0Ch]
        mov edx, dword [byte edx+04h]
        mov dword [byte eax+02Ch], edx
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+02Ch]
        mov ebx, dword [byte eax+030h]
        sub edx, ebx
        mov dword [byte eax+028h], edx
        mov eax, dword [dword_DC8A0]
        mov eax, dword [byte eax+0Ch]
        movsx eax, byte [eax]
        sub eax, byte 30h
        test eax, eax
        jle short loc_1B468
        cmp eax, byte 9
        jge short loc_1B468
        mov eax, dword [nosplit eax*4+dword_DC8A0]
        jmp short loc_1B46D
loc_1B468:
        mov eax, dword [dword_DC8A0]
loc_1B46D:
        mov dword [dword_DC8C8], eax
        cmp dword [dword_DC8C8], byte 0
        jne short loc_1B485
        mov eax, dword [dword_DC8A0]
        mov dword [dword_DC8C8], eax
loc_1B485:
        mov eax, dword [dword_DC8A0]
        mov esi, dword [byte eax+02Ch]
        cmp esi, byte 8
        jb short loc_1B49D
        mov edx, dword [dword_DC8C8]
        cmp esi, dword [byte edx+020h]
        jle short loc_1B4BC
loc_1B49D:
        mov eax, dword [dword_DC8C8]
        mov ebp, dword [byte eax+020h]
        push ebp
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+02Ch]
        push edx
        push str_IllegalChunkSizeD
        call FatalError
        add esp, byte 0Ch
loc_1B4BC:
        mov eax, dword [dword_DC8C8]
        mov ebx, dword [dword_DC8A0]
        cmp eax, ebx
        je near loc_1B5EB
        mov dword [byte ebx+01Ch], 4
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+024h]
        add edx, byte 8
        mov eax, dword [dword_DC8C8]
        call sub_1B82B
        cmp eax, edx
        jb near loc_1B2DC
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+02Ch]
        add edx, dword [byte eax+024h]
        mov eax, dword [dword_DC8C8]
        call sub_1B871
        add edx, byte 8
        cmp eax, edx
        jae short loc_1B534
        mov eax, dword [dword_DC8C8]
        mov eax, dword [byte eax+0Ch]
        mov dword [eax], 0FFFFFFFFh
        mov eax, dword [dword_DC8C8]
        mov edx, dword [eax]
        mov dword [byte eax+0Ch], edx
        mov eax, dword [dword_DC8C8]
        mov dword [byte eax+08h], edx
        jmp near loc_1B2B4
loc_1B534:
        mov eax, dword [dword_DC8A0]
        cmp dword [byte eax+028h], byte 0
        jl short loc_1B588
        mov edx, dword [byte eax+030h]
        push edx
        mov edx, dword [dword_DC8C8]
        mov ebx, dword [byte edx+0Ch]
        push ebx
        mov ecx, dword [byte eax+0Ch]
        push ecx
        call bcopy
        add esp, byte 0Ch
        mov eax, dword [dword_DC8C8]
        mov edx, dword [dword_DC8A0]
        mov ebx, dword [byte eax+0Ch]
        mov esi, dword [byte edx+030h]
        add ebx, esi
        mov dword [byte eax+08h], ebx
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+0Ch]
        mov dword [byte eax+08h], edx
        mov eax, dword [dword_DC8A0]
        mov dword [byte eax+030h], 0
        jmp short loc_1B5EB
loc_1B588:
        mov edi, dword [byte eax+02Ch]
        push edi
        mov edx, dword [dword_DC8C8]
        mov ebp, dword [byte edx+0Ch]
        push ebp
        mov edx, dword [byte eax+0Ch]
        push edx
        call bcopy
        add esp, byte 0Ch
        mov eax, dword [dword_DC8C8]
        mov edx, dword [dword_DC8A0]
        mov ebx, dword [byte eax+0Ch]
        mov ecx, dword [byte edx+02Ch]
        add ebx, ecx
        mov dword [byte eax+08h], ebx
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+028h]
        neg edx
        mov dword [byte eax+030h], edx
        mov eax, dword [dword_DC8A0]
        mov esi, dword [byte eax+030h]
        push esi
        mov edi, dword [byte eax+0Ch]
        push edi
        mov eax, dword [byte eax+02Ch]
        add eax, edi
        push eax
        call bcopy
        add esp, byte 0Ch
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+02Ch]
        sub dword [byte eax+08h], edx
loc_1B5EB:
        mov eax, dword [dword_DC8A0]
        mov edi, dword [byte eax+028h]
        test edi, edi
        jle near loc_1B681
        mov ebp, dword [byte eax+024h]
        lea edx, [edi+ebp]
        mov eax, dword [dword_DC8C8]
        call sub_1B871
        add edx, byte 8
        cmp eax, edx
        jae short loc_1B681
        mov eax, dword [dword_DC8A0]
        mov dword [byte eax+01Ch], 5
        mov edx, dword [dword_DC8A0]
        mov eax, dword [dword_DC8C8]
        call sub_1B88A
        cmp eax, dword [byte edx+030h]
        jl near loc_1B2DC
        mov eax, dword [dword_DC8A0]
        mov ecx, dword [byte eax+030h]
        push ecx
        mov eax, dword [dword_DC8C8]
        mov esi, dword [eax]
        push esi
        mov edi, dword [byte eax+0Ch]
        push edi
        call bcopy
        add esp, byte 0Ch
        mov eax, dword [dword_DC8C8]
        mov eax, dword [byte eax+0Ch]
        mov dword [eax], 0FFFFFFFFh
        mov edx, dword [dword_DC8A0]
        mov eax, dword [dword_DC8C8]
        mov ebx, dword [eax]
        mov ebp, dword [byte edx+030h]
        add ebx, ebp
        mov dword [byte eax+08h], ebx
        mov eax, dword [dword_DC8C8]
        mov edx, dword [eax]
        mov dword [byte eax+0Ch], edx
loc_1B681:
        mov eax, dword [dword_DC8A0]
        mov dword [byte eax+01Ch], 6
        mov edx, dword [dword_DC8A0]
        cmp dword [byte edx+028h], byte 0
        jle near loc_1B721
        mov eax, dword [dword_DC8C8]
        call sub_1B82B
        cmp eax, dword [byte edx+024h]
        jl near loc_1B2DC
        mov eax, dword [dword_DC8A0]
        mov esi, dword [byte eax+04Ch]
        mov edi, dword [byte eax+024h]
        push edi
        mov edx, dword [dword_DC8C8]
        mov ebp, dword [byte edx+08h]
        push ebp
        mov edx, dword [byte eax+018h]
        push edx
        call DosReadFile
        add esp, byte 0Ch
        mov eax, dword [dword_DC8A0]
        mov dword [byte eax+04Ch], esi
        mov esi, dword [dword_DC8A0]
        mov ebx, dword [dword_C66B0]
        push ebx
        mov ecx, dword [byte esi+024h]
        push ecx
        call sub_91FA4
        add esp, byte 8
        add dword [byte esi+04Ch], eax
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+024h]
        add dword [byte eax+040h], edx
        mov eax, dword [dword_DC8C8]
        mov edx, dword [dword_DC8A0]
        mov edx, dword [byte edx+024h]
        add dword [byte eax+08h], edx
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+024h]
        sub dword [byte eax+028h], edx
        pop ebp
        pop edi
        pop esi
        ret
loc_1B721:
        mov eax, dword [dword_DC8C8]
        mov edx, dword [byte edx+02Ch]
        add dword [byte eax+0Ch], edx
        mov eax, dword [dword_DC8C8]
        mov ecx, dword [dword_DC8A0]
        cmp eax, ecx
        je short loc_1B789
        mov edx, ecx
        cmp dword [byte ecx+030h], byte 0
        jne short loc_1B799
        mov ebx, dword [byte eax+08h]
        mov ebp, dword [byte eax+0Ch]
        sub ebx, ebp
        mov dword [byte ecx+030h], ebx
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+030h]
        push edx
        mov ebx, dword [byte eax+0Ch]
        push ebx
        mov eax, dword [dword_DC8C8]
        mov ecx, dword [byte eax+0Ch]
        push ecx
        call bcopy
        add esp, byte 0Ch
        mov eax, dword [dword_DC8C8]
        mov edx, dword [byte eax+0Ch]
        mov dword [byte eax+08h], edx
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+0Ch]
        mov esi, dword [byte eax+030h]
        add edx, esi
        mov dword [byte eax+08h], edx
        jmp short loc_1B799
loc_1B789:
        mov eax, dword [dword_DC8C8]
        mov edx, dword [byte eax+08h]
        mov esi, dword [byte eax+0Ch]
        sub edx, esi
        mov dword [byte ecx+030h], edx
loc_1B799:
        mov edx, dword [dword_DC8A0]
        mov eax, dword [byte edx+040h]
        sub eax, dword [byte edx+030h]
        cmp eax, dword [byte edx+038h]
        jl short loc_1B80C
        mov dword [byte edx+01Ch], 9
        mov edx, dword [dword_DC8A0]
        mov eax, edx
        call sub_1B82B
        add eax, dword [byte edx+030h]
        cmp eax, byte 8
        jb near loc_1B2DC
        mov eax, dword [dword_DC8A0]
        mov eax, dword [byte eax+0Ch]
        mov dword [eax], 0FFFFFFFDh
        mov eax, dword [dword_DC8A0]
        mov eax, dword [byte eax+0Ch]
        mov dword [byte eax+04h], 8
        mov eax, dword [dword_DC8A0]
        add dword [byte eax+0Ch], byte 8
        mov eax, dword [dword_DC8A0]
        mov edx, dword [byte eax+0Ch]
        mov dword [byte eax+08h], edx
        mov eax, dword [dword_DC8A0]
        mov dword [byte eax+01Ch], 7
        jmp near loc_1B2B4
loc_1B80C:
        mov dword [byte edx+01Ch], 3
        jmp near loc_1B2B4
sub_1B818:
        push dword 4
        call __CHK
        mov eax, dword [dword_DC8A0]
        dec dword [byte eax+04Ch]
        ret
sub_1B82B:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov edx, dword [byte eax+014h]
        cmp edx, dword [byte eax+010h]
        je short loc_1B859
        mov ecx, dword [edx]
        cmp ecx, byte 0FFFFFFFEh
        jne short loc_1B84F
        mov ebx, dword [byte edx+04h]
        add edx, ebx
        jmp short loc_1B856
loc_1B84F:
        cmp ecx, byte 0FFFFFFFFh
        jne short loc_1B859
        mov edx, dword [eax]
loc_1B856:
        mov dword [byte eax+014h], edx
loc_1B859:
        mov edx, dword [byte eax+014h]
        mov edi, dword [byte eax+08h]
        cmp edx, edi
        ja short loc_1B868
        mov eax, dword [byte eax+04h]
        jmp short loc_1B86A
loc_1B868:
        mov eax, edx
loc_1B86A:
        sub eax, edi
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
sub_1B871:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, dword [byte eax+04h]
        mov ebx, dword [byte eax+08h]
        mov eax, edx
        sub eax, ebx
        pop edx
        pop ebx
        ret
sub_1B88A:
        push dword 0Ch
        call __CHK
        push ecx
        push edx
        mov edx, dword [byte eax+014h]
        cmp edx, dword [byte eax+08h]
        ja short loc_1B8A7
        mov ecx, dword [eax]
        mov eax, edx
        sub eax, ecx
        pop edx
        pop ecx
        ret
loc_1B8A7:
        xor eax, eax
        pop edx
        pop ecx
        ret
sub_1B8AC:
        push dword 0Ch
        call __CHK
        push esi
        push edi
        mov esi, dword [byte esp+0Ch]
        call sub_1B2A7
        mov eax, dword [byte esi+0Ch]
        mov edx, dword [byte esi+010h]
        cmp eax, edx
        jne short loc_1B8D0
        xor eax, edx
        pop edi
        pop esi
        ret
loc_1B8D0:
        cmp dword [edx], byte 0FFFFFFFFh
        jne short loc_1B8E9
        mov eax, dword [esi]
        mov dword [byte esi+010h], eax
        mov eax, dword [byte esi+0Ch]
        mov ecx, dword [byte esi+010h]
        cmp eax, ecx
        jne short loc_1B8E9
        xor eax, ecx
        pop edi
        pop esi
        ret
loc_1B8E9:
        mov eax, dword [byte esi+010h]
        mov edx, dword [byte eax+04h]
        mov edi, dword [byte esi+0Ch]
        cmp eax, edi
        jbe short loc_1B904
        mov ebx, dword [byte esi+04h]
loc_1B8F9:
        sub ebx, eax
        cmp ebx, edx
        jge short loc_1B908
        xor eax, eax
        pop edi
        pop esi
        ret
loc_1B904:
        mov ebx, edi
        jmp short loc_1B8F9
loc_1B908:
        mov eax, dword [byte esi+010h]
        lea ebx, [eax+edx]
        mov dword [byte esi+010h], ebx
        cmp dword [eax], byte 0FFFFFFFDh
        jne short loc_1B92B
        cmp eax, dword [byte esi+014h]
        jne short loc_1B920
        mov dword [byte esi+014h], ebx
        jmp short loc_1B926
loc_1B920:
        mov dword [eax], 0FFFFFFFEh
loc_1B926:
        mov eax, 0FFFFFFFFh
loc_1B92B:
        pop edi
loc_1B92C:
        pop esi
        ret
sub_1B92E:
        push dword 8
        call __CHK
        push esi
        mov eax, dword [byte esp+08h]
        mov edx, dword [byte esp+0Ch]
        mov dword [edx], 0FFFFFFFEh
        cmp edx, dword [byte eax+014h]
        jne short loc_1B92C
loc_1B94C:
        mov ebx, dword [byte eax+014h]
        cmp ebx, dword [byte eax+0Ch]
        je short loc_1B92C
        mov esi, dword [edx]
        cmp esi, byte 0FFFFFFFEh
        jne short loc_1B963
        mov ebx, dword [byte edx+04h]
        add dword [byte eax+014h], ebx
        jmp short loc_1B977
loc_1B963:
        cmp esi, byte 0FFFFFFFFh
        jne short loc_1B92C
        cmp ebx, dword [byte eax+010h]
        jne short loc_1B972
        mov ebx, dword [eax]
        mov dword [byte eax+010h], ebx
loc_1B972:
        mov ebx, dword [eax]
        mov dword [byte eax+014h], ebx
loc_1B977:
        cmp dword [byte edx+04h], byte 0
        je short loc_1B92C
        mov edx, dword [byte eax+014h]
        jmp short loc_1B94C
sub_1B982:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        call CrowdNoiseOff
        call GameOver
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short loc_1B9C4
        mov edx, dword [ovlartbank]
        test edx, edx
        je short loc_1B9C4
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [ovlartbank], ecx
loc_1B9C4:
        call sub_1BAB1
        mov esi, dword [rinkendbank]
        test esi, esi
        je short loc_1B9E4
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ebp, ebp
        mov dword [rinkendbank], ebp
loc_1B9E4:
        mov eax, dword [numshpbank]
        test eax, eax
        je short loc_1B9FE
        push eax
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [numshpbank], ebx
loc_1B9FE:
        mov ecx, dword [scrbrdshapes]
        test ecx, ecx
        je short loc_1BA19
        push ecx
        call FreeMemBlock
        add esp, byte 4
        xor edi, edi
        mov dword [scrbrdshapes], edi
loc_1BA19:
        mov ebp, dword [hilightfont]
        test ebp, ebp
        je short loc_1BA34
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor edx, edx
        mov dword [hilightfont], edx
loc_1BA34:
        call FreeRockMusic
        mov ebx, dword [cupseries]
        test ebx, ebx
        je short loc_1BA54
        push ebx
        call FreeMemBlock
        add esp, byte 4
        xor esi, esi
        mov dword [cupseries], esi
loc_1BA54:
        xor edi, edi
        mov dword [joysampling], edi
        call joyq_flush
        mov ebp, dword [s1font]
        push ebp
        call TextSetFont
        add esp, byte 4
        mov word [scrpitch], 50h
        call FreeRinkGfx
loc_1BA7E:
        pop ebp
loc_1BA7F:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_1BA85:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, dword [photobankf]
        test edx, edx
        je short loc_1BAA5
        push edx
        call FreeMemBlock
        add esp, byte 4
loc_1BAA5:
        xor ecx, ecx
        mov dword [photobankf], ecx
        pop edx
        pop ecx
        pop ebx
        ret
sub_1BAB1:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        call sub_1BA85
        mov edi, 16h
        jmp short loc_1BAED
loc_1BACC:
        mov esi, edi
        shl esi, 2
        mov edx, dword [dword esi+photobanks]
        test edx, edx
        je short loc_1BAEC
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [dword esi+photobanks], ecx
loc_1BAEC:
        dec edi
loc_1BAED:
        test edi, edi
        jge short loc_1BACC
        jmp short loc_1BA7F
sub_1BAF3:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, eax
        call sub_8DAB8
        cmp eax, ebp
        jl short loc_1BB18
loc_1BB0E:
        mov eax, 1
        jmp near loc_1BA7E
loc_1BB18:
        mov edx, dword [rinkbm]
        test edx, edx
        je short loc_1BB33
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [rinkbm], ecx
loc_1BB33:
        call sub_8DAB8
        cmp eax, ebp
        jge short loc_1BB0E
        call FreeRinkGfx
        call sub_8DAB8
        cmp eax, ebp
        jge short loc_1BB0E
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short loc_1BB71
        mov esi, dword [ovlartbank]
        test esi, esi
        je short loc_1BB71
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [ovlartbank], eax
loc_1BB71:
        call sub_8DAB8
        cmp eax, ebp
        jge short loc_1BB0E
        call sub_1BA85
        mov edi, 16h
        jmp short loc_1BBB4
loc_1BB86:
        call sub_8DAB8
        cmp eax, ebp
        jge near loc_1BB0E
        mov esi, edi
        shl esi, 2
        mov edx, dword [dword esi+photobanks]
        test edx, edx
        je short loc_1BBB3
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [dword esi+photobanks], ecx
loc_1BBB3:
        dec edi
loc_1BBB4:
        test edi, edi
        jge short loc_1BB86
        call sub_8DAB8
        cmp eax, ebp
        jge near loc_1BB0E
        xor eax, eax
        jmp near loc_1BA7E
