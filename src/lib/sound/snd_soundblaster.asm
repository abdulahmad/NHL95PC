; The Sound Blaster driver.
bits 32
%include "hockey.inc"
section s_9F226 progbits alloc exec nowrite align=1
extern __GETDS, str_BLASTER, dword_D524C, dword_D5250, dword_D525C, dword_F3462, dword_F34DC, getenv_
extern int386x_, memset_, outp_, sub_8F0D7, strtoul_, sub_A6D8D, sub_A6DA0, sub_A6DED
extern sub_A6E10, sub_A6E7B, sub_A6EA2, sub_A6EC3, sub_A6F3C, sub_A6FA2, sub_A6FE1, sub_A7094
extern sub_A70BC, sub_A70DD, sub_A905E, sub_A9BA4, sub_AA1D9, unk_D522E, unk_D5254, unk_D5258
extern unk_F3534, word_F3454, word_F3456, word_F345C, word_F3538, word_F354A, word_F3714, word_F3716
extern word_F3718
global ParseBlasterEnv, sub_9F22C, loc_9F25C, loc_9F293, loc_9F29D, loc_9F2AE, loc_9F2B7, loc_9F2C1
global loc_9F2C5, loc_9F2D1, loc_9F2F0, loc_9F311, loc_9F31D, loc_9F324, loc_9F333, ParseHexValue
global loc_9F358, loc_9F36C, sub_9F380, sub_9F387, sub_9F38D, loc_9F3CA, loc_9F40B, loc_9F413
global sub_9F418, sub_9F41E, loc_9F449, loc_9F47A, loc_9F49C, sub_9F4A0, sub_9F4A6, loc_9F4C6
global sub_9F4C8, sub_9F4CE, loc_9F4DE, loc_9F511, loc_9F523, loc_9F52A, loc_9F533, loc_9F53C
global loc_9F565, loc_9F566, sub_9F577, sub_9F57D, loc_9F5A1, loc_9F5AC, loc_9F5B9, loc_9F5C1
global loc_9F5C8, loc_9F5D8, loc_9F5E5, loc_9F5ED, loc_9F60B, loc_9F615, sub_9F622, sub_9F628
global sub_9F642, sub_9F648, sub_9F685, loc_9F6B3, loc_9F6EA, loc_9F714, loc_9F717, loc_9F71D
global sub_9F725, loc_9F77A, loc_9F782, loc_9F7B1, loc_9F7EA, loc_9F81B, loc_9F81E, loc_9F829
global loc_9F839, loc_9F858, loc_9F85C, loc_9F861, loc_9F880, loc_9F899, loc_9F89D, loc_9F8A4
global loc_9F8B3, loc_9F8BD, sub_9F8C5, sub_9F9C4, sub_9FA1A, loc_9FA48, sub_9FA5D, loc_9FA9D
global loc_9FAB4, loc_9FABF, loc_9FACA, loc_9FAD5, loc_9FAF8, loc_9FB1E, loc_9FB21, loc_9FB29
global loc_9FB35, loc_9FB55, loc_9FB58, loc_9FB5E, loc_9FB6A, loc_9FB85, loc_9FB88, sub_9FB93
global loc_9FBA8, sub_9FBAA, sub_9FBB5, sub_9FC04, sub_9FC24, loc_9FC70, loc_9FC76, loc_9FC8C
global sub_9FC94, sub_9FCAB, sub_9FD01, __rterrmsg_
ParseBlasterEnv:
        push ds
        call __GETDS
sub_9F22C:
        sub esp, byte 10h
        xor edx, edx
        mov dword [byte esp+0Ch], edx
        mov dword [byte esp+08h], edx
        mov dword [byte esp+04h], 0FFFFFFFFh
        mov dword [esp], 9
        mov eax, str_BLASTER
        call getenv_
        mov ecx, eax
        test eax, eax
        je near loc_9F333
loc_9F25C:
        mov ah, byte [ecx]
        test ah, ah
        je near loc_9F333
        mov al, ah
        cmp ah, 56h
        jb short loc_9F29D
        jbe near loc_9F2D1
        cmp ah, 64h
        jb short loc_9F293
        jbe near loc_9F2F0
        cmp ah, 69h
        jb near loc_9F324
        jbe short loc_9F2C5
        cmp ah, 76h
        je short loc_9F2D1
        jmp near loc_9F324
loc_9F293:
        cmp ah, 61h
        je short loc_9F2B7
        jmp near loc_9F324
loc_9F29D:
        cmp ah, 44h
        jb short loc_9F2AE
        jbe short loc_9F2F0
        cmp ah, 49h
        je short loc_9F2C5
        jmp near loc_9F324
loc_9F2AE:
        cmp ah, 41h
        jne near loc_9F324
loc_9F2B7:
        inc ecx
        mov ebx, 10h
        lea edx, [byte esp+0Ch]
loc_9F2C1:
        mov eax, ecx
        jmp short loc_9F31D
loc_9F2C5:
        inc ecx
        mov ebx, 0Ah
        lea edx, [byte esp+08h]
        jmp short loc_9F2C1
loc_9F2D1:
        inc ecx
        mov ebx, 0Ah
        mov edx, esp
        mov eax, ecx
        call ParseHexValue
        add ecx, eax
        mov edx, dword [esp]
        mov eax, dword [byte esp+0Ch]
        call __rterrmsg_
        jmp short loc_9F324
loc_9F2F0:
        cmp byte [byte ecx+01h], 45h
        jne short loc_9F311
        cmp byte [byte ecx+02h], 72h
        jne short loc_9F311
        cmp byte [byte ecx+03h], 46h
        jne short loc_9F311
        lea eax, [byte ecx+04h]
        mov ebx, 0Ah
        mov edx, unk_D5254
        jmp short loc_9F31D
loc_9F311:
        inc ecx
        mov ebx, 0Ah
        lea edx, [byte esp+04h]
        mov eax, ecx
loc_9F31D:
        call ParseHexValue
        add ecx, eax
loc_9F324:
        cmp byte [ecx], 0
        je near loc_9F25C
        inc ecx
        jmp near loc_9F25C
loc_9F333:
        mov eax, dword [byte esp+04h]
        mov dword [dword_D524C], eax
        mov eax, dword [byte esp+08h]
        shl eax, 10h
        add eax, dword [byte esp+0Ch]
        add esp, byte 10h
        pop ds
        ret
ParseHexValue:
        push ecx
        push esi
        push edi
        sub esp, byte 0Ch
        mov esi, eax
        mov edi, edx
        xor ecx, ecx
loc_9F358:
        lea eax, [esi+ecx]
        mov dl, byte [eax]
        test dl, dl
        je short loc_9F36C
        cmp dl, 20h
        je short loc_9F36C
        mov byte [esp+ecx], dl
        inc ecx
        jmp short loc_9F358
loc_9F36C:
        xor al, al
        mov byte [esp+ecx], al
        lea edx, [byte esp+08h]
        mov eax, esp
        call strtoul_
        mov dword [edi], eax
        mov eax, ecx
sub_9F380:
        add esp, byte 0Ch
        pop edi
        pop esi
        pop ecx
        ret
sub_9F387:
        push ds
        call __GETDS
sub_9F38D:
        push esi
        cmp dword [byte esp+0Ch], byte 0
        je near loc_9F413
        mov ebx, dword_D525C
        mov edx, unk_D5258
        mov eax, 40h
        call sub_9FCAB
        mov esi, eax
        mov edx, eax
        and edx, 0FFFFh
        cmp edx, 0FE00h
        jle short loc_9F3CA
        and eax, 0F0000h
        lea esi, [dword eax+010000h]
loc_9F3CA:
        mov ebx, 200h
        mov edx, 80h
        mov eax, esi
        call memset_
        push dword 200h
        push esi
        mov ebx, dword [dword_D524C]
        push ebx
        mov ecx, dword [byte esp+018h]
        push ecx
        call sub_A6DA0
        add esp, byte 10h
        movsx eax, al
        cmp eax, byte 0FFFFFFFFh
        je short loc_9F40B
        mov dword [dword_D5250], esi
        mov eax, 1
        pop esi
        pop ds
        ret
loc_9F40B:
        xor esi, esi
        mov dword [dword_D5250], esi
loc_9F413:
        xor eax, eax
        pop esi
        pop ds
        ret
sub_9F418:
        push ds
        call __GETDS
sub_9F41E:
        push esi
        push edi
        cmp dword [dword_D5250], byte 0
        je short loc_9F49C
        mov word [word_F3716], 0Fh
        xor ebx, ebx
        mov word [word_F3718], bx
        mov word [word_F3714], bx
        xor eax, eax
        mov ebx, unk_D522E
loc_9F449:
        mov cl, al
        mov edx, 1
        shl edx, cl
        mov ecx, edx
        mov edx, eax
        shl edx, 4
        add edx, eax
        mov word [nosplit edx*2+word_F3454], cx
        mov word [nosplit edx*2+word_F3456], ax
        mov dword [nosplit edx*2+dword_F3462], ebx
        inc eax
        cmp eax, byte 4
        jl short loc_9F449
        xor eax, eax
loc_9F47A:
        mov edx, eax
        shl edx, 4
        sub edx, eax
        mov ecx, 7
        lea edi, [nosplit edx*2+unk_F3534]
        mov esi, unk_D522E
        rep movsd
        movsw
        inc eax
        cmp eax, byte 10h
        jl short loc_9F47A
loc_9F49C:
        pop edi
        pop esi
        pop ds
        ret
sub_9F4A0:
        push ds
        call __GETDS
sub_9F4A6:
        cmp dword [dword_D5250], byte 0
        je short loc_9F4C6
        call sub_A6DED
        mov eax, dword [dword_D525C]
        call sub_9FD01
        xor ebx, ebx
        mov dword [dword_D5250], ebx
loc_9F4C6:
        pop ds
        ret
sub_9F4C8:
        push ds
        call __GETDS
sub_9F4CE:
        push esi
        push edi
        sub esp, byte 4
        xor edi, edi
        mov dword [esp], 1
        jmp short loc_9F533
loc_9F4DE:
        mov esi, edi
        shl esi, 4
        add esi, edi
        add esi, esi
        add esi, word_F3454
        movsx edx, word [esp]
        movsx eax, word [word_F3714]
        test edx, eax
        je short loc_9F511
        push edi
        call sub_A7094
        add esp, byte 4
        test ax, ax
        je short loc_9F511
        mov eax, esi
        call sub_9FBB5
loc_9F511:
        mov bx, word [byte esi+06h]
        cmp bx, byte 1
        jge short loc_9F523
        mov word [byte esi+06h], 0
        jmp short loc_9F52A
loc_9F523:
        mov ecx, ebx
        dec ecx
        mov word [byte esi+06h], cx
loc_9F52A:
        mov esi, dword [esp]
        add esi, esi
        mov dword [esp], esi
        inc edi
loc_9F533:
        cmp edi, byte 4
        jl short loc_9F4DE
        xor edi, edi
        jmp short loc_9F566
loc_9F53C:
        imul esi, edi, byte 16h
        add esi, dword_F34DC
        cmp word [byte esi+0Ah], byte 0
        je short loc_9F565
        mov eax, dword [esi]
        movsx esi, word [byte esi+010h]
        push esi
        movsx eax, word [byte eax+04h]
        push eax
        push byte 0
        push byte 0
        push edi
        call sub_A70DD
        add esp, byte 14h
loc_9F565:
        inc edi
loc_9F566:
        cmp edi, byte 4
        jl short loc_9F53C
        call sub_A905E
        add esp, byte 4
        pop edi
        pop esi
        pop ds
        ret
sub_9F577:
        push ds
        call __GETDS
sub_9F57D:
        push esi
        mov edx, dword [byte esp+0Ch]
        cmp dx, byte 9
        jb short loc_9F5AC
        jbe short loc_9F5C8
        cmp dx, byte 32h
        jb short loc_9F5A1
        jbe short loc_9F5ED
        cmp dx, byte 33h
        je near loc_9F615
        jmp near loc_9F60B
loc_9F5A1:
        cmp dx, byte 0Ah
        je short loc_9F5D8
        jmp near loc_9F60B
loc_9F5AC:
        cmp dx, byte 7
        jb short loc_9F60B
        ja short loc_9F5C1
        call sub_A6D8D
loc_9F5B9:
        movsx esi, ax
        mov eax, esi
        pop esi
        pop ds
        ret
loc_9F5C1:
        call sub_A9BA4
        jmp short loc_9F5B9
loc_9F5C8:
        movsx esi, word [byte esp+0Eh]
        push esi
        call sub_A7094
        add esp, byte 4
        jmp short loc_9F5B9
loc_9F5D8:
        movsx eax, word [byte esp+0Eh]
        push eax
        call sub_A70BC
        mov esi, eax
loc_9F5E5:
        add esp, byte 4
        mov eax, esi
        pop esi
        pop ds
        ret
loc_9F5ED:
        mov esi, dword [byte esp+0Ch]
        sar esi, 10h
        and esi, 0FFh
        push esi
        mov esi, dword [byte esp+010h]
        sar esi, 18h
        push esi
        call sub_A6EC3
        add esp, byte 8
loc_9F60B:
        mov esi, 0FFFFFFFFh
        mov eax, esi
        pop esi
        pop ds
        ret
loc_9F615:
        movsx eax, word [byte esp+0Eh]
        push eax
        call sub_AA1D9
        jmp short loc_9F5E5
sub_9F622:
        push ds
        call __GETDS
sub_9F628:
        movsx edx, word [byte esp+08h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [byte esp+0Ch]
        mov word [nosplit eax*2+word_F3538], dx
        pop ds
        ret
sub_9F642:
        push ds
        call __GETDS
sub_9F648:
        push esi
        push edi
        push ebp
        mov edx, dword [byte esp+034h]
        push edx
        mov ebx, dword [byte esp+034h]
        push ebx
        mov ecx, dword [byte esp+034h]
        push ecx
        mov esi, dword [byte esp+034h]
        push esi
        mov edi, dword [byte esp+034h]
        push edi
        mov ebp, dword [byte esp+034h]
        push ebp
        mov eax, dword [byte esp+030h]
        add eax, dword [byte esp+034h]
        push eax
        movsx eax, word [byte esp+030h]
        push eax
        call sub_A6FE1
        add esp, byte 20h
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
sub_9F685:
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        push edx
        movsx ecx, ax
        mov eax, ecx
        shl eax, 4
        sub eax, ecx
        add eax, eax
        mov edi, unk_F3534
        add edi, eax
        mov ax, word [edi]
        mov dword [byte esp+04h], eax
        xor edx, edx
        mov ebx, 1
        jmp near loc_9F717
loc_9F6B3:
        movsx ecx, bx
        movsx eax, word [byte esp+04h]
        test ecx, eax
        je short loc_9F714
        movsx esi, dx
        mov eax, esi
        shl eax, 4
        add eax, esi
        add eax, eax
        add eax, word_F3454
        cmp edi, dword [byte eax+0Eh]
        jne short loc_9F714
        mov ecx, dword [esp]
        cmp cx, word [byte eax+08h]
        jne short loc_9F714
        cmp byte [byte edi+014h], 0
        je short loc_9F6EA
        or word [byte edi+02h], bx
        jmp short loc_9F71D
loc_9F6EA:
        or word [word_F3714], bx
        sar word [byte eax+06h], 1
        imul eax, esi, byte 16h
        add eax, dword_F34DC
        mov word [byte eax+0Ah], 1
        cmp dx, byte 1
        jle short loc_9F71D
        push esi
        call sub_A6E7B
        add esp, byte 4
        jmp short loc_9F71D
loc_9F714:
        add ebx, ebx
        inc edx
loc_9F717:
        cmp dx, byte 4
        jl short loc_9F6B3
loc_9F71D:
        add esp, byte 8
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
sub_9F725:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov esi, eax
        mov dword [byte esp+08h], edx
        mov dword [byte esp+0Ch], ebx
        cwde
        mov edx, eax
        shl edx, 4
        sub edx, eax
        add edx, edx
        mov ecx, unk_F3534
        add ecx, edx
        cmp si, byte 9
        jne short loc_9F77A
        mov edx, dword [byte esp+08h]
        cmp dx, byte 24h
        jl near loc_9F8BD
        cmp dx, byte 64h
        jge near loc_9F8BD
        add edx, byte 5Ch
        movsx edx, dx
        call sub_9FC24
        mov dword [byte esp+010h], 3Ch
        jmp short loc_9F782
loc_9F77A:
        mov eax, dword [byte esp+08h]
        mov dword [byte esp+010h], eax
loc_9F782:
        cmp word [byte ecx+04h], byte 0
        je near loc_9F8BD
        cmp word [byte ecx+08h], byte 0
        je near loc_9F8BD
        mov edi, 7D00h
        mov dword [byte esp+04h], word_F3454
        xor ebx, ebx
        mov eax, 1
        jmp near loc_9F81E
loc_9F7B1:
        movsx esi, bx
        mov edx, esi
        shl edx, 4
        add edx, esi
        add edx, edx
        add edx, word_F3454
        movsx esi, ax
        mov dword [esp], esi
        movsx esi, word [word_F3718]
        and esi, dword [esp]
        movsx ebp, word [byte ecx+04h]
        test esi, ebp
        je short loc_9F7EA
        mov si, word [byte edx+06h]
        cmp di, si
        jle short loc_9F7EA
        mov edi, esi
        mov dword [byte esp+04h], edx
loc_9F7EA:
        movsx esi, word [ecx]
        mov dword [esp], esi
        movsx esi, ax
        and esi, dword [esp]
        movsx ebp, word [byte ecx+04h]
        test esi, ebp
        je short loc_9F81B
        cmp ecx, dword [byte edx+0Eh]
        jne short loc_9F81B
        mov esi, dword [byte esp+08h]
        cmp si, word [byte edx+08h]
        jne short loc_9F81B
        push edx
        movsx ebx, word [byte esp+010h]
        movsx edx, si
        jmp near loc_9F8B3
loc_9F81B:
        add eax, eax
        inc ebx
loc_9F81E:
        cmp bx, byte 4
        jl short loc_9F7B1
        xor ebx, ebx
        mov ax, word [ecx]
loc_9F829:
        test ax, ax
        je short loc_9F839
        mov edx, eax
        neg edx
        and edx, eax
        xor eax, edx
        inc ebx
        jmp short loc_9F829
loc_9F839:
        cmp bx, word [byte ecx+08h]
        jge short loc_9F880
        mov ax, word [word_F3716]
        and ax, word [byte ecx+04h]
        je short loc_9F880
        mov edx, eax
        neg edx
        and eax, edx
        mov ebx, 0FFFFFFFFh
        jmp short loc_9F85C
loc_9F858:
        sar ax, 1
        inc ebx
loc_9F85C:
        test ax, ax
        jne short loc_9F858
loc_9F861:
        movsx eax, bx
        mov edx, eax
        shl edx, 4
        add edx, eax
        add edx, edx
        add edx, word_F3454
        push edx
        movsx ebx, word [byte esp+010h]
        movsx edx, word [byte esp+0Ch]
        jmp short loc_9F8B3
loc_9F880:
        mov ax, word [word_F3714]
        and ax, word [byte ecx+04h]
        je short loc_9F8A4
        mov edx, eax
        neg edx
        and eax, edx
        mov ebx, 0FFFFFFFFh
        jmp short loc_9F89D
loc_9F899:
        sar ax, 1
        inc ebx
loc_9F89D:
        test ax, ax
        jne short loc_9F899
        jmp short loc_9F861
loc_9F8A4:
        mov edi, dword [byte esp+04h]
        push edi
        movsx ebx, word [byte esp+010h]
        movsx edx, word [byte esp+0Ch]
loc_9F8B3:
        movsx eax, word [byte esp+014h]
        call sub_9F8C5
loc_9F8BD:
        add esp, byte 14h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
sub_9F8C5:
        push esi
        push edi
        push eax
        push edx
        push ebx
        mov edi, ecx
        mov esi, dword [byte esp+018h]
        movsx eax, word [byte esi+02h]
        call sub_9FC04
        mov dx, word [esi]
        not edx
        mov eax, dword [byte esi+0Eh]
        and word [eax], dx
        mov eax, dword [byte esi+0Eh]
        mov dx, word [esi]
        not edx
        and word [byte eax+02h], dx
        mov dword [byte esi+0Eh], edi
        mov ax, word [byte edi+06h]
        mov word [byte esi+0Ch], ax
        mov eax, dword [byte edi+0Ah]
        mov dword [byte esi+012h], eax
        mov eax, dword [byte edi+0Eh]
        mov dword [byte esi+016h], eax
        xor edx, edx
        mov dl, byte [byte eax+0Dh]
        push edx
        movsx ecx, byte [byte eax+0Ah]
        movsx ebx, byte [byte eax+08h]
        mov edx, dword [byte esi+012h]
        movsx eax, word [byte esi+02h]
        call sub_9F9C4
        mov eax, dword [byte esi+016h]
        mov al, byte [byte eax+0Ch]
        xor ah, ah
        shl eax, 6
        mov word [byte esi+06h], ax
        mov eax, dword [byte esp+04h]
        mov word [byte esi+08h], ax
        mov eax, dword [esp]
        mov word [byte esi+0Ah], ax
        mov ax, word [esi]
        not eax
        and word [word_F3716], ax
        mov ax, word [esi]
        or word [word_F3718], ax
        mov ax, word [esi]
        not eax
        and word [word_F3714], ax
        mov ax, word [esi]
        or word [edi], ax
        mov ax, word [esi]
        not eax
        and word [byte edi+02h], ax
        lea edx, [byte edi+012h]
        movsx eax, word [byte esi+02h]
        call sub_9FBAA
        movsx ebx, word [esp]
        mov eax, dword [byte edi+0Eh]
        movsx ax, byte [byte eax+07h]
        add eax, dword [byte esp+08h]
        movsx edx, ax
        movsx eax, word [byte esi+02h]
        call sub_9FA1A
        movsx ebx, byte [byte edi+015h]
        movsx eax, word [byte esi+02h]
        mov edx, 1
        call sub_9FB93
        movsx ebx, byte [byte edi+012h]
        movsx eax, word [byte esi+02h]
        mov edx, 7
        call sub_9FB93
        add esp, byte 0Ch
        pop edi
        pop esi
        ret 4
sub_9F9C4:
        push esi
        push edi
        push ebp
        mov edi, edx
        movsx ebp, ax
        imul esi, ebp, byte 16h
        add esi, dword_F34DC
        mov dword [byte esi+04h], edx
        mov word [byte esi+012h], bx
        mov word [byte esi+010h], cx
        mov eax, dword [byte esp+010h]
        mov word [byte esi+014h], ax
        lea esi, [byte edx+010h]
        xor eax, eax
        mov ax, word [byte esi+02h]
        push eax
        push ebp
        call sub_A6F3C
        add esp, byte 8
        mov edx, dword [byte esi+0Ch]
        push edx
        mov ebx, dword [byte esi+08h]
        push ebx
        mov ecx, dword [byte esi+04h]
        push ecx
        mov esi, dword [byte edi+0Ch]
        push esi
        push ebp
        call sub_A6FA2
        add esp, byte 14h
        pop ebp
        pop edi
        pop esi
        ret 4
sub_9FA1A:
        push ecx
        push esi
        mov ecx, eax
        cwde
        imul eax, byte 16h
        add eax, dword_F34DC
        mov word [byte eax+0Ch], dx
        mov word [byte eax+0Eh], dx
        mov word [byte eax+0Ah], 3
        movsx esi, word [byte eax+014h]
        movsx eax, bx
        add eax, esi
        cmp eax, byte 7Fh
        jl short loc_9FA48
        mov eax, 7Fh
loc_9FA48:
        cwde
        push eax
        movsx eax, dx
        push eax
        movsx eax, cx
        push eax
        call sub_A6E10
        add esp, byte 0Ch
        pop esi
        pop ecx
        ret
sub_9FA5D:
        push ecx
        push esi
        push edi
        push eax
        push edx
        push ebx
        movsx edx, ax
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        mov ebx, unk_F3534
        add ebx, eax
        mov edx, dword [byte esp+04h]
        cmp dx, byte 0Ah
        jb short loc_9FA9D
        jbe short loc_9FACA
        cmp dx, byte 40h
        jb near loc_9FB5E
        jbe short loc_9FAD5
        cmp dx, byte 7Bh
        je near loc_9FB29
        jmp near loc_9FB5E
loc_9FA9D:
        cmp dx, byte 1
        jb near loc_9FB5E
        jbe short loc_9FAB4
        cmp dx, byte 7
        je short loc_9FABF
        jmp near loc_9FB5E
loc_9FAB4:
        mov al, byte [esp]
        mov byte [byte ebx+015h], al
        jmp near loc_9FB5E
loc_9FABF:
        mov al, byte [esp]
        mov byte [byte ebx+012h], al
        jmp near loc_9FB5E
loc_9FACA:
        mov al, byte [esp]
        mov byte [byte ebx+013h], al
        jmp near loc_9FB5E
loc_9FAD5:
        mov al, byte [esp]
        mov byte [byte ebx+014h], al
        mov edx, dword [esp]
        test dx, dx
        jne near loc_9FB5E
        mov di, word [byte ebx+02h]
        mov word [byte ebx+02h], dx
        xor ecx, ecx
        mov esi, 1
        jmp short loc_9FB21
loc_9FAF8:
        movsx edx, si
        movsx eax, di
        test edx, eax
        je short loc_9FB1E
        movsx edx, cx
        mov eax, edx
        shl eax, 4
        add eax, edx
        movsx edx, word [nosplit eax*2+word_F345C]
        movsx eax, word [byte esp+08h]
        call sub_9F685
loc_9FB1E:
        add esi, esi
        inc ecx
loc_9FB21:
        cmp cx, byte 4
        jl short loc_9FAF8
        jmp short loc_9FB5E
loc_9FB29:
        mov di, word [ebx]
        xor ecx, ecx
        mov esi, 1
        jmp short loc_9FB58
loc_9FB35:
        movsx edx, si
        movsx eax, di
        test edx, eax
        je short loc_9FB55
        movsx edx, cx
        mov eax, edx
        shl eax, 4
        add eax, edx
        add eax, eax
        add eax, word_F3454
        call sub_9FBB5
loc_9FB55:
        add esi, esi
        inc ecx
loc_9FB58:
        cmp cx, byte 4
        jl short loc_9FB35
loc_9FB5E:
        mov di, word [ebx]
        xor ecx, ecx
        mov esi, 1
        jmp short loc_9FB88
loc_9FB6A:
        movsx eax, si
        movsx edx, di
        test eax, edx
        je short loc_9FB85
        movsx ebx, word [esp]
        movsx edx, word [byte esp+04h]
        movsx eax, cx
        call sub_9FB93
loc_9FB85:
        add esi, esi
        inc ecx
loc_9FB88:
        cmp cx, byte 4
        jl short loc_9FB6A
        jmp near sub_9F380
sub_9FB93:
        push ecx
        cmp dx, byte 7
        jne short loc_9FBA8
        movsx edx, bx
        push edx
        cwde
        push eax
        call sub_A6EC3
        add esp, byte 8
loc_9FBA8:
        pop ecx
        ret
sub_9FBAA:
        cwde
        imul eax, byte 16h
        mov dword [dword eax+dword_F34DC], edx
        ret
sub_9FBB5:
        push ebx
        push edx
        mov edx, eax
        movsx eax, word [byte eax+02h]
        call sub_9FC04
        mov word [byte edx+06h], 0
        mov ax, word [edx]
        or word [word_F3716], ax
        mov ax, word [edx]
        not eax
        and word [word_F3718], ax
        mov ax, word [edx]
        not eax
        and word [word_F3714], ax
        mov bx, word [edx]
        not ebx
        mov eax, dword [byte edx+0Eh]
        and word [eax], bx
        mov eax, dword [byte edx+0Eh]
        mov dx, word [edx]
        not edx
        and word [byte eax+02h], dx
        pop edx
        pop ebx
        ret
sub_9FC04:
        push ebx
        push ecx
        push edx
        cwde
        imul edx, eax, byte 16h
        add edx, dword_F34DC
        mov word [byte edx+0Ah], 0
        push eax
        call sub_A6EA2
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
sub_9FC24:
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov edi, eax
        mov word [esp], dx
        cwde
        mov esi, eax
        shl esi, 4
        sub esi, eax
        add esi, esi
        add esi, unk_F3534
        xor eax, eax
        mov al, byte [esp]
        push eax
        call sub_8F0D7
        add esp, byte 4
        mov dword [byte esi+0Eh], eax
        test eax, eax
        je short loc_9FC8C
        mov eax, dword [byte eax+010h]
        mov dword [byte esi+0Ah], eax
        cmp di, byte 9
        je short loc_9FC70
        mov eax, dword [byte esi+0Eh]
        mov al, byte [byte eax+06h]
        xor ah, ah
        mov word [byte esi+08h], ax
        jmp short loc_9FC76
loc_9FC70:
        mov word [byte esi+08h], 4
loc_9FC76:
        mov eax, dword [byte esi+0Eh]
        mov ax, word [byte eax+02h]
        xor ah, ah
        and al, 0Fh
        mov word [byte esi+04h], ax
        mov eax, dword [esp]
        mov word [byte esi+06h], ax
loc_9FC8C:
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
sub_9FC94:
        push ebx
        mov ebx, edx
        movsx edx, ax
        mov eax, edx
        shl eax, 4
        sub eax, edx
        mov word [nosplit eax*2+word_F354A], bx
        pop ebx
        ret
sub_9FCAB:
        push ecx
        push esi
        push edi
        sub esp, byte 28h
        mov ecx, eax
        mov esi, edx
        mov edi, ebx
        mov ebx, 0Ch
        xor edx, edx
        lea eax, [byte esp+01Ch]
        call memset_
        mov word [esp], 100h
        mov word [byte esp+04h], cx
        lea ecx, [byte esp+01Ch]
        mov ebx, esp
        mov edx, esp
        mov eax, 31h
        call int386x_
        xor eax, eax
        mov ax, word [esp]
        mov dword [esi], eax
        xor eax, eax
        mov ax, word [byte esp+0Ch]
        mov dword [edi], eax
        mov eax, dword [esi]
        shl eax, 4
        add esp, byte 28h
        pop edi
        pop esi
        pop ecx
        ret
sub_9FD01:
        push ebx
        push ecx
        push edx
        sub esp, byte 28h
        mov ecx, eax
        mov ebx, 0Ch
        xor edx, edx
        lea eax, [byte esp+01Ch]
        call memset_
        mov word [esp], 101h
        mov word [byte esp+0Ch], cx
        lea ecx, [byte esp+01Ch]
        mov ebx, esp
        mov edx, esp
        mov eax, 31h
        call int386x_
        add esp, byte 28h
        pop edx
        pop ecx
        pop ebx
        ret
__rterrmsg_:
        push ebx
        push ecx
        push esi
        lea esi, [byte eax+04h]
        lea ecx, [byte eax+05h]
        mov bl, dl
        shl bl, 4
        or bl, dl
        mov edx, 4
        mov eax, esi
        call outp_
        movsx ebx, bl
        mov edx, ebx
        mov eax, ecx
        call outp_
        mov edx, 22h
        mov eax, esi
        call outp_
        mov edx, ebx
        mov eax, ecx
        call outp_
        mov edx, 26h
        mov eax, esi
        call outp_
        mov edx, ebx
        mov eax, ecx
        call outp_
        pop esi
        pop ecx
        pop ebx
        ret
        db 00h
