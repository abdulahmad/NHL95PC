; Reading a file off the CD as a stream of blocks.
bits 32
%include "hockey.inc"
section s_1B0F3 progbits alloc exec nowrite align=1
extern __CHK, addtimer, str_CDSTREAM, str_IllegalSecondaryStreamNumber, str_SECCDSTREAM, str_IllegalChunkSizeD, bannertimer, CrowdNoiseOff
extern cupseries, dword_C66B0, StreamHandle, CurStream, ovlartbank, FatalError, FreeMemBlock, FreeRinkGfx
extern FreeRockMusic, GameOver, hilightfont, joyq_flush, joysampling, numshpbank, ovlseq, photobankf
extern photobanks, RemoveTimerCallback, rinkbm, rinkendbank, s1font, scrbrdshapes, scrpitch, AllocMemBlock
extern MemLargestFree, TextSetFont, FixedMulRound, bcopy, openhandle, DosCloseFile, DosReadFile, DosSeekFile
global CdStreamCreate, CdStreamClose, CdStreamOpen, CdStreamSeek, CdStreamCreateSecondary, jpt_1B283, CdStreamService, CdStreamService
global CdStreamService, CdStreamTimer, CdStreamSkipReleased, CdStreamSpace, CdStreamFilled, CdStreamNextChunk, CdStreamNextChunk, CdStreamReleaseChunk
global FreeGameMemory, FreeGameMemory, FreePhotoBankF, FreePhotoBanks, EnsureFreeMemory
CdStreamCreate:
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
        mov dword [CurStream], esi
        mov dword [StreamHandle], esi
        mov dword [byte esi+01Ch], 7
        mov ebx, dword [dword_C66B0]
        push ebx
        push eax
        call FixedMulRound
        add esp, byte 8
        mov dword [byte esi+050h], eax
        mov dword [byte esi+04Ch], 0
        push CdStreamTimer
        call addtimer
        add esp, byte 4
        mov eax, esi
        pop esi
        ret
CdStreamClose:
        push dword 0Ch
        call __CHK
        push esi
        mov esi, dword [byte esp+08h]
        push CdStreamTimer
        call RemoveTimerCallback
        add esp, byte 4
        mov edx, dword [byte esi+018h]
        test edx, edx
        je short .1
        push edx
        call DosCloseFile
        add esp, byte 4
.1:
        push esi
        call FreeMemBlock
        add esp, byte 4
        pop esi
        ret
CdStreamOpen:
        push dword 4
        call __CHK
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov dword [byte eax+048h], edx
        mov dword [byte eax+01Ch], 1
        ret
CdStreamSeek:
        push dword 4
        call __CHK
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+034h]
        mov ebx, dword [byte esp+08h]
        add eax, ebx
        mov dword [byte edx+044h], eax
        mov dword [byte edx+01Ch], 2
        ret
CdStreamCreateSecondary:
        push dword 10h
        call __CHK
        mov edx, dword [byte esp+04h]
        test edx, edx
        jl short .1
        cmp edx, byte 9
        jle short .2
.1:
        push str_IllegalSecondaryStreamNumber
        call FatalError
        add esp, byte 4
.2:
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
        mov dword [nosplit edx*4+StreamHandle], eax
        ret
jpt_1B283:
        dd CdStreamService+039h
        dd CdStreamService+08Dh
        dd CdStreamService+0107h
        dd CdStreamService+0215h
        dd CdStreamService+0344h
        dd CdStreamService+03DAh
        dd CdStreamService+02Eh
        dd CdStreamService+0Dh
        dd CdStreamService+04F2h
CdStreamService:
        push dword 20h
        call __CHK
        push esi
        push edi
        push ebp
        mov edx, dword [StreamHandle]
        cmp dword [byte edx+04Ch], byte 0
        jg near .1
        mov eax, dword [byte edx+01Ch]
        dec eax
        cmp eax, byte 8
        ja short CdStreamService+0Dh
        jmp dword [nosplit cs:eax*4+jpt_1B283]
        mov dword [byte edx+04Ch], 0
.1:
        pop ebp
        pop edi
        pop esi
        ret
        mov esi, dword [byte edx+018h]
        test esi, esi
        je short .2
        push esi
        call DosCloseFile
        add esp, byte 4
.2:
        mov eax, dword [StreamHandle]
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
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+034h]
        mov dword [byte eax+044h], edx
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+034h]
        mov ebx, dword [byte eax+03Ch]
        add edx, ebx
        mov dword [byte eax+038h], edx
        mov eax, dword [StreamHandle]
        mov dword [byte eax+01Ch], 2
        mov edx, dword [StreamHandle]
        mov eax, edx
        call CdStreamSkipReleased
        cmp eax, dword [byte edx+024h]
        jl short .1
        mov eax, dword [StreamHandle]
        mov dword [byte eax+01Ch], 3
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+0Ch]
        mov dword [byte eax+08h], edx
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+044h]
        mov dword [byte eax+040h], edx
        mov eax, dword [StreamHandle]
        mov esi, dword [byte eax+040h]
        push esi
        mov edi, dword [byte eax+018h]
        push edi
        call DosSeekFile
        add esp, byte 8
        mov eax, dword [StreamHandle]
        mov dword [byte eax+030h], 0
        mov ebp, dword [dword_C66B0]
        push ebp
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+024h]
        push edx
        call FixedMulRound
        add esp, byte 8
        mov edx, dword [StreamHandle]
        mov dword [byte edx+04Ch], eax
        pop ebp
        pop edi
        pop esi
        ret
        cmp dword [byte edx+030h], byte 8
        jae short .3
        mov eax, edx
        call CdStreamSkipReleased
        cmp eax, dword [byte edx+024h]
        jl near .1
        mov eax, dword [StreamHandle]
        mov esi, dword [byte eax+04Ch]
        mov edi, dword [byte eax+024h]
        push edi
        mov ebp, dword [byte eax+08h]
        push ebp
        mov edx, dword [byte eax+018h]
        push edx
        call DosReadFile
        add esp, byte 0Ch
        mov eax, dword [StreamHandle]
        mov dword [byte eax+04Ch], esi
        mov ebx, dword [dword_C66B0]
        push ebx
        mov eax, dword [StreamHandle]
        mov ecx, dword [byte eax+024h]
        push ecx
        call FixedMulRound
        add esp, byte 8
        mov edx, dword [StreamHandle]
        mov dword [byte edx+04Ch], eax
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+024h]
        add dword [byte eax+08h], edx
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+024h]
        add dword [byte eax+040h], edx
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+024h]
        add dword [byte eax+030h], edx
.3:
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+0Ch]
        mov edx, dword [byte edx+04h]
        mov dword [byte eax+02Ch], edx
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+02Ch]
        mov ebx, dword [byte eax+030h]
        sub edx, ebx
        mov dword [byte eax+028h], edx
        mov eax, dword [StreamHandle]
        mov eax, dword [byte eax+0Ch]
        movsx eax, byte [eax]
        sub eax, byte 30h
        test eax, eax
        jle short .4
        cmp eax, byte 9
        jge short .4
        mov eax, dword [nosplit eax*4+StreamHandle]
        jmp short .5
.4:
        mov eax, dword [StreamHandle]
.5:
        mov dword [CurStream], eax
        cmp dword [CurStream], byte 0
        jne short .6
        mov eax, dword [StreamHandle]
        mov dword [CurStream], eax
.6:
        mov eax, dword [StreamHandle]
        mov esi, dword [byte eax+02Ch]
        cmp esi, byte 8
        jb short .7
        mov edx, dword [CurStream]
        cmp esi, dword [byte edx+020h]
        jle short CdStreamService+0215h
.7:
        mov eax, dword [CurStream]
        mov ebp, dword [byte eax+020h]
        push ebp
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+02Ch]
        push edx
        push str_IllegalChunkSizeD
        call FatalError
        add esp, byte 0Ch
        mov eax, dword [CurStream]
        mov ebx, dword [StreamHandle]
        cmp eax, ebx
        je near CdStreamService+0344h
        mov dword [byte ebx+01Ch], 4
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+024h]
        add edx, byte 8
        mov eax, dword [CurStream]
        call CdStreamSkipReleased
        cmp eax, edx
        jb near .1
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+02Ch]
        add edx, dword [byte eax+024h]
        mov eax, dword [CurStream]
        call CdStreamSpace
        add edx, byte 8
        cmp eax, edx
        jae short .8
        mov eax, dword [CurStream]
        mov eax, dword [byte eax+0Ch]
        mov dword [eax], 0FFFFFFFFh
        mov eax, dword [CurStream]
        mov edx, dword [eax]
        mov dword [byte eax+0Ch], edx
        mov eax, dword [CurStream]
        mov dword [byte eax+08h], edx
        jmp near CdStreamService+0Dh
.8:
        mov eax, dword [StreamHandle]
        cmp dword [byte eax+028h], byte 0
        jl short .9
        mov edx, dword [byte eax+030h]
        push edx
        mov edx, dword [CurStream]
        mov ebx, dword [byte edx+0Ch]
        push ebx
        mov ecx, dword [byte eax+0Ch]
        push ecx
        call bcopy
        add esp, byte 0Ch
        mov eax, dword [CurStream]
        mov edx, dword [StreamHandle]
        mov ebx, dword [byte eax+0Ch]
        mov esi, dword [byte edx+030h]
        add ebx, esi
        mov dword [byte eax+08h], ebx
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+0Ch]
        mov dword [byte eax+08h], edx
        mov eax, dword [StreamHandle]
        mov dword [byte eax+030h], 0
        jmp short CdStreamService+0344h
.9:
        mov edi, dword [byte eax+02Ch]
        push edi
        mov edx, dword [CurStream]
        mov ebp, dword [byte edx+0Ch]
        push ebp
        mov edx, dword [byte eax+0Ch]
        push edx
        call bcopy
        add esp, byte 0Ch
        mov eax, dword [CurStream]
        mov edx, dword [StreamHandle]
        mov ebx, dword [byte eax+0Ch]
        mov ecx, dword [byte edx+02Ch]
        add ebx, ecx
        mov dword [byte eax+08h], ebx
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+028h]
        neg edx
        mov dword [byte eax+030h], edx
        mov eax, dword [StreamHandle]
        mov esi, dword [byte eax+030h]
        push esi
        mov edi, dword [byte eax+0Ch]
        push edi
        mov eax, dword [byte eax+02Ch]
        add eax, edi
        push eax
        call bcopy
        add esp, byte 0Ch
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+02Ch]
        sub dword [byte eax+08h], edx
        mov eax, dword [StreamHandle]
        mov edi, dword [byte eax+028h]
        test edi, edi
        jle near CdStreamService+03DAh
        mov ebp, dword [byte eax+024h]
        lea edx, [edi+ebp]
        mov eax, dword [CurStream]
        call CdStreamSpace
        add edx, byte 8
        cmp eax, edx
        jae short CdStreamService+03DAh
        mov eax, dword [StreamHandle]
        mov dword [byte eax+01Ch], 5
        mov edx, dword [StreamHandle]
        mov eax, dword [CurStream]
        call CdStreamFilled
        cmp eax, dword [byte edx+030h]
        jl near .1
        mov eax, dword [StreamHandle]
        mov ecx, dword [byte eax+030h]
        push ecx
        mov eax, dword [CurStream]
        mov esi, dword [eax]
        push esi
        mov edi, dword [byte eax+0Ch]
        push edi
        call bcopy
        add esp, byte 0Ch
        mov eax, dword [CurStream]
        mov eax, dword [byte eax+0Ch]
        mov dword [eax], 0FFFFFFFFh
        mov edx, dword [StreamHandle]
        mov eax, dword [CurStream]
        mov ebx, dword [eax]
        mov ebp, dword [byte edx+030h]
        add ebx, ebp
        mov dword [byte eax+08h], ebx
        mov eax, dword [CurStream]
        mov edx, dword [eax]
        mov dword [byte eax+0Ch], edx
        mov eax, dword [StreamHandle]
        mov dword [byte eax+01Ch], 6
        mov edx, dword [StreamHandle]
        cmp dword [byte edx+028h], byte 0
        jle near .10
        mov eax, dword [CurStream]
        call CdStreamSkipReleased
        cmp eax, dword [byte edx+024h]
        jl near .1
        mov eax, dword [StreamHandle]
        mov esi, dword [byte eax+04Ch]
        mov edi, dword [byte eax+024h]
        push edi
        mov edx, dword [CurStream]
        mov ebp, dword [byte edx+08h]
        push ebp
        mov edx, dword [byte eax+018h]
        push edx
        call DosReadFile
        add esp, byte 0Ch
        mov eax, dword [StreamHandle]
        mov dword [byte eax+04Ch], esi
        mov esi, dword [StreamHandle]
        mov ebx, dword [dword_C66B0]
        push ebx
        mov ecx, dword [byte esi+024h]
        push ecx
        call FixedMulRound
        add esp, byte 8
        add dword [byte esi+04Ch], eax
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+024h]
        add dword [byte eax+040h], edx
        mov eax, dword [CurStream]
        mov edx, dword [StreamHandle]
        mov edx, dword [byte edx+024h]
        add dword [byte eax+08h], edx
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+024h]
        sub dword [byte eax+028h], edx
        pop ebp
        pop edi
        pop esi
        ret
.10:
        mov eax, dword [CurStream]
        mov edx, dword [byte edx+02Ch]
        add dword [byte eax+0Ch], edx
        mov eax, dword [CurStream]
        mov ecx, dword [StreamHandle]
        cmp eax, ecx
        je short .11
        mov edx, ecx
        cmp dword [byte ecx+030h], byte 0
        jne short CdStreamService+04F2h
        mov ebx, dword [byte eax+08h]
        mov ebp, dword [byte eax+0Ch]
        sub ebx, ebp
        mov dword [byte ecx+030h], ebx
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+030h]
        push edx
        mov ebx, dword [byte eax+0Ch]
        push ebx
        mov eax, dword [CurStream]
        mov ecx, dword [byte eax+0Ch]
        push ecx
        call bcopy
        add esp, byte 0Ch
        mov eax, dword [CurStream]
        mov edx, dword [byte eax+0Ch]
        mov dword [byte eax+08h], edx
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+0Ch]
        mov esi, dword [byte eax+030h]
        add edx, esi
        mov dword [byte eax+08h], edx
        jmp short CdStreamService+04F2h
.11:
        mov eax, dword [CurStream]
        mov edx, dword [byte eax+08h]
        mov esi, dword [byte eax+0Ch]
        sub edx, esi
        mov dword [byte ecx+030h], edx
        mov edx, dword [StreamHandle]
        mov eax, dword [byte edx+040h]
        sub eax, dword [byte edx+030h]
        cmp eax, dword [byte edx+038h]
        jl short .12
        mov dword [byte edx+01Ch], 9
        mov edx, dword [StreamHandle]
        mov eax, edx
        call CdStreamSkipReleased
        add eax, dword [byte edx+030h]
        cmp eax, byte 8
        jb near .1
        mov eax, dword [StreamHandle]
        mov eax, dword [byte eax+0Ch]
        mov dword [eax], 0FFFFFFFDh
        mov eax, dword [StreamHandle]
        mov eax, dword [byte eax+0Ch]
        mov dword [byte eax+04h], 8
        mov eax, dword [StreamHandle]
        add dword [byte eax+0Ch], byte 8
        mov eax, dword [StreamHandle]
        mov edx, dword [byte eax+0Ch]
        mov dword [byte eax+08h], edx
        mov eax, dword [StreamHandle]
        mov dword [byte eax+01Ch], 7
        jmp near CdStreamService+0Dh
.12:
        mov dword [byte edx+01Ch], 3
        jmp near CdStreamService+0Dh
CdStreamTimer:
        push dword 4
        call __CHK
        mov eax, dword [StreamHandle]
        dec dword [byte eax+04Ch]
        ret
CdStreamSkipReleased:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov edx, dword [byte eax+014h]
        cmp edx, dword [byte eax+010h]
        je short .3
        mov ecx, dword [edx]
        cmp ecx, byte 0FFFFFFFEh
        jne short .1
        mov ebx, dword [byte edx+04h]
        add edx, ebx
        jmp short .2
.1:
        cmp ecx, byte 0FFFFFFFFh
        jne short .3
        mov edx, dword [eax]
.2:
        mov dword [byte eax+014h], edx
.3:
        mov edx, dword [byte eax+014h]
        mov edi, dword [byte eax+08h]
        cmp edx, edi
        ja short .4
        mov eax, dword [byte eax+04h]
        jmp short .5
.4:
        mov eax, edx
.5:
        sub eax, edi
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
CdStreamSpace:
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
CdStreamFilled:
        push dword 0Ch
        call __CHK
        push ecx
        push edx
        mov edx, dword [byte eax+014h]
        cmp edx, dword [byte eax+08h]
        ja short .1
        mov ecx, dword [eax]
        mov eax, edx
        sub eax, ecx
        pop edx
        pop ecx
        ret
.1:
        xor eax, eax
        pop edx
        pop ecx
        ret
CdStreamNextChunk:
        push dword 0Ch
        call __CHK
        push esi
        push edi
        mov esi, dword [byte esp+0Ch]
        call CdStreamService
        mov eax, dword [byte esi+0Ch]
        mov edx, dword [byte esi+010h]
        cmp eax, edx
        jne short .1
        xor eax, edx
        pop edi
        pop esi
        ret
.1:
        cmp dword [edx], byte 0FFFFFFFFh
        jne short .2
        mov eax, dword [esi]
        mov dword [byte esi+010h], eax
        mov eax, dword [byte esi+0Ch]
        mov ecx, dword [byte esi+010h]
        cmp eax, ecx
        jne short .2
        xor eax, ecx
        pop edi
        pop esi
        ret
.2:
        mov eax, dword [byte esi+010h]
        mov edx, dword [byte eax+04h]
        mov edi, dword [byte esi+0Ch]
        cmp eax, edi
        jbe short .4
        mov ebx, dword [byte esi+04h]
.3:
        sub ebx, eax
        cmp ebx, edx
        jge short .5
        xor eax, eax
        pop edi
        pop esi
        ret
.4:
        mov ebx, edi
        jmp short .3
.5:
        mov eax, dword [byte esi+010h]
        lea ebx, [eax+edx]
        mov dword [byte esi+010h], ebx
        cmp dword [eax], byte 0FFFFFFFDh
        jne short .8
        cmp eax, dword [byte esi+014h]
        jne short .6
        mov dword [byte esi+014h], ebx
        jmp short .7
.6:
        mov dword [eax], 0FFFFFFFEh
.7:
        mov eax, 0FFFFFFFFh
.8:
        pop edi
        pop esi
        ret
CdStreamReleaseChunk:
        push dword 8
        call __CHK
        push esi
        mov eax, dword [byte esp+08h]
        mov edx, dword [byte esp+0Ch]
        mov dword [edx], 0FFFFFFFEh
        cmp edx, dword [byte eax+014h]
        jne short CdStreamNextChunk+080h
.1:
        mov ebx, dword [byte eax+014h]
        cmp ebx, dword [byte eax+0Ch]
        je short CdStreamNextChunk+080h
        mov esi, dword [edx]
        cmp esi, byte 0FFFFFFFEh
        jne short .2
        mov ebx, dword [byte edx+04h]
        add dword [byte eax+014h], ebx
        jmp short .4
.2:
        cmp esi, byte 0FFFFFFFFh
        jne short CdStreamNextChunk+080h
        cmp ebx, dword [byte eax+010h]
        jne short .3
        mov ebx, dword [eax]
        mov dword [byte eax+010h], ebx
.3:
        mov ebx, dword [eax]
        mov dword [byte eax+014h], ebx
.4:
        cmp dword [byte edx+04h], byte 0
        je short CdStreamNextChunk+080h
        mov edx, dword [byte eax+014h]
        jmp short .1
FreeGameMemory:
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
        je short .1
        mov edx, dword [ovlartbank]
        test edx, edx
        je short .1
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [ovlartbank], ecx
.1:
        call FreePhotoBanks
        mov esi, dword [rinkendbank]
        test esi, esi
        je short .2
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ebp, ebp
        mov dword [rinkendbank], ebp
.2:
        mov eax, dword [numshpbank]
        test eax, eax
        je short .3
        push eax
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [numshpbank], ebx
.3:
        mov ecx, dword [scrbrdshapes]
        test ecx, ecx
        je short .4
        push ecx
        call FreeMemBlock
        add esp, byte 4
        xor edi, edi
        mov dword [scrbrdshapes], edi
.4:
        mov ebp, dword [hilightfont]
        test ebp, ebp
        je short .5
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor edx, edx
        mov dword [hilightfont], edx
.5:
        call FreeRockMusic
        mov ebx, dword [cupseries]
        test ebx, ebx
        je short .6
        push ebx
        call FreeMemBlock
        add esp, byte 4
        xor esi, esi
        mov dword [cupseries], esi
.6:
        xor edi, edi
        mov dword [joysampling], edi
        call joyq_flush
        mov ebp, dword [s1font]
        push ebp
        call TextSetFont
        add esp, byte 4
        mov word [scrpitch], 50h
        call FreeRinkGfx
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
FreePhotoBankF:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, dword [photobankf]
        test edx, edx
        je short .1
        push edx
        call FreeMemBlock
        add esp, byte 4
.1:
        xor ecx, ecx
        mov dword [photobankf], ecx
        pop edx
        pop ecx
        pop ebx
        ret
FreePhotoBanks:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        call FreePhotoBankF
        mov edi, 16h
        jmp short .3
.1:
        mov esi, edi
        shl esi, 2
        mov edx, dword [dword esi+photobanks]
        test edx, edx
        je short .2
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [dword esi+photobanks], ecx
.2:
        dec edi
.3:
        test edi, edi
        jge short .1
        jmp short FreeGameMemory+0FDh
EnsureFreeMemory:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, eax
        call MemLargestFree
        cmp eax, ebp
        jl short .2
.1:
        mov eax, 1
        jmp near FreeGameMemory+0FCh
.2:
        mov edx, dword [rinkbm]
        test edx, edx
        je short .3
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [rinkbm], ecx
.3:
        call MemLargestFree
        cmp eax, ebp
        jge short .1
        call FreeRinkGfx
        call MemLargestFree
        cmp eax, ebp
        jge short .1
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .4
        mov esi, dword [ovlartbank]
        test esi, esi
        je short .4
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [ovlartbank], eax
.4:
        call MemLargestFree
        cmp eax, ebp
        jge short .1
        call FreePhotoBankF
        mov edi, 16h
        jmp short .7
.5:
        call MemLargestFree
        cmp eax, ebp
        jge near .1
        mov esi, edi
        shl esi, 2
        mov edx, dword [dword esi+photobanks]
        test edx, edx
        je short .6
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [dword esi+photobanks], ecx
.6:
        dec edi
.7:
        test edi, edi
        jge short .5
        call MemLargestFree
        cmp eax, ebp
        jge near .1
        xor eax, eax
        jmp near FreeGameMemory+0FCh
