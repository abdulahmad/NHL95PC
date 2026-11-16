; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_96A60 progbits alloc exec nowrite align=1
extern __GETDS, _os_handle_3, SndHandleType, sndhandlecount, SndTimerHandle
extern SndDriverTable, MemDescPtr, sub_96A10, bcopy, DosReadFile, SndHandleTable
global sub_96A60, sub_96A78, sub_96A80, sub_96A94, loc_96AA4, loc_96AB2, loc_96AC0, sub_96AC4
global loc_96B15, loc_96B38, loc_96B73, loc_96BA1, loc_96BC5, loc_96C15, loc_96C2B, loc_96C43
global sub_96C4C, loc_96CA2, loc_96CBD, loc_96CF3, loc_96D01, loc_96D0E, loc_96D27, loc_96D5E
global loc_96D8B, loc_96DA9, loc_96DC4, loc_96DF4, loc_96E09, loc_96E2D, loc_96E34, loc_96E47
global loc_96E5B, loc_96E73, sub_96E7C, loc_96EFF, loc_96F3D, loc_96F77, loc_96F90, loc_96FC7
global loc_9702F, loc_97059, loc_97066, loc_9706F, SndOpenDriver, loc_9708D, loc_97097, loc_9709B
global loc_970AB, loc_970C2, loc_970CC, loc_970D1, loc_97153, loc_9715C, SndDriverHandle, loc_97175
global SndHandleDetect, SndHandleOpen, loc_971A5, SndHandleInit, SndHandleClose, loc_971D7, SndHandleService, loc_971F4
global SndDriverCall, SndHandleSetTrack, loc_9722C, SndHandleMidi, loc_9724A, loc_9724E, loc_97266, SndHandlePlayDigi
global loc_972A5, NullDriverOpen, sub_972B1, NullDriverInit, sub_972BE, NullDriverReturn, sub_972C6, NullDriverQuery
global sub_972CE, NullDriverSetTrack, sub_972DB, NullDriverMidi, sub_972E3, NullDriverPlayDigi, sub_972EB
sub_96A60:
        mov eax, dword [byte esp+04h]
        mov eax, dword [byte eax+0Ch]
        ret
        mov eax, dword [byte esp+04h]
        mov eax, dword [byte eax+010h]
        ret
        mov eax, dword [byte esp+04h]
        mov eax, dword [eax]
        ret
        db 090h
sub_96A78:
        mov eax, dword [byte esp+04h]
        mov eax, dword [byte eax+08h]
        ret
sub_96A80:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+04h]
        cmp eax, dword [edx]
        setg al
        and eax, 0FFh
        ret
        db 08Bh,0C0h
sub_96A94:
        push esi
        push edi
        mov edi, dword [byte esp+010h]
        mov esi, dword [byte esp+0Ch]
        test edi, edi
        jge short loc_96AA4
        xor edi, edi
loc_96AA4:
        push esi
        call sub_96A10
        add esp, byte 4
        cmp edi, dword [byte esi+04h]
        jle short loc_96AC0
loc_96AB2:
        push esi
        call sub_96E7C
        add esp, byte 4
        cmp edi, dword [byte esi+04h]
        jg short loc_96AB2
loc_96AC0:
        pop edi
        pop esi
        ret
        db 090h
sub_96AC4:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 2Ch
        mov dword [byte esp+0Ch], eax
        mov esi, edx
        mov ecx, dword [byte eax+0Ch]
        mov eax, dword [byte eax+034h]
        mov edx, dword [byte eax+02Ch]
        mov dword [byte esp+08h], edx
        mov edx, dword [byte esp+0Ch]
        mov edx, dword [byte edx+038h]
        mov edx, dword [byte edx+02Ch]
        mov dword [byte esp+010h], edx
        mov edx, dword [byte esp+0Ch]
        mov edx, dword [byte edx+03Ch]
        mov edx, dword [byte edx+02Ch]
        mov dword [byte esp+014h], edx
        mov eax, dword [byte eax+028h]
        mov dword [byte esp+018h], eax
        xor edx, edx
        mov dword [byte esp+01Ch], edx
        mov eax, dword [byte esp+0Ch]
        cmp dword [byte eax+010h], byte 0
        jle near loc_96C43
loc_96B15:
        xor ebp, ebp
        mov dword [byte esp+028h], ebp
        test ecx, ecx
        jle near loc_96C2B
        mov eax, dword [byte esp+01Ch]
        shl eax, 2
        mov edx, dword [byte esp+018h]
        add edx, eax
        mov dword [byte esp+020h], edx
        mov edi, dword [byte esp+08h]
loc_96B38:
        mov ah, byte [esi]
        cmp ah, 0FFh
        jne short loc_96B73
        cmp ah, byte [ebx]
        jne short loc_96B73
        mov eax, dword [byte esp+020h]
        mov eax, dword [eax]
        add eax, edi
        inc esi
        inc ebx
        mov edx, dword [ebx]
        mov dword [eax], edx
        add eax, ecx
        add ebx, byte 4
        mov edx, dword [ebx]
        mov dword [eax], edx
        add eax, ecx
        add ebx, byte 4
        mov edx, dword [ebx]
        mov dword [eax], edx
        add ebx, byte 4
        mov edx, dword [ebx]
        mov dword [ecx+eax], edx
        add ebx, byte 4
        jmp near loc_96C15
loc_96B73:
        mov dh, byte [esi]
        cmp dh, 0FFh
        jne short loc_96BA1
        mov al, byte [ebx]
        and al, 0Fh
        and eax, 0FFh
        sub eax, byte 7
        xor edx, edx
        mov dl, byte [ebx]
        sar edx, 4
        and edx, byte 0Fh
        sub edx, byte 7
        mov dword [byte esp+024h], edx
        mov edx, dword [byte esp+014h]
        mov dword [esp], edx
        inc ebx
        jmp short loc_96BC5
loc_96BA1:
        mov al, dh
        and al, 0Fh
        and eax, 0FFh
        sub eax, byte 7
        xor edx, edx
        mov dl, byte [esi]
        sar edx, 4
        and edx, byte 0Fh
        sub edx, byte 7
        mov dword [byte esp+024h], edx
        mov edx, dword [byte esp+010h]
        mov dword [esp], edx
loc_96BC5:
        inc esi
        mov edx, dword [byte esp+020h]
        mov edx, dword [edx]
        add edx, edi
        mov ebp, dword [byte esp+01Ch]
        add ebp, dword [byte esp+024h]
        shl ebp, 2
        mov dword [byte esp+04h], ebp
        mov ebp, dword [byte esp+018h]
        add ebp, dword [byte esp+04h]
        mov dword [byte esp+04h], ebp
        mov ebp, dword [esp]
        add ebp, dword [byte esp+028h]
        add ebp, eax
        mov eax, ebp
        mov ebp, dword [byte esp+04h]
        add eax, dword [byte ebp+00h]
        mov ebp, dword [eax]
        mov dword [edx], ebp
        add edx, ecx
        add eax, ecx
        mov ebp, dword [eax]
        mov dword [edx], ebp
        add edx, ecx
        add eax, ecx
        mov ebp, dword [eax]
        mov dword [edx], ebp
        mov eax, dword [ecx+eax]
        mov dword [ecx+edx], eax
loc_96C15:
        add edi, byte 4
        mov eax, dword [byte esp+028h]
        add eax, byte 4
        mov dword [byte esp+028h], eax
        cmp ecx, eax
        jg near loc_96B38
loc_96C2B:
        mov ebp, dword [byte esp+01Ch]
        add ebp, byte 4
        mov dword [byte esp+01Ch], ebp
        mov edx, dword [byte esp+0Ch]
        cmp ebp, dword [byte edx+010h]
        jl near loc_96B15
loc_96C43:
        add esp, byte 2Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 090h
sub_96C4C:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 50h
        mov dword [byte esp+010h], edx
        mov edi, ebx
        mov edx, dword [byte eax+0Ch]
        mov ebx, dword [byte eax+010h]
        mov dword [byte esp+04Ch], ebx
        mov ebx, dword [byte eax+020h]
        mov dword [byte esp+030h], ebx
        mov ebx, dword [byte eax+034h]
        mov ebx, dword [byte ebx+02Ch]
        add ebx, byte 10h
        mov dword [byte esp+0Ch], ebx
        mov ebx, dword [byte eax+038h]
        mov ebx, dword [byte ebx+02Ch]
        add ebx, byte 10h
        mov dword [byte esp+01Ch], ebx
        mov eax, dword [byte eax+03Ch]
        mov eax, dword [byte eax+02Ch]
        add eax, byte 10h
        mov dword [byte esp+018h], eax
        xor ebx, ebx
        mov dword [byte esp+020h], ebx
        cmp dword [byte esp+04Ch], byte 0
        jle near loc_96E73
loc_96CA2:
        xor eax, eax
        mov dword [esp], eax
        test edx, edx
        jle near loc_96E5B
        mov eax, dword [byte esp+020h]
        mov esi, dword [byte esp+030h]
        add eax, esi
        mov dword [byte esp+02Ch], eax
loc_96CBD:
        mov eax, dword [byte esp+010h]
        mov bl, byte [eax]
        cmp bl, 0FFh
        jne short loc_96D27
        cmp bl, byte [edi]
        jne short loc_96D27
        mov eax, dword [byte esp+020h]
        mov dword [byte esp+034h], eax
        inc dword [byte esp+010h]
        inc edi
        cmp eax, dword [byte esp+02Ch]
        jge near loc_96E47
        mov esi, dword [esp]
        add esi, dword [byte esp+030h]
        mov dword [byte esp+028h], edx
        mov ebp, eax
        imul ebp, edx
loc_96CF3:
        mov eax, dword [esp]
        cmp esi, eax
        jle short loc_96D0E
        lea ebx, [eax+ebp]
        add ebx, dword [byte esp+0Ch]
loc_96D01:
        mov ecx, edi
        inc edi
        mov cl, byte [ecx]
        mov byte [ebx], cl
        inc ebx
        inc eax
        cmp eax, esi
        jl short loc_96D01
loc_96D0E:
        add ebp, dword [byte esp+028h]
        mov ebx, dword [byte esp+034h]
        inc ebx
        mov dword [byte esp+034h], ebx
        cmp ebx, dword [byte esp+02Ch]
        jge near loc_96E47
        jmp short loc_96CF3
loc_96D27:
        mov eax, dword [byte esp+010h]
        mov cl, byte [eax]
        cmp cl, 0FFh
        jne short loc_96D5E
        mov al, byte [edi]
        and al, 0Fh
        and eax, 0FFh
        sub eax, byte 7
        mov dword [byte esp+040h], eax
        xor eax, eax
        mov al, byte [edi]
        sar eax, 4
        and eax, byte 0Fh
        sub eax, byte 7
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esp+018h]
        mov dword [byte esp+03Ch], eax
        inc edi
        jmp short loc_96D8B
loc_96D5E:
        mov al, cl
        and al, 0Fh
        and eax, 0FFh
        sub eax, byte 7
        mov dword [byte esp+040h], eax
        xor eax, eax
        mov ebx, dword [byte esp+010h]
        mov al, byte [ebx]
        sar eax, 4
        and eax, byte 0Fh
        sub eax, byte 7
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esp+01Ch]
        mov dword [byte esp+03Ch], eax
loc_96D8B:
        inc dword [byte esp+010h]
        mov eax, dword [byte esp+030h]
        test eax, eax
        jle near loc_96E47
        mov ebx, dword [byte esp+020h]
        mov dword [byte esp+038h], ebx
        add eax, ebx
        mov dword [byte esp+024h], eax
loc_96DA9:
        mov esi, dword [byte esp+030h]
        test esi, esi
        jle near loc_96E34
        mov ebx, dword [byte esp+038h]
        mov ecx, dword [esp]
        mov eax, ecx
        add ecx, esi
        mov dword [byte esp+044h], ecx
loc_96DC4:
        mov dword [byte esp+08h], eax
        mov dword [byte esp+048h], ebx
        mov ebp, dword [byte esp+04Ch]
        cmp ebx, ebp
        jge short loc_96E2D
        cmp eax, edx
        jge short loc_96E2D
        mov ecx, dword [byte esp+040h]
        add ecx, eax
        mov esi, dword [byte esp+04h]
        add esi, ebx
        test esi, esi
        jl short loc_96DF4
        cmp esi, ebp
        jge short loc_96DF4
        test ecx, ecx
        jl short loc_96DF4
        cmp ecx, edx
        jl short loc_96E09
loc_96DF4:
        mov esi, dword [byte esp+0Ch]
        add esi, dword [byte esp+08h]
        mov ecx, dword [byte esp+048h]
        imul ecx, edx
        mov byte [ecx+esi], 0
        jmp short loc_96E2D
loc_96E09:
        mov ebp, dword [byte esp+03Ch]
        add ebp, ecx
        mov ecx, esi
        imul ecx, edx
        add ecx, ebp
        mov esi, dword [byte esp+0Ch]
        add esi, eax
        mov dword [byte esp+014h], esi
        mov esi, ebx
        imul esi, edx
        add esi, dword [byte esp+014h]
        mov cl, byte [ecx]
        mov byte [esi], cl
loc_96E2D:
        inc eax
        cmp eax, dword [byte esp+044h]
        jl short loc_96DC4
loc_96E34:
        mov esi, dword [byte esp+038h]
        inc esi
        mov dword [byte esp+038h], esi
        cmp esi, dword [byte esp+024h]
        jl near loc_96DA9
loc_96E47:
        mov eax, dword [byte esp+030h]
        mov ebx, dword [esp]
        add ebx, eax
        mov dword [esp], ebx
        cmp edx, ebx
        jg near loc_96CBD
loc_96E5B:
        mov eax, dword [byte esp+030h]
        mov esi, dword [byte esp+020h]
        add esi, eax
        mov dword [byte esp+020h], esi
        cmp esi, dword [byte esp+04Ch]
        jl near loc_96CA2
loc_96E73:
        add esp, byte 50h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 090h
sub_96E7C:
        push esi
        push edi
        push ebp
        sub esp, byte 18h
        mov ebp, dword [byte esp+028h]
        mov edi, ebp
        mov eax, dword [byte ebp+020h]
        mov dword [byte esp+010h], eax
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte esp+04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte esp+08h], eax
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+010h]
        add edx, ebx
        dec edx
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, eax
        mov edx, dword [byte esp+08h]
        add edx, ebx
        dec edx
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        imul esi, eax
        mov dword [byte esp+0Ch], esi
        mov ecx, dword [byte ebp+030h]
        push ecx
        call MemDescPtr
        add esp, byte 4
        add eax, dword [byte ebp+02Ch]
        push eax
        call _os_handle_3
        add esp, byte 4
        mov esi, eax
        mov edx, dword [byte esp+0Ch]
        add edx, eax
        mov dword [byte esp+014h], edx
        push ebp
        call sub_96A80
        add esp, byte 4
        test eax, eax
        je short loc_96EFF
        mov eax, dword [byte ebp+034h]
        jmp near loc_9706F
loc_96EFF:
        mov edx, dword [byte ebp+03Ch]
        mov eax, dword [byte ebp+038h]
        mov dword [byte ebp+03Ch], eax
        mov eax, dword [byte ebp+034h]
        mov dword [byte ebp+038h], eax
        mov dword [byte ebp+034h], edx
        cmp dword [byte ebp+024h], byte 0
        je short loc_96F3D
        mov edx, dword [byte ebp+030h]
        push edx
        call MemDescPtr
        add esp, byte 4
        push eax
        call _os_handle_3
        add esp, byte 4
        mov esi, eax
        push byte 2
        push eax
        mov ebx, dword [byte ebp+024h]
        push ebx
        call DosReadFile
        add esp, byte 0Ch
loc_96F3D:
        cmp byte [esi], 0
        jne short loc_96F90
        cmp byte [byte esi+01h], 0
        jne short loc_96F90
        mov eax, dword [byte esp+04h]
        imul eax, dword [byte esp+08h]
        add esi, byte 2
        lea ebp, [byte eax+02h]
        mov ecx, dword [byte edi+024h]
        test ecx, ecx
        je short loc_96F77
        push eax
        mov eax, dword [byte edi+034h]
        mov eax, dword [byte eax+02Ch]
        add eax, byte 10h
        push eax
        push ecx
        call DosReadFile
        add esp, byte 0Ch
        jmp near loc_97066
loc_96F77:
        push eax
        mov eax, dword [byte edi+034h]
        mov eax, dword [byte eax+02Ch]
        add eax, byte 10h
        push eax
        push esi
        call bcopy
        add esp, byte 0Ch
        jmp near loc_97066
loc_96F90:
        mov ecx, dword [byte edi+024h]
        test ecx, ecx
        jne short loc_96FC7
        add esi, byte 2
        xor eax, eax
        mov al, byte [byte esi+01h]
        shl eax, 8
        xor edx, edx
        mov dl, byte [esi]
        add edx, eax
        xor eax, eax
        mov al, byte [byte esi+02h]
        shl eax, 10h
        add edx, eax
        xor eax, eax
        mov al, byte [byte esi+03h]
        shl eax, 18h
        lea ebp, [edx+eax]
        add esi, byte 4
        add dword [byte esp+014h], byte 6
        jmp short loc_9702F
loc_96FC7:
        push byte 4
        lea eax, [byte esp+04h]
        push eax
        push ecx
        call DosReadFile
        add esp, byte 0Ch
        xor eax, eax
        mov al, byte [byte esp+01h]
        shl eax, 8
        xor edx, edx
        mov dl, byte [esp]
        add edx, eax
        xor eax, eax
        mov al, byte [byte esp+02h]
        shl eax, 10h
        lea ebp, [edx+eax]
        xor eax, eax
        mov al, byte [byte esp+03h]
        shl eax, 18h
        add ebp, eax
        mov eax, dword [byte edi+030h]
        push eax
        call MemDescPtr
        add esp, byte 4
        push eax
        call _os_handle_3
        add esp, byte 4
        mov esi, eax
        push ebp
        push eax
        mov ebx, dword [byte edi+024h]
        push ebx
        call DosReadFile
        add esp, byte 0Ch
        mov eax, esi
        mov ecx, dword [byte esp+0Ch]
        add eax, ecx
        mov dword [byte esp+014h], eax
loc_9702F:
        add ebp, byte 6
        cmp dword [byte esp+010h], byte 4
        jne short loc_97059
        mov ebx, dword [byte esp+014h]
        mov edx, esi
        mov eax, edi
        call sub_96AC4
        inc dword [byte edi+04h]
        add dword [byte edi+02Ch], ebp
        mov eax, dword [byte edi+034h]
        mov eax, dword [byte eax+02Ch]
        add esp, byte 18h
        pop ebp
        pop edi
        pop esi
        ret
loc_97059:
        mov ebx, dword [byte esp+014h]
        mov edx, esi
        mov eax, edi
        call sub_96C4C
loc_97066:
        inc dword [byte edi+04h]
        add dword [byte edi+02Ch], ebp
        mov eax, dword [byte edi+034h]
loc_9706F:
        mov eax, dword [byte eax+02Ch]
        add esp, byte 18h
        pop ebp
        pop edi
        pop esi
        ret
SndOpenDriver:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ebx, eax
        test eax, eax
        jl short loc_9708D
        cmp eax, byte 6
        jle short loc_97097
loc_9708D:
        mov eax, 0FFFFFFFFh
        jmp near loc_9715C
loc_97097:
        xor eax, eax
        jmp short loc_970AB
loc_9709B:
        imul edx, eax, byte 2Ch
        cmp ebx, dword [dword edx+SndHandleTable+028h]
        je near loc_9715C
        inc eax
loc_970AB:
        mov edx, dword [sndhandlecount]
        cmp eax, edx
        jl short loc_9709B
        test edx, edx
        jne short loc_970D1
        xor eax, eax
        mov edi, 0FFFFFFFFh
        jmp short loc_970CC
loc_970C2:
        imul edx, eax, byte 2Ch
        mov dword [dword edx+SndDriverTable+028h], edi
        inc eax
loc_970CC:
        cmp eax, byte 7
        jb short loc_970C2
loc_970D1:
        mov eax, dword [sndhandlecount]
        mov dword [esp], eax
        imul esi, ebx, byte 2Ch
        mov dword [dword esi+SndDriverTable+028h], eax
        imul ebp, eax, byte 2Ch
        mov ecx, 0Bh
        lea edi, [dword ebp+SndHandleTable]
        lea esi, [dword esi+SndDriverTable]
        rep movsd
        mov dword [dword ebp+SndHandleTable+028h], ebx
        xor ebx, ebx
        mov bl, byte [esp]
        mov eax, ebx
        call SndHandleDetect
        mov ecx, eax
        mov edx, eax
        mov eax, ebx
        call SndHandleOpen
        cwde
        test eax, eax
        je near loc_9708D
        mov edx, ecx
        mov eax, ebx
        call SndHandleInit
        mov al, byte [dword ebp+SndHandleTable+024h]
        mov edx, dword [esp]
        mov byte [dword edx+SndHandleType], al
        mov edx, 7
        mov eax, ebx
        call SndDriverCall
        test eax, eax
        jle short loc_97153
        cmp eax, byte 64h
        jge short loc_97153
        mov eax, dword [esp]
        mov dword [SndTimerHandle], eax
loc_97153:
        mov eax, dword [esp]
        inc dword [sndhandlecount]
loc_9715C:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
SndDriverHandle:
        cmp dword [sndhandlecount], byte 0
        jg short loc_97175
        mov eax, 0FFFFFFFFh
        ret
loc_97175:
        imul eax, byte 2Ch
        mov eax, dword [dword eax+SndDriverTable+028h]
        ret
SndHandleDetect:
        push ebx
        push ecx
        push edx
        and eax, 0FFh
        imul eax, byte 2Ch
        call dword [dword eax+SndHandleTable]
        pop edx
        pop ecx
        pop ebx
        ret
SndHandleOpen:
        push ebx
        push ecx
        and eax, 0FFh
        imul eax, byte 2Ch
        push edx
        call dword [dword eax+SndHandleTable+04h]
loc_971A5:
        add esp, byte 4
        pop ecx
        pop ebx
        ret
SndHandleInit:
        push ebx
        push ecx
        and eax, 0FFh
        imul eax, byte 2Ch
        push edx
        call dword [dword eax+SndHandleTable+08h]
        jmp short loc_971A5
SndHandleClose:
        push ebx
        push ecx
        push edx
        and eax, 0FFh
        cmp eax, dword [sndhandlecount]
        jge short loc_971D7
        imul eax, byte 2Ch
        call dword [dword eax+SndHandleTable+0Ch]
loc_971D7:
        pop edx
        pop ecx
        pop ebx
        ret
SndHandleService:
        push ebx
        push ecx
        push edx
        and eax, 0FFh
        cmp eax, dword [sndhandlecount]
        jge short loc_971F4
        imul eax, byte 2Ch
        call dword [dword eax+SndHandleTable+010h]
loc_971F4:
        pop edx
        pop ecx
        pop ebx
        ret
SndDriverCall:
        push ebx
        push ecx
        and eax, 0FFh
        imul eax, byte 2Ch
        push edx
        call dword [dword eax+SndHandleTable+014h]
        jmp short loc_971A5
SndHandleSetTrack:
        push ecx
        and eax, 0FFh
        cmp eax, dword [sndhandlecount]
        jge short loc_9722C
        imul eax, byte 2Ch
        push ebx
        xor ebx, ebx
        mov bx, dx
        push ebx
        call dword [dword eax+SndHandleTable+018h]
        add esp, byte 8
loc_9722C:
        pop ecx
        ret
SndHandleMidi:
        push ecx
        xor ecx, ecx
        mov cl, al
        cmp ecx, dword [sndhandlecount]
        jge short loc_97266
        mov ah, byte [ebx]
        and ah, 0F0h
        cmp ah, 80h
        je short loc_9724A
        cmp ah, 90h
        jne short loc_9724E
loc_9724A:
        add byte [byte ebx+01h], 18h
loc_9724E:
        and eax, 0FFh
        imul eax, byte 2Ch
        push ebx
        xor ebx, ebx
        mov bx, dx
        push ebx
        call dword [dword eax+SndHandleTable+01Ch]
        add esp, byte 8
loc_97266:
        pop ecx
        ret
SndHandlePlayDigi:
        push esi
        push edi
        push ebp
        and eax, 0FFh
        cmp eax, dword [sndhandlecount]
        jge short loc_972A5
        imul eax, byte 2Ch
        mov edi, dword [byte esp+024h]
        push edi
        mov ebp, dword [byte esp+024h]
        push ebp
        mov esi, dword [byte esp+024h]
        push esi
        mov edi, dword [byte esp+024h]
        push edi
        mov ebp, dword [byte esp+024h]
        push ebp
        mov esi, dword [byte esp+024h]
        push esi
        push ecx
        push ebx
        push edx
        call dword [dword eax+SndHandleTable+020h]
        add esp, byte 24h
loc_972A5:
        pop ebp
        pop edi
        pop esi
        ret 18h
NullDriverOpen:
        push ds
        call __GETDS
sub_972B1:
        mov eax, 1
        pop ds
        ret
NullDriverInit:
        push ds
        call __GETDS
sub_972BE:
        pop ds
        ret
NullDriverReturn:
        push ds
        call __GETDS
sub_972C6:
        pop ds
        ret
NullDriverQuery:
        push ds
        call __GETDS
sub_972CE:
        mov eax, 0FFFFFFFFh
        pop ds
        ret
NullDriverSetTrack:
        push ds
        call __GETDS
sub_972DB:
        pop ds
        ret
NullDriverMidi:
        push ds
        call __GETDS
sub_972E3:
        pop ds
        ret
NullDriverPlayDigi:
        push ds
        call __GETDS
sub_972EB:
        pop ds
        ret
        db 00h,00h,00h
