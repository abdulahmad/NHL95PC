; Drawing shapes from a shape file.
bits 32
%include "hockey.inc"
section s_98B30 progbits alloc exec nowrite align=1
extern abs_, str_RemovewindowROWSPACE, str_FshVshQfsQvs, str_Vsh, str_Qvs, byte_D4F5C, byte_D4F5D, byte_D4F5E
extern byte_F1704, byte_F1705, byte_F1784, byte_F188C, byte_F188D, byte_F188E, byte_F1A1C, byte_F234D
extern byte_F234E, dword_D2F60, dword_D4F58, sndhandlecount, dword_D4F8A, dword_D4F92, dword_D4F96, dword_D4F9A
extern dword_EDAA8, dword_F1888, dword_F1890, dword_F189C, dword_F22FC, FatalError, stricmp_, AllocMemBlockEx
extern sub_8D2F0, sub_8D728, sub_8F0D7, sub_8FCAC, sub_971DB, SndDriverCall, sub_9722E, sub_A2000
extern sub_A2610, sub_A27C4, sub_A28F0, sub_A2AB8, sub_B6FFC, sub_B7005, unk_F1884, unk_F21FC
extern word_D4F88
global sub_98B30, sub_98BEC, sub_98D20, loc_98D43, loc_98D67, loc_98D6D, loc_98D7D, loc_98D8E
global loc_98DA1, loc_98DB7, loc_98DC3, loc_98DCD, loc_98DCF, removewindow, loc_98DF6, loc_98E06
global loc_98E17, loc_98E36, loc_98E47, sub_98E50, loc_98EAA, loc_98EFB, loc_98F0A, sub_98F11
global loc_98F44, sub_98F46, loc_98F54, loc_98FA5, loc_98FA7, loc_98FD7, loc_98FDB, loc_98FEC
global loc_98FED, loc_9900E, loc_99064, loc_9906B, loc_9907B, loc_99091, loc_9909A, loc_990C4
global sub_990CB, loc_99116, loc_9912B, loc_9912F, loc_99165, loc_99185, loc_991C1, loc_991C7
global loc_991E8, loc_991FF, loc_99203, loc_9921B, loc_99225, loc_9928F, loc_9929C, loc_992A9
global loc_992C8, loc_992D6, loc_992DE, loc_992F8, loc_9930E, loc_99329, loc_99331, loc_9933E
global loc_99351, loc_9936D, loc_993A4, loc_993AC, loc_993C5, loc_993CF, loc_993F3, loc_99424
global loc_99428, loc_99436, loc_99449, loc_99455, loc_9947A, loc_994B0, loc_994DF, loc_99503
global loc_99506, loc_99513, loc_9951A, sub_99522, loc_9955D, loc_99594, loc_995DB, loc_99600
global sub_99620, sub_9966E, loc_99687, loc_9969C, loc_996A0, sub_996B0, sub_99700, loc_99729
global loc_99754, loc_9975B, loc_99786, loc_99798, loc_997A6, sub_997B7, loc_997F1, loc_99812
global loc_9981F, sub_99822, loc_99845, loc_9985E, loc_9989B, sub_998A0, jpt_998DD, sub_99925
global loc_99936, loc_99972, loc_99976, loc_99981, loc_99988, loc_9998E, loc_99991, loc_999A5
global loc_999AC, loc_999BD, loc_999CF, loc_999E1, loc_999FC, sub_99A0B, sub_99A0E
sub_98B30:
        push esi
        push edi
        push ebp
        sub esp, byte 34h
        mov ebp, dword [byte esp+044h]
        mov esi, dword [byte esp+048h]
        push ebp
        call sub_B6FFC
        mov edi, eax
        add esp, byte 4
        push ebp
        call sub_B7005
        add esp, byte 4
        mov ebx, 1
        mov dword [byte esp+018h], ebx
        mov dword [byte esp+01Ch], ebx
        sub edi, byte 3
        mov dword [byte esp+020h], edi
        mov dword [byte esp+024h], ebx
        mov dword [byte esp+030h], edi
        mov dword [byte esp+028h], edi
        lea edi, [byte eax-03h]
        mov dword [byte esp+02Ch], edi
        push esi
        lea eax, [byte esp+01Ch]
        push eax
        push ebp
        call sub_A2000
        add esp, byte 0Ch
        mov eax, dword [byte esp+030h]
        mov dword [byte esp+018h], eax
        mov dword [byte esp+01Ch], edi
        mov eax, 1
        mov dword [byte esp+020h], eax
        mov dword [byte esp+024h], edi
        mov dword [byte esp+028h], eax
        mov dword [byte esp+02Ch], eax
        mov eax, dword [byte esi+010h]
        mov dword [esp], eax
        mov eax, dword [byte esi+014h]
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esi+018h]
        mov dword [byte esp+08h], eax
        mov eax, dword [byte esi+01Ch]
        mov dword [byte esp+0Ch], eax
        mov eax, dword [esi]
        mov dword [byte esp+010h], eax
        mov eax, dword [byte esi+04h]
        mov dword [byte esp+014h], eax
        mov eax, esp
        push eax
        lea eax, [byte esp+01Ch]
        push eax
        push ebp
        call sub_A2000
        add esp, byte 0Ch
        add esp, byte 34h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
sub_98BEC:
        push esi
        push edi
        push ebp
        sub esp, byte 34h
        mov edi, dword [byte esp+048h]
        mov esi, dword [byte esp+04Ch]
        mov edx, dword [byte esp+044h]
        push edx
        call sub_B6FFC
        mov dword [byte esp+034h], eax
        add esp, byte 4
        mov ebx, dword [byte esp+044h]
        push ebx
        call sub_B7005
        mov ebp, eax
        add esp, byte 4
        mov ecx, 1
        mov dword [esp], ecx
        mov dword [byte esp+04h], ecx
        mov eax, dword [byte esp+030h]
        sub eax, byte 2
        mov dword [byte esp+08h], eax
        mov dword [byte esp+0Ch], ecx
        mov dword [byte esp+030h], eax
        mov dword [byte esp+010h], eax
        sub ebp, byte 2
        mov dword [byte esp+014h], ebp
        mov eax, dword [esi]
        mov eax, dword [edi+eax*8]
        mov dword [byte esp+018h], eax
        mov eax, dword [esi]
        mov eax, dword [byte edi+eax*8+04h]
        mov dword [byte esp+01Ch], eax
        mov eax, dword [byte esi+04h]
        mov eax, dword [edi+eax*8]
        mov dword [byte esp+020h], eax
        mov eax, dword [byte esi+04h]
        mov eax, dword [byte edi+eax*8+04h]
        mov dword [byte esp+024h], eax
        mov eax, dword [byte esi+08h]
        mov eax, dword [edi+eax*8]
        mov dword [byte esp+028h], eax
        mov eax, dword [byte esi+08h]
        mov eax, dword [byte edi+eax*8+04h]
        mov dword [byte esp+02Ch], eax
        lea eax, [byte esp+018h]
        push eax
        lea eax, [byte esp+04h]
        push eax
        mov ebx, dword [byte esp+04Ch]
        push ebx
        call sub_A2000
        add esp, byte 0Ch
        mov eax, dword [byte esp+030h]
        mov dword [esp], eax
        mov dword [byte esp+04h], ebp
        mov ecx, 1
        mov dword [byte esp+08h], ecx
        mov dword [byte esp+0Ch], ebp
        mov dword [byte esp+010h], ecx
        mov dword [byte esp+014h], ecx
        mov eax, dword [byte esi+08h]
        mov eax, dword [edi+eax*8]
        mov dword [byte esp+018h], eax
        mov eax, dword [byte esi+08h]
        mov eax, dword [byte edi+eax*8+04h]
        mov dword [byte esp+01Ch], eax
        mov eax, dword [byte esi+0Ch]
        mov eax, dword [edi+eax*8]
        mov dword [byte esp+020h], eax
        mov eax, dword [byte esi+0Ch]
        mov eax, dword [byte edi+eax*8+04h]
        mov dword [byte esp+024h], eax
        mov eax, dword [esi]
        mov eax, dword [edi+eax*8]
        mov dword [byte esp+028h], eax
        mov eax, dword [esi]
        mov eax, dword [byte edi+eax*8+04h]
        mov dword [byte esp+02Ch], eax
        lea eax, [byte esp+018h]
        push eax
        lea eax, [byte esp+04h]
        push eax
        mov edx, dword [byte esp+04Ch]
        push edx
        call sub_A2000
        add esp, byte 0Ch
        add esp, byte 34h
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
sub_98D20:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ecx, eax
        mov edi, edx
        mov esi, ebx
        xor ebx, ebx
        mov eax, dword [dword_D2F60]
        cmp eax, dword [dword_EDAA8]
        jae short loc_98D7D
        mov edx, ecx
        add edx, edi
        mov dword [esp], edx
loc_98D43:
        mov edx, dword [eax]
        cmp edx, esi
        jl short loc_98D6D
        cmp dword [byte eax+04h], byte 0
        jbe short loc_98D67
        cmp ecx, dword [byte eax+08h]
        jne short loc_98D6D
        mov ebp, dword [byte eax+0Ch]
        cmp ebp, dword [esp]
        jne short loc_98D6D
        inc dword [byte eax+04h]
        add eax, byte 8
        jmp near loc_98DCF
loc_98D67:
        test ebx, ebx
        jne short loc_98D6D
        mov ebx, eax
loc_98D6D:
        shl edx, 2
        add edx, byte 8
        add eax, edx
        cmp eax, dword [dword_EDAA8]
        jb short loc_98D43
loc_98D7D:
        test ebx, ebx
        je short loc_98DCD
        mov eax, dword [ebx]
        lea edx, [byte esi+08h]
        cmp eax, edx
        jge short loc_98D8E
        mov esi, eax
        jmp short loc_98DA1
loc_98D8E:
        mov edx, eax
        sub edx, esi
        sub edx, byte 2
        mov dword [byte ebx+esi*4+08h], edx
        mov dword [byte ebx+esi*4+0Ch], 0
loc_98DA1:
        mov dword [ebx], esi
        add ebx, byte 4
        mov dword [ebx], 1
        xor edx, edx
        add ebx, byte 4
        test esi, esi
        jle short loc_98DC3
        mov eax, ebx
loc_98DB7:
        mov dword [eax], ecx
        add ecx, edi
        add eax, byte 4
        inc edx
        cmp edx, esi
        jl short loc_98DB7
loc_98DC3:
        mov eax, ebx
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
loc_98DCD:
        xor eax, eax
loc_98DCF:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 090h
removewindow:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov edx, eax
        mov ebx, dword [byte eax+04h]
        dec ebx
        mov dword [byte eax+04h], ebx
        test ebx, ebx
        ja short loc_98E47
        mov esi, dword [dword_D2F60]
        xor edi, edi
        cmp esi, eax
        jae short loc_98E06
loc_98DF6:
        mov edi, esi
        mov eax, dword [esi]
        add eax, byte 2
        shl eax, 2
        add esi, eax
        cmp esi, edx
        jb short loc_98DF6
loc_98E06:
        cmp esi, edx
        je short loc_98E17
        push str_RemovewindowROWSPACE
        call FatalError
        add esp, byte 4
loc_98E17:
        mov eax, dword [esi]
        add eax, byte 2
        shl eax, 2
        add eax, esi
        cmp eax, dword [dword_EDAA8]
        jae short loc_98E36
        cmp dword [byte eax+04h], byte 0
        ja short loc_98E36
        mov eax, dword [eax]
        add eax, byte 2
        add dword [esi], eax
loc_98E36:
        test edi, edi
        je short loc_98E47
        cmp dword [byte edi+04h], byte 0
        ja short loc_98E47
        mov eax, dword [esi]
        add eax, byte 2
        add dword [edi], eax
loc_98E47:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 00h,00h,00h
sub_98E50:
        push esi
        push edi
        push ebp
        sub esp, byte 64h
        mov ebp, dword [byte esp+078h]
        mov edi, dword [byte esp+07Ch]
        push str_FshVshQfsQvs
        lea eax, [byte esp+04h]
        push eax
        mov edx, dword [byte esp+07Ch]
        push edx
        call sub_A2610
        mov esi, eax
        add esp, byte 0Ch
        mov eax, esp
        push eax
        call sub_8D728
        add esp, byte 4
        test eax, eax
        jne near loc_98F0A
        mov edx, str_Vsh
        mov eax, esi
        call stricmp_
        test eax, eax
        je short loc_98EAA
        mov edx, str_Qvs
        mov eax, esi
        call stricmp_
        test eax, eax
        jne short loc_98EFB
loc_98EAA:
        push edi
        mov eax, ebp
        xor al, 20h
        push eax
        lea eax, [byte esp+08h]
        push eax
        call sub_A27C4
        mov esi, eax
        add esp, byte 0Ch
        test eax, eax
        je short loc_98F0A
        mov ebx, dword [eax]
        push ebx
        call sub_A2AB8
        add esp, byte 4
        push edi
        push ebp
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        call AllocMemBlockEx
        mov edi, eax
        add esp, byte 10h
        mov ecx, dword [eax]
        push ecx
        mov ebp, dword [esi]
        push ebp
        call sub_A28F0
        add esp, byte 8
        push esi
        call sub_8D2F0
        add esp, byte 4
        mov eax, edi
        jmp short loc_98F0A
loc_98EFB:
        push edi
        push ebp
        lea eax, [byte esp+08h]
        push eax
        call sub_A27C4
        add esp, byte 0Ch
loc_98F0A:
        add esp, byte 64h
        pop ebp
        pop edi
        pop esi
        ret
sub_98F11:
        push edx
        mov ah, byte [byte_D4F5E]
        test ah, ah
        jne short loc_98F44
        cmp word [word_D4F88], byte 0
        jne short loc_98F44
        cmp dword [sndhandlecount], byte 0
        je short loc_98F44
        mov dl, ah
        inc dl
        mov byte [byte_D4F5E], dl
        call sub_98F46
        dec byte [byte_D4F5E]
loc_98F44:
        pop edx
        ret
sub_98F46:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        xor ecx, ecx
        inc byte [byte_D4F5D]
loc_98F54:
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        mov ebx, dword_F22FC
        add ebx, eax
        cmp dword [ebx], byte 0
        je short loc_98FA7
        mov eax, dword [byte ebx+08h]
        mov esi, dword [byte ebx+04h]
        sub esi, eax
        mov dword [byte ebx+04h], esi
        sar esi, 18h
        cmp esi, dword [ebx]
        je short loc_98FA7
        mov eax, ecx
        shl eax, 18h
        mov edx, esi
        shl edx, 10h
        add eax, byte 32h
        add edx, eax
        xor eax, eax
        mov al, byte [byte ebx+010h]
        call SndDriverCall
        test esi, esi
        jg short loc_98FA5
        mov eax, dword [byte ebx+0Ch]
        mov edx, ecx
        call sub_8FCAC
        xor esi, esi
loc_98FA5:
        mov dword [ebx], esi
loc_98FA7:
        inc ecx
        cmp ecx, byte 4
        jl short loc_98F54
        cmp dword [dword_D4F96], byte 0
        jl short loc_98FD7
        xor eax, eax
        mov al, byte [dword_D4F96]
        mov edx, 8
        call SndDriverCall
        test eax, eax
        je short loc_98FD7
        xor eax, eax
        mov al, byte [dword_D4F96]
        call sub_971DB
loc_98FD7:
        xor ecx, ecx
        jmp short loc_98FED
loc_98FDB:
        cmp ecx, dword [dword_D4F96]
        je short loc_98FEC
        xor eax, eax
        mov al, cl
        call sub_971DB
loc_98FEC:
        inc ecx
loc_98FED:
        cmp ecx, dword [sndhandlecount]
        jl short loc_98FDB
        call sub_99822
        cmp dword [dword_D4F8A], byte 0
        jne near loc_9909A
        mov ebx, byte_F1A1C
        xor ecx, ecx
loc_9900E:
        mov dl, byte [byte ebx+01h]
        test dl, dl
        je short loc_9906B
        test dl, 8
        je short loc_99064
        mov eax, dword [byte ebx+06h]
        mov dl, byte [byte eax+015h]
        mov dh, byte [byte_D4F5D]
        cmp dl, dh
        je short loc_99064
        mov byte [byte eax+015h], dh
        mov eax, dword [byte ebx+06h]
        mov dx, word [byte eax+0Eh]
        test dx, dx
        je short loc_99064
        movzx ebp, byte [byte eax+010h]
        mov esi, edx
        movsx edx, dx
        dec esi
        mov word [byte eax+0Eh], si
        mov eax, edx
        call abs_
        mov edx, ebp
        imul edx, eax
        mov esi, dword [byte ebx+06h]
        movsx edi, word [byte esi+0Ch]
        mov eax, edx
        sar edx, 1Fh
        idiv edi
        mov byte [byte esi+011h], al
loc_99064:
        mov eax, ebx
        call sub_990CB
loc_9906B:
        add ebx, byte 54h
        inc ecx
        cmp ecx, byte 18h
        jl short loc_9900E
        mov ebx, dword_F189C
        xor ecx, ecx
loc_9907B:
        cmp byte [byte ebx+05h], 0FFh
        jne short loc_99091
        mov esi, dword [byte ebx+08h]
        dec esi
        mov dword [byte ebx+08h], esi
        jne short loc_99091
        mov eax, ebx
        call sub_99620
loc_99091:
        add ebx, byte 0Ch
        inc ecx
        cmp ecx, byte 20h
        jl short loc_9907B
loc_9909A:
        cmp dword [dword_D4F96], byte 0
        jl short loc_990C4
        xor eax, eax
        mov al, byte [dword_D4F96]
        mov edx, 8
        call SndDriverCall
        test eax, eax
        je short loc_990C4
        xor eax, eax
        mov al, byte [dword_D4F96]
        call sub_971DB
loc_990C4:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_990CB:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        cmp dword [byte eax+0Ah], byte 0
        je near loc_9951A
        mov edi, unk_F21FC
        mov ebx, dword [dword_D4F9A]
        add edi, ebx
        lea ecx, [byte ebx+04h]
        mov dword [dword_D4F9A], ecx
        mov byte [edi], 80h
        test byte [byte eax+01h], 8
        je near loc_991C1
        mov eax, dword [byte esi+06h]
        cmp word [byte eax+0Eh], byte 0
        jne short loc_99165
        mov edx, dword_F189C
        xor ebx, ebx
        jmp short loc_9912F
loc_99116:
        mov eax, dword [edx]
        cmp eax, dword [byte esi+02h]
        jne short loc_9912B
        mov al, byte [byte edx+05h]
        cmp al, byte [esi]
        jne short loc_9912B
        mov eax, edx
        call sub_99620
loc_9912B:
        add edx, byte 0Ch
        inc ebx
loc_9912F:
        cmp bx, byte 20h
        jl short loc_99116
        mov al, byte [byte esi+050h]
        or al, 0B0h
        mov byte [edi], al
        mov byte [byte edi+01h], 7Bh
        mov byte [byte edi+02h], 0
        xor eax, eax
        mov al, byte [byte esi+051h]
        mov ebx, edi
        mov edx, 3
        call sub_997B7
        mov dword [byte esi+0Ah], 0
        mov byte [byte esi+01h], 0
        jmp near loc_99513
loc_99165:
        movsx edx, word [byte eax+0Ch]
        movsx eax, word [byte eax+0Eh]
        call abs_
        cmp eax, edx
        jne short loc_99185
        mov eax, dword [byte esi+06h]
        mov dl, byte [byte eax+010h]
        mov byte [byte eax+011h], dl
        and byte [byte esi+01h], 0F7h
        jmp short loc_991C1
loc_99185:
        mov eax, dword [byte esi+06h]
        mov bx, word [byte eax+0Eh]
        test bx, bx
        je short loc_991C1
        movsx edx, word [byte eax+0Ch]
        movsx eax, bx
        call abs_
        cmp eax, edx
        je short loc_991C1
        xor edx, edx
        mov dl, byte [byte esi+050h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        xor ebx, ebx
        mov bl, byte [dword eax+byte_F234D]
        mov edx, 7
        mov eax, esi
        call sub_99522
loc_991C1:
        add word [byte esi+04Ah], 80h
loc_991C7:
        mov ax, word [byte esi+04Ah]
        cmp ax, word [byte esi+04Ch]
        jl near loc_99513
        cmp dword [byte esi+0Ah], byte 0
        je near loc_99513
        mov edx, dword_F189C
        xor ebx, ebx
        jmp short loc_99203
loc_991E8:
        mov al, byte [byte edx+05h]
        cmp al, byte [esi]
        jne short loc_991FF
        mov ebp, dword [byte edx+08h]
        dec ebp
        mov dword [byte edx+08h], ebp
        jne short loc_991FF
        mov eax, edx
        call sub_99620
loc_991FF:
        add edx, byte 0Ch
        inc ebx
loc_99203:
        cmp bx, byte 20h
        jl short loc_991E8
        mov edx, dword [byte esi+0Eh]
        test edx, edx
        je short loc_9921B
        lea ecx, [byte edx-01h]
        mov dword [byte esi+0Eh], ecx
        jmp near loc_99506
loc_9921B:
        cmp dword [byte esi+0Ah], byte 0
        je near loc_99506
loc_99225:
        cmp dword [byte esi+0Eh], byte 0
        jne near loc_99503
        mov ebx, dword [byte esi+0Ah]
        test ebx, ebx
        je near loc_99503
        mov edx, ebx
        mov eax, unk_F1884
        call sub_99925
        xor eax, eax
        mov al, byte [byte_F188E]
        mov ebp, dword [byte esi+0Ah]
        add ebp, eax
        mov dword [byte esi+0Ah], ebp
        mov al, byte [byte_F188C]
        cmp al, 0D9h
        jb near loc_99449
        mov dl, byte [byte_F188D]
        cmp al, 0E2h
        jb short loc_992A9
        jbe near loc_99351
        cmp al, 0E5h
        jb short loc_9929C
        jbe near loc_99436
        cmp al, 0E8h
        jb short loc_9928F
        jbe near loc_993AC
        cmp al, 0EAh
        je short loc_992D6
        jmp near loc_994DF
loc_9928F:
        cmp al, 0E6h
        je near loc_9930E
        jmp near loc_994DF
loc_9929C:
        cmp al, 0E3h
        jbe near loc_9936D
        jmp near loc_993A4
loc_992A9:
        cmp al, 0DCh
        jb short loc_992C8
        jbe near loc_993F3
        cmp al, 0DDh
        jbe near loc_9933E
        cmp al, 0DFh
        je near loc_993CF
        jmp near loc_994DF
loc_992C8:
        cmp al, 0D9h
        jb near loc_994DF
        cmp al, 0DAh
        jbe short loc_992DE
        jmp short loc_99331
loc_992D6:
        mov byte [byte esi+04Eh], dl
        jmp near loc_994DF
loc_992DE:
        mov bh, byte [byte esi+031h]
        test bh, bh
        je short loc_992F8
        xor eax, eax
        mov al, bh
        mov eax, dword [byte esi+eax*4+032h]
        mov dword [byte esi+0Ah], eax
        dec byte [byte esi+031h]
        jmp near loc_994DF
loc_992F8:
        mov dword [byte esi+0Ah], 0
        mov dword [byte esi+02h], 0
        mov byte [byte esi+01h], bh
        jmp near loc_994DF
loc_9930E:
        mov cl, byte [byte esi+031h]
        inc cl
        mov byte [byte esi+031h], cl
        xor eax, eax
        mov al, cl
        mov edx, dword [byte esi+0Ah]
        mov dword [byte esi+eax*4+032h], edx
        mov eax, dword [dword_F1888]
        add eax, byte 4
loc_99329:
        mov dword [byte esi+0Ah], eax
        jmp near loc_994DF
loc_99331:
        mov byte [byte esi+031h], 0
        mov byte [byte esi+030h], 0
        mov eax, dword [byte esi+032h]
        jmp short loc_99329
loc_9933E:
        and edx, 0FFh
        mov eax, dword [byte esi+02h]
        call sub_9966E
        jmp near loc_994DF
loc_99351:
        xor eax, eax
        mov al, byte [byte esi+030h]
        mov dword [byte esi+eax*4+018h], ebp
        dec dl
        xor eax, eax
        mov al, byte [byte esi+030h]
        mov byte [byte esi+eax+012h], dl
        inc byte [byte esi+030h]
        jmp near loc_994DF
loc_9936D:
        mov ch, byte [byte esi+030h]
        test ch, ch
        je near loc_994DF
        xor eax, eax
        mov al, ch
        mov eax, dword [byte esi+eax*4+014h]
        mov dword [byte esi+0Ah], eax
        xor eax, eax
        mov al, byte [byte esi+030h]
        mov dl, byte [byte esi+eax+011h]
        mov dh, dl
        dec dh
        mov byte [byte esi+eax+011h], dh
        test dl, dl
        jne near loc_994DF
        dec byte [byte esi+030h]
        jmp near loc_994DF
loc_993A4:
        mov byte [byte esi+052h], dl
        jmp near loc_994DF
loc_993AC:
        xor eax, eax
        mov al, byte [byte_F188E]
        sub eax, byte 4
        xor edx, edx
        mov dx, ax
        xor eax, eax
        mov al, byte [byte esi+051h]
        mov ebx, byte_F1784
loc_993C5:
        call sub_9722E
        jmp near loc_994DF
loc_993CF:
        test byte [byte esi+01h], 8
        jne near loc_994DF
        xor ebx, ebx
        mov bl, byte [dword_F1888]
        and edx, 0FFh
        mov eax, esi
        call sub_99522
        jmp near loc_994DF
loc_993F3:
        mov byte [byte esi+04Fh], dl
        mov al, byte [byte esi+050h]
        or al, 0C0h
        mov byte [edi], al
        mov byte [byte edi+01h], dl
        xor eax, eax
        mov al, dl
        push eax
        call sub_8F0D7
        add esp, byte 4
        mov edx, eax
        test eax, eax
        je short loc_99428
        mov bl, byte [byte eax+0Fh]
        test bl, 80h
        je short loc_99424
        mov al, bl
        and al, 7Fh
        mov byte [byte esi+051h], al
        jmp short loc_99428
loc_99424:
        mov byte [byte esi+051h], 7Fh
loc_99428:
        xor eax, eax
        mov al, byte [byte esi+051h]
        mov ebx, edi
        mov edx, 2
        jmp short loc_993C5
loc_99436:
        movsx edx, word [dword_F1888]
        mov eax, esi
        call sub_996B0
        jmp near loc_994DF
loc_99449:
        cmp al, 80h
        jae short loc_99455
        mov al, byte [byte esi+052h]
        mov byte [byte_F188D], al
loc_99455:
        mov dl, byte [byte_F188C]
        and dl, 7Fh
        mov byte [byte_F188C], dl
        cmp byte [byte esi+050h], 9
        je short loc_9947A
        mov eax, dword [byte esi+06h]
        mov al, byte [byte eax+013h]
        mov bl, dl
        add bl, al
        mov byte [byte_F188C], bl
loc_9947A:
        cmp dword [dword_D4F92], byte 0
        je short loc_994DF
        mov al, byte [byte esi+051h]
        mov byte [esp], al
        cmp byte [byte esi+050h], 9
        jne short loc_994B0
        mov al, byte [byte_F188C]
        add al, 5Ch
        and eax, 0FFh
        push eax
        call sub_8F0D7
        add esp, byte 4
        test eax, eax
        je short loc_994B0
        mov al, byte [byte eax+0Fh]
        and al, 7Fh
        mov byte [esp], al
loc_994B0:
        mov edx, dword [byte esi+02h]
        push edx
        xor eax, eax
        mov al, byte [esi]
        push eax
        xor eax, eax
        mov al, byte [byte esp+08h]
        push eax
        xor ecx, ecx
        mov cl, byte [byte esi+050h]
        mov ebx, dword [dword_F1888]
        xor edx, edx
        mov dl, byte [byte_F188D]
        xor eax, eax
        mov al, byte [byte_F188C]
        call sub_99700
loc_994DF:
        mov ebx, dword [byte esi+0Ah]
        test ebx, ebx
        je near loc_99225
        mov edx, ebx
        mov eax, dword_F1890
        call sub_99925
        mov eax, dword [dword_F1890]
        mov dword [byte esi+0Eh], eax
        jmp near loc_99225
loc_99503:
        dec dword [byte esi+0Eh]
loc_99506:
        mov ax, word [byte esi+04Ch]
        sub word [byte esi+04Ah], ax
        jmp near loc_991C7
loc_99513:
        sub dword [dword_D4F9A], byte 4
loc_9951A:
        add esp, byte 4
        jmp near loc_990C4
sub_99522:
        push ecx
        push esi
        push edi
        push ebp
        mov ecx, eax
        mov esi, unk_F21FC
        mov edi, dword [dword_D4F9A]
        add esi, edi
        lea ebp, [byte edi+04h]
        mov dword [dword_D4F9A], ebp
        mov al, byte [byte eax+050h]
        or al, 0B0h
        mov byte [esi], al
        mov byte [byte esi+01h], dl
        cmp dl, 7
        jb near loc_99600
        jbe short loc_9955D
        cmp dl, 0Ah
        je short loc_99594
        jmp near loc_99600
loc_9955D:
        xor edx, edx
        mov dl, byte [byte ecx+050h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        mov byte [dword eax+byte_F234D], bl
        mov eax, dword [byte ecx+06h]
        xor edx, edx
        mov dl, byte [byte eax+011h]
        xor eax, eax
        mov al, bl
        imul edx, eax
        mov ebx, 7Fh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov bl, al
        cmp al, 7Fh
        jbe short loc_99600
        mov bl, 7Fh
        jmp short loc_99600
loc_99594:
        xor edx, edx
        mov dl, byte [byte ecx+050h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        mov byte [dword eax+byte_F234E], bl
        mov eax, dword [byte ecx+06h]
        mov dl, byte [byte eax+012h]
        cmp dl, 3Fh
        jbe short loc_995DB
        mov al, dl
        and eax, 0FFh
        and ebx, 0FFh
        mov edx, 7Fh
        sub edx, ebx
        sub eax, byte 3Fh
        imul edx, eax
        mov edi, 3Fh
        mov eax, edx
        sar edx, 1Fh
        idiv edi
        add ebx, eax
        jmp short loc_99600
loc_995DB:
        xor edx, edx
        mov dl, byte [byte eax+012h]
        mov eax, 3Fh
        sub eax, edx
        mov edx, eax
        and ebx, 0FFh
        imul edx, ebx
        mov edi, 3Fh
        mov eax, edx
        sar edx, 1Fh
        idiv edi
        sub ebx, eax
loc_99600:
        mov byte [byte esi+02h], bl
        xor eax, eax
        mov al, byte [byte ecx+051h]
        mov ebx, esi
        mov edx, 3
        call sub_9722E
        sub dword [dword_D4F9A], byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
sub_99620:
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, eax
        mov ebx, unk_F21FC
        mov edx, dword [dword_D4F9A]
        add ebx, edx
        lea esi, [byte edx+04h]
        mov dword [dword_D4F9A], esi
        mov al, byte [byte eax+06h]
        or al, 80h
        mov byte [ebx], al
        mov al, byte [byte ecx+04h]
        mov byte [byte ebx+01h], al
        mov byte [byte ebx+02h], 0
        xor eax, eax
        mov al, byte [byte ecx+07h]
        mov edx, 3
        call sub_9722E
        mov dword [ecx], 0
        sub dword [dword_D4F9A], byte 4
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_9966E:
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov edi, eax
        mov byte [esp], dl
        mov ebx, byte_F1A1C
        xor ecx, ecx
        movzx esi, byte [esp]
        jmp short loc_996A0
loc_99687:
        cmp edi, dword [byte ebx+02h]
        jne short loc_9969C
        mov eax, 7D00h
        mov edx, eax
        sar edx, 1Fh
        idiv esi
        mov word [byte ebx+04Ch], ax
loc_9969C:
        add ebx, byte 54h
        inc ecx
loc_996A0:
        cmp cx, byte 18h
        jl short loc_99687
        xor eax, eax
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
sub_996B0:
        push ebx
        push ecx
        push esi
        mov ecx, edx
        mov ebx, unk_F21FC
        mov edx, dword [dword_D4F9A]
        add ebx, edx
        lea esi, [byte edx+04h]
        mov dword [dword_D4F9A], esi
        mov dl, byte [byte eax+050h]
        or dl, 0E0h
        mov byte [ebx], dl
        mov byte [byte ebx+01h], 0
        movsx edx, cx
        sar edx, 8
        and edx, byte 7Fh
        mov byte [byte ebx+02h], dl
        mov al, byte [byte eax+051h]
        and eax, 0FFh
        mov edx, 3
        call sub_9722E
        sub dword [dword_D4F9A], byte 4
        pop esi
        pop ecx
        pop ebx
        ret
sub_99700:
        push esi
        push edi
        sub esp, byte 8
        mov byte [esp], al
        mov byte [byte esp+04h], dl
        mov esi, ebx
        mov dl, cl
        mov ebx, unk_F21FC
        add ebx, dword [dword_D4F9A]
        mov eax, dword_F189C
        xor ecx, ecx
        add dword [dword_D4F9A], byte 4
loc_99729:
        cmp dword [eax], byte 0
        jne short loc_99798
        mov edi, dword [byte esp+01Ch]
        mov dword [eax], edi
        mov dh, byte [esp]
        mov byte [byte eax+04h], dh
        mov dh, byte [byte esp+018h]
        mov byte [byte eax+05h], dh
        mov byte [byte eax+06h], dl
        mov dh, byte [byte esp+014h]
        mov byte [byte eax+07h], dh
        test esi, esi
        jbe short loc_99754
        mov dword [byte eax+08h], esi
        jmp short loc_9975B
loc_99754:
        mov dword [byte eax+08h], 1
loc_9975B:
        or dl, 90h
        mov byte [ebx], dl
        mov al, byte [esp]
        mov byte [byte ebx+01h], al
        mov al, byte [byte esp+04h]
        mov byte [byte ebx+02h], al
        cmp byte [byte esp+018h], 0FFh
        je short loc_99786
        xor eax, eax
        mov al, byte [byte esp+014h]
        mov edx, 3
        call sub_9722E
        jmp short loc_997A6
loc_99786:
        xor eax, eax
        mov al, byte [byte esp+014h]
        mov edx, 3
        call sub_997B7
        jmp short loc_997A6
loc_99798:
        add eax, byte 0Ch
        inc ecx
        cmp ecx, byte 20h
        jl short loc_99729
        mov ecx, 0FFFFFFFFh
loc_997A6:
        sub dword [dword_D4F9A], byte 4
        mov eax, ecx
        add esp, byte 8
        pop edi
        pop esi
        ret 0Ch
sub_997B7:
        push ecx
        push esi
        mov cl, al
        cmp byte [byte_D4F5C], 0
        jne short loc_9981F
        movsx eax, dx
        mov esi, dword [dword_D4F58]
        add eax, esi
        cmp eax, 80h
        jge short loc_9981F
        mov byte [dword esi+byte_F1704], cl
        inc word [word_D4F88]
        inc byte [byte_D4F5C]
        lea eax, [byte esi+01h]
        mov dword [dword_D4F58], eax
loc_997F1:
        test dx, dx
        je short loc_99812
        mov esi, ebx
        mov eax, dword [dword_D4F58]
        inc ebx
        lea ecx, [byte eax+01h]
        mov dword [dword_D4F58], ecx
        mov cl, byte [esi]
        mov byte [dword eax+byte_F1704], cl
        dec edx
        jmp short loc_997F1
loc_99812:
        dec byte [byte_D4F5C]
        dec word [word_D4F88]
loc_9981F:
        pop esi
        pop ecx
        ret
sub_99822:
        push ebx
        push ecx
        push edx
        push esi
        cmp dword [dword_D4F58], byte 0
        je short loc_9989B
        mov ah, byte [byte_D4F5C]
        test ah, ah
        jne short loc_9989B
        xor ecx, ecx
        mov dl, ah
        inc dl
        mov byte [byte_D4F5C], dl
loc_99845:
        mov esi, 3
        movsx eax, cx
        mov al, byte [dword eax+byte_F1705]
        and al, 0F0h
        cmp al, 0C0h
        jne short loc_9985E
        mov esi, 2
loc_9985E:
        movsx eax, cx
        lea ebx, [byte eax+01h]
        add ebx, byte_F1704
        xor edx, edx
        mov dx, si
        mov al, byte [dword eax+byte_F1704]
        and eax, 0FFh
        call sub_9722E
        inc esi
        add ecx, esi
        movsx eax, cx
        cmp eax, dword [dword_D4F58]
        jl short loc_99845
        xor ecx, ecx
        mov dword [dword_D4F58], ecx
        dec byte [byte_D4F5C]
loc_9989B:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_998A0:
        push ecx
        push esi
        mov ah, bl
        mov ebx, unk_F21FC
        mov ecx, dword [dword_D4F9A]
        add ebx, ecx
        lea esi, [byte ecx+04h]
        mov dword [dword_D4F9A], esi
        or dl, 0C0h
        mov byte [ebx], dl
        mov byte [byte ebx+01h], ah
        and eax, 0FFh
        mov edx, 2
        call sub_9722E
        sub dword [dword_D4F9A], byte 4
        pop esi
        pop ecx
        ret
        db 08Bh,0C0h
jpt_998DD:
        dd loc_999CF
        dd loc_999CF
        dd loc_999CF
        dd loc_999A5
        dd loc_999A5
        dd loc_999A5
        dd loc_999AC
        dd loc_999A5
        dd loc_999A5
        dd loc_999A5
        dd loc_999CF
        dd loc_999A5
        dd loc_999BD
        dd loc_99991
        dd loc_99988
        dd loc_99972
        dd loc_999A5
        dd loc_999A5
sub_99925:
        push ebx
        push ecx
        push esi
        sub esp, byte 4
        mov ebx, eax
        mov dword [esp], edx
        mov dword [eax], 0
loc_99936:
        mov al, byte [edx]
        and al, 7Fh
        and eax, 0FFh
        mov esi, dword [ebx]
        shl esi, 7
        add esi, eax
        mov dword [ebx], esi
        mov eax, edx
        inc edx
        test byte [eax], 80h
        jne short loc_99936
        mov al, byte [edx]
        mov byte [byte ebx+08h], al
        mov ch, al
        inc edx
        sub al, 0D9h
        cmp al, 11h
        ja near loc_999CF
        and eax, 0FFh
        lea esi, [byte edx+01h]
        jmp dword [nosplit cs:eax*4+jpt_998DD]
loc_99972:
        xor eax, eax
        jmp short loc_99981
loc_99976:
        mov cl, byte [byte edx+eax+01h]
        mov byte [dword eax+byte_F1784], cl
        inc eax
loc_99981:
        movzx esi, byte [edx]
        cmp eax, esi
        jl short loc_99976
loc_99988:
        xor eax, eax
        mov al, byte [edx]
        add edx, eax
loc_9998E:
        inc edx
        jmp short loc_999CF
loc_99991:
        mov al, byte [edx]
        mov byte [byte ebx+09h], al
        mov eax, esi
        call sub_99A0B
        mov dword [byte ebx+04h], eax
        lea edx, [byte esi+04h]
        jmp short loc_999CF
loc_999A5:
        mov al, byte [edx]
        mov byte [byte ebx+09h], al
        jmp short loc_9998E
loc_999AC:
        mov al, byte [edx]
        mov byte [byte ebx+09h], al
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte ebx+04h], eax
        lea edx, [byte esi+01h]
        jmp short loc_999CF
loc_999BD:
        mov eax, edx
        call sub_99A0E
        and eax, 0FFFFh
        mov dword [byte ebx+04h], eax
        add edx, byte 2
loc_999CF:
        cmp ch, 0D9h
        jae short loc_999FC
        mov al, byte [edx]
        mov byte [byte ebx+09h], al
        mov dword [byte ebx+04h], 0
        inc edx
loc_999E1:
        mov eax, dword [byte ebx+04h]
        shl eax, 7
        mov cl, byte [edx]
        and cl, 7Fh
        movzx esi, cl
        add eax, esi
        mov dword [byte ebx+04h], eax
        mov eax, edx
        inc edx
        test byte [eax], 80h
        jne short loc_999E1
loc_999FC:
        mov al, byte [esp]
        sub dl, al
        mov byte [byte ebx+0Ah], dl
        add esp, byte 4
        pop esi
        pop ecx
        pop ebx
        ret
sub_99A0B:
        mov eax, dword [eax]
        ret
sub_99A0E:
        mov ax, word [eax]
        ret
