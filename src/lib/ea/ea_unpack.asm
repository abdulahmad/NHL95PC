; RefPack unpack.
bits 32
%include "hockey.inc"
section s_97300 progbits alloc exec nowrite align=1
extern __STOSB, str_Copyright, str_UnpackINVALIDPACKCODE, dword_EDEE0, dword_EDEE4, dword_EDEE8, dword_EDEEC, dword_EDEF0
extern dword_EDEF4, dword_EDEF8, FatalError, off_D3088, off_D308C, strncmp_, sub_B3ABC
global sub_97300, loc_97329, sub_97334, loc_97338, loc_9734A, sub_97350, loc_973BC, loc_973D9
global loc_97406, loc_97429, loc_97462, loc_97481, loc_974AF, loc_974B8, loc_974C3, loc_974CE
global loc_974D9, loc_974E4, loc_974EF, loc_974FA, loc_97505, loc_97510, loc_9751B, loc_9752F
global loc_97542, loc_97562, loc_9756D, loc_97578, loc_97583, loc_9758E, loc_97599, loc_975A4
global loc_975B8, loc_975CB, loc_975E3, loc_975EE, loc_97621, loc_97623, sub_9762C, loc_97677
global loc_97679, sub_9767C, loc_976B7, loc_976D7, loc_976EE, loc_97703, sub_97714, loc_97720
global sub_97740, loc_977A3, loc_97803, loc_97840, loc_9787D, loc_97885, loc_97893, loc_97897
global loc_978A6, loc_978B0, loc_978D3, loc_978E4, loc_97911, loc_97923, loc_9793A, loc_97963
global loc_97995, loc_979AE, loc_979CD, loc_979E6, sub_979F8, loc_979FA, loc_97A26, sub_97A38
global loc_97A9A, loc_97AD1, loc_97AF6, loc_97B2A, loc_97B30, loc_97B56, loc_97B84, loc_97B9C
global sub_97BB8, loc_97BE4, loc_97BEF, loc_97C10, loc_97C24, sub_97C2C, loc_97C58, loc_97C8A
global loc_97C96, loc_97CA2, loc_97CAD, loc_97CB8, loc_97CBD, loc_97CBF, loc_97CCF, loc_97CD3
global sub_97CE0, loc_97D13, loc_97D40, loc_97D5A, loc_97D63, loc_97D87, loc_97D92, loc_97DAA
global loc_97DB3, loc_97DDA, loc_97DE9, loc_97E10, loc_97E19, loc_97E60, loc_97E6F, loc_97E7D
global loc_97E9E, loc_97EA4, loc_97EAD, unpack, loc_97EE1, loc_97F3C, loc_97F49, loc_97F64
global loc_97F7D, loc_97F8D, loc_97F9F, loc_97FB1, loc_97FBE, loc_97FCB, loc_97FE1, loc_97FEF
global loc_98009, loc_9801E, sub_98028, sub_98044
sub_97300:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov esi, eax
        mov ebx, 9
        mov edx, str_Copyright
        call strncmp_
        test eax, eax
        jne short loc_97329
        mov edi, esi
        sub ecx, ecx
        dec ecx
        xor eax, eax
        repne scasb
        not ecx
        dec ecx
        inc ecx
        add esi, ecx
loc_97329:
        mov eax, esi
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
sub_97334:
        push ebx
        push ecx
        xor ebx, ebx
loc_97338:
        dec edx
        cmp edx, byte 0FFFFFFFFh
        je short loc_9734A
        xor ecx, ecx
        mov cl, byte [eax]
        shl ebx, 8
        inc eax
        add ebx, ecx
        jmp short loc_97338
loc_9734A:
        mov eax, ebx
        pop ecx
        pop ebx
        ret
        db 090h
sub_97350:
        push ebx
        push ecx
        push edx
        mov ebx, eax
        call sub_97300
        mov edx, eax
        mov ebx, eax
        xor ecx, ecx
        mov cl, byte [byte eax+01h]
        cmp ecx, 0FBh
        jne near loc_975EE
        xor eax, eax
        mov al, byte [edx]
        and eax, 0FEh
        cmp eax, byte 44h
        jb near loc_97429
        jbe near loc_9758E
        cmp eax, byte 72h
        jb short loc_973D9
        jbe near loc_97505
        cmp eax, byte 78h
        jb short loc_973BC
        jbe near loc_974B8
        cmp eax, byte 7Ah
        jb near loc_975E3
        jbe near loc_9751B
        cmp eax, 0C0h
        je near loc_97562
        jmp near loc_975E3
loc_973BC:
        cmp eax, byte 74h
        jb near loc_975E3
        jbe near loc_97510
        cmp eax, byte 76h
        je near loc_975A4
        jmp near loc_975E3
loc_973D9:
        cmp eax, byte 6Ah
        jb short loc_97406
        jbe near loc_97562
        cmp eax, byte 6Eh
        jb near loc_975E3
        jbe near loc_974EF
        cmp eax, byte 70h
        je near loc_974FA
        mov edx, 12h
        jmp near loc_97623
loc_97406:
        cmp eax, byte 46h
        jb near loc_975E3
        jbe near loc_974E4
        cmp eax, byte 66h
        je near loc_97599
        mov edx, 12h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_97429:
        cmp eax, byte 2Ch
        jb short loc_97481
        jbe near loc_97583
        cmp eax, byte 32h
        jb short loc_97462
        jbe near loc_974CE
        cmp eax, byte 34h
        jb near loc_975E3
        jbe near loc_974D9
        cmp eax, byte 42h
        je near loc_9758E
        mov edx, 12h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_97462:
        cmp eax, byte 2Eh
        jb near loc_975E3
        jbe near loc_97578
        cmp eax, byte 30h
        je short loc_974C3
        mov edx, 12h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_97481:
        cmp eax, byte 26h
        jb short loc_974AF
        jbe near loc_9756D
        cmp eax, byte 28h
        jb near loc_975E3
        jbe near loc_97578
        cmp eax, byte 2Ah
        je near loc_9756D
        mov edx, 12h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_974AF:
        cmp eax, byte 10h
        jne near loc_975E3
loc_974B8:
        mov edx, 0Ch
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_974C3:
        mov edx, 7
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_974CE:
        mov edx, 9
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_974D9:
        mov edx, 0Ah
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_974E4:
        mov edx, 5
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_974EF:
        mov edx, 1
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_974FA:
        mov edx, 11h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_97505:
        mov edx, 0Bh
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_97510:
        mov edx, 10h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_9751B:
        mov edx, 2
        mov ecx, 5
        test ah, 1
        je short loc_9752F
        mov ecx, 8
loc_9752F:
        lea eax, [ebx+ecx]
        cmp byte [eax], 1
        jne short loc_97542
        cmp byte [byte eax+01h], 1
        jne short loc_97542
        mov edx, 3
loc_97542:
        add ebx, ecx
        cmp byte [ebx], 2
        jne near loc_97623
        cmp byte [byte ebx+01h], 1
        jne near loc_97623
        mov edx, 4
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_97562:
        mov edx, 1Fh
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_9756D:
        mov edx, 18h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_97578:
        mov edx, 1Ah
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_97583:
        mov edx, 19h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_9758E:
        mov edx, 17h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_97599:
        mov edx, 1Bh
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_975A4:
        mov edx, 14h
        mov ecx, 5
        test ah, 1
        je short loc_975B8
        mov ecx, 8
loc_975B8:
        lea eax, [ebx+ecx]
        cmp byte [eax], 1
        jne short loc_975CB
        cmp byte [byte eax+01h], 1
        jne short loc_975CB
        mov edx, 15h
loc_975CB:
        add ebx, ecx
        cmp byte [ebx], 2
        jne short loc_97623
        cmp byte [byte ebx+01h], 1
        jne short loc_97623
        mov edx, 16h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_975E3:
        mov edx, 12h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_975EE:
        xor eax, eax
        mov al, byte [edx]
        shl eax, 8
        add eax, ecx
        xor ebx, edx
        mov bl, byte [byte edx+02h]
        shl eax, 8
        add eax, ebx
        mov dl, byte [byte edx+03h]
        and edx, 0FFh
        shl eax, 8
        add eax, edx
        cmp eax, 3F3h
        jne short loc_97621
        mov edx, 21h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
loc_97621:
        xor edx, edx
loc_97623:
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
sub_9762C:
        push esi
        push edi
        mov edi, dword [byte esp+0Ch]
        mov esi, dword [byte esp+010h]
        cmp esi, byte 2
        jle short loc_97677
        push esi
        push edi
        call dword [off_D3088]
        add esp, byte 8
        test eax, eax
        jne short loc_97679
        mov eax, edi
        call sub_97300
        mov edx, eax
        sub eax, edi
        sub esi, eax
        mov eax, edx
        call sub_97350
        test eax, eax
        jle short loc_97677
        cmp eax, byte 1Eh
        jg short loc_97677
        lea eax, [byte edx+02h]
        mov edx, 3
        call sub_97334
        pop edi
        pop esi
        ret
loc_97677:
        mov eax, esi
loc_97679:
        pop edi
        pop esi
        ret
sub_9767C:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, dword [dword_EDEE0]
        mov edi, dword [dword_EDEE4]
        mov ebp, dword [dword_EDEF0]
        cmp eax, byte 10h
        jle short loc_976B7
        sub eax, byte 10h
        call sub_9767C
        mov edx, eax
        shl edx, 10h
        mov eax, 10h
        call sub_9767C
        or eax, edx
        jmp short loc_97703
loc_976B7:
        mov ecx, 20h
        sub ecx, eax
        mov edx, edi
        shr edx, cl
        mov dword [esp], edx
        mov cl, al
        shl edi, cl
        sub esi, eax
        cmp esi, byte 10h
        jge short loc_976EE
        mov eax, esi
        neg eax
        add eax, byte 18h
loc_976D7:
        xor ebx, ebx
        mov bl, byte [byte ebp+00h]
        inc ebp
        mov cl, al
        shl ebx, cl
        or edi, ebx
        sub eax, byte 8
        add esi, byte 8
        cmp eax, byte 8
        jg short loc_976D7
loc_976EE:
        mov eax, dword [esp]
        mov dword [dword_EDEE0], esi
        mov dword [dword_EDEE4], edi
        mov dword [dword_EDEF0], ebp
loc_97703:
        mov esi, dword [dword_EDEE0]
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
sub_97714:
        push ebx
        push edx
        mov ebx, 2
        mov edx, 1
loc_97720:
        add ebx, ebx
        inc edx
        mov eax, 1
        call sub_9767C
        test eax, eax
        je short loc_97720
        mov eax, edx
        call sub_9767C
        add eax, ebx
        sub eax, byte 4
        pop edx
        pop ebx
        ret
sub_97740:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 2D8h
        mov dword [dword esp+02C8h], edx
        mov dword [dword_EDEF0], eax
        mov dword [dword_EDEE8], edx
        xor edx, edx
        mov dword [dword esp+02C4h], edx
        test eax, eax
        je near loc_979E6
        mov dl, byte [eax]
        mov dword [dword esp+02CCh], edx
        inc eax
        mov dword [dword_EDEF0], eax
        xor ecx, ecx
        mov cl, byte [eax]
        shl edx, 8
        inc eax
        mov dword [dword_EDEF0], eax
        add edx, ecx
        mov dword [dword esp+02CCh], edx
        test byte [dword esp+02CDh], 1
        je short loc_977A3
        add dword [dword_EDEF0], byte 3
loc_977A3:
        and byte [dword esp+02CDh], 0FEh
        xor esi, esi
        mov dword [dword_EDEE0], esi
        mov dword [dword_EDEE4], esi
        xor eax, eax
        call sub_9767C
        mov eax, 18h
        call sub_9767C
        mov dword [dword esp+02C4h], eax
        test ebx, ebx
        je near loc_979E6
        mov eax, 8
        call sub_9767C
        mov byte [dword esp+02D4h], al
        mov edi, 1
        xor edx, edx
        mov dword [dword esp+02C0h], 0Fh
        mov ebx, 4
        xor ebp, ebp
loc_97803:
        add edx, edx
        mov eax, edx
        sub eax, esi
        mov dword [dword esp+ebx+0240h], eax
        call sub_97714
        mov dword [dword esp+02D0h], eax
        mov dword [dword esp+ebx+0200h], eax
        add esi, eax
        add edx, eax
        mov ecx, ebp
        test eax, eax
        je short loc_97840
        mov cl, byte [dword esp+02C0h]
        mov eax, edx
        shl eax, cl
        mov ecx, eax
        and ecx, 0FFFFh
loc_97840:
        mov dword [dword esp+ebx+0280h], ecx
        dec dword [dword esp+02C0h]
        add ebx, byte 4
        inc edi
        cmp ebp, dword [dword esp+02D0h]
        je short loc_97803
        test ecx, ecx
        jne short loc_97803
        dec edi
        mov ecx, 100h
        xor edx, edx
        mov eax, esp
        call __STOSB
        mov edx, 0FFFFFFFFh
        xor ebx, ebx
        test esi, esi
        jle short loc_978A6
        xor ebp, ebp
        mov cl, 1
loc_9787D:
        call sub_97714
        inc eax
        je short loc_97897
loc_97885:
        inc edx
        and edx, 0FFh
        cmp byte [esp+edx], 0
        jne short loc_97893
        dec eax
loc_97893:
        test eax, eax
        jne short loc_97885
loc_97897:
        mov byte [esp+edx], cl
        mov byte [dword esp+ebx+0100h], dl
        inc ebx
        cmp ebx, esi
        jl short loc_9787D
loc_978A6:
        mov esi, 4
        mov ebp, 1
loc_978B0:
        mov ecx, dword [dword_EDEE4]
        shr ecx, 10h
        and ecx, 0FFFFh
        mov edx, ebp
        mov eax, esi
        lea ebx, [nosplit edi*4+00h]
        cmp ecx, dword [dword esp+0284h]
        jb short loc_978E4
loc_978D3:
        cmp eax, ebx
        jge short loc_978E4
        add eax, byte 4
        inc edx
        cmp ecx, dword [dword esp+eax+0280h]
        jae short loc_978D3
loc_978E4:
        mov eax, edx
        call sub_9767C
        sub eax, dword [dword esp+edx*4+0240h]
        mov dl, byte [dword esp+eax+0100h]
        cmp dl, byte [dword esp+02D4h]
        je short loc_97911
        mov eax, dword [dword_EDEE8]
        mov byte [eax], dl
        inc eax
        mov dword [dword_EDEE8], eax
        jmp short loc_978B0
loc_97911:
        call sub_97714
        test eax, eax
        je short loc_9793A
        mov ebx, dword [dword_EDEE8]
        mov bl, byte [byte ebx-01h]
loc_97923:
        dec eax
        cmp eax, byte 0FFFFFFFFh
        je short loc_978B0
        mov edx, dword [dword_EDEE8]
        mov byte [edx], bl
        inc edx
        mov dword [dword_EDEE8], edx
        jmp short loc_97923
loc_9793A:
        mov eax, ebp
        call sub_9767C
        test eax, eax
        jne short loc_97963
        mov eax, 8
        call sub_9767C
        mov edx, dword [dword_EDEE8]
        mov byte [edx], al
        inc edx
        mov dword [dword_EDEE8], edx
        jmp near loc_978B0
loc_97963:
        mov eax, dword [dword esp+02C8h]
        add eax, dword [dword esp+02C4h]
        mov esi, dword [dword esp+02CCh]
        cmp esi, 32FBh
        jne short loc_979AE
        xor ebx, ebx
        mov edx, dword [dword esp+02C8h]
        mov dword [dword_EDEE8], edx
        mov ecx, eax
        cmp eax, edx
        jbe short loc_979E6
loc_97995:
        mov eax, dword [dword_EDEE8]
        xor edx, edx
        mov dl, byte [eax]
        add ebx, edx
        mov byte [eax], bl
        inc eax
        mov dword [dword_EDEE8], eax
        cmp ecx, eax
        ja short loc_97995
        jmp short loc_979E6
loc_979AE:
        cmp esi, 34FBh
        jne short loc_979E6
        xor ebx, ebx
        xor edx, edx
        mov ecx, dword [dword esp+02C8h]
        mov dword [dword_EDEE8], ecx
        mov esi, eax
        cmp eax, ecx
        jbe short loc_979E6
loc_979CD:
        mov eax, dword [dword_EDEE8]
        xor ecx, ecx
        mov cl, byte [eax]
        add ebx, ecx
        add edx, ebx
        mov byte [eax], dl
        inc eax
        mov dword [dword_EDEE8], eax
        cmp esi, eax
        ja short loc_979CD
loc_979E6:
        mov eax, dword [dword esp+02C4h]
        add esp, 2D8h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
sub_979F8:
        push ebx
        push edx
loc_979FA:
        xor edx, edx
        mov dl, al
        mov ebx, dword [dword_EDEF8]
        cmp byte [edx+ebx], 0
        je short loc_97A26
        mov eax, dword [dword_EDEEC]
        mov al, byte [edx+eax]
        and eax, 0FFh
        call sub_979F8
        mov eax, dword [dword_EDEF4]
        mov al, byte [edx+eax]
        jmp short loc_979FA
loc_97A26:
        mov edx, dword [dword_EDEE8]
        mov byte [edx], al
        inc edx
        mov dword [dword_EDEE8], edx
        pop edx
        pop ebx
        ret
sub_97A38:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 304h
        mov ebx, eax
        mov dword [dword_EDEE8], edx
        xor edx, edx
        mov dword [dword esp+0300h], edx
        lea edx, [dword esp+0200h]
        mov dword [dword_EDEF8], edx
        lea edx, [dword esp+0100h]
        mov dword [dword_EDEEC], edx
        mov edx, esp
        mov dword [dword_EDEF4], edx
        test eax, eax
        je near loc_97B9C
        xor edx, edx
        mov dl, byte [eax]
        lea ebx, [byte eax+01h]
        xor eax, eax
        mov al, byte [ebx]
        shl edx, 8
        inc ebx
        add edx, eax
        cmp edx, 47FBh
        jne short loc_97A9A
        add ebx, byte 3
loc_97A9A:
        xor eax, eax
        mov al, byte [ebx]
        mov dword [dword esp+0300h], eax
        inc ebx
        xor edx, edx
        mov dl, byte [ebx]
        shl eax, 8
        inc ebx
        add eax, edx
        mov dword [dword esp+0300h], eax
        xor eax, eax
        mov al, byte [ebx]
        mov edx, dword [dword esp+0300h]
        shl edx, 8
        inc ebx
        add edx, eax
        mov dword [dword esp+0300h], edx
        xor edx, edx
loc_97AD1:
        mov eax, dword [dword_EDEF8]
        mov byte [edx+eax], 0
        inc edx
        cmp edx, 100h
        jl short loc_97AD1
        xor edx, edx
        mov dl, byte [ebx]
        inc ebx
        mov byte [edx+eax], 1
        movzx ebp, byte [ebx]
        xor eax, eax
        inc ebx
        test ebp, ebp
        jle short loc_97B2A
loc_97AF6:
        xor edx, edx
        mov dl, byte [ebx]
        lea esi, [byte ebx+01h]
        mov ecx, dword [dword_EDEEC]
        add ebx, byte 2
        lea edi, [ecx+edx]
        mov cl, byte [esi]
        mov byte [edi], cl
        mov esi, ebx
        mov edi, dword [dword_EDEF4]
        inc ebx
        mov cl, byte [esi]
        mov byte [edx+edi], cl
        mov ecx, dword [dword_EDEF8]
        mov byte [ecx+edx], 0FFh
        inc eax
        cmp eax, ebp
        jl short loc_97AF6
loc_97B2A:
        mov dword [dword_EDEF0], ebx
loc_97B30:
        mov ebx, dword [dword_EDEF0]
        xor edx, edx
        mov dl, byte [ebx]
        mov eax, dword [dword_EDEF8]
        inc ebx
        mov al, byte [edx+eax]
        test al, al
        jne short loc_97B56
        mov eax, dword [dword_EDEE8]
        mov byte [eax], dl
        inc eax
        mov dword [dword_EDEE8], eax
        jmp short loc_97B2A
loc_97B56:
        mov dword [dword_EDEF0], ebx
        jge short loc_97B84
        mov eax, dword [dword_EDEEC]
        mov al, byte [edx+eax]
        and eax, 0FFh
        call sub_979F8
        mov eax, dword [dword_EDEF4]
        mov al, byte [edx+eax]
        and eax, 0FFh
        call sub_979F8
        jmp short loc_97B30
loc_97B84:
        xor edx, edx
        mov dl, byte [ebx]
        inc ebx
        test edx, edx
        je short loc_97B9C
        mov eax, dword [dword_EDEE8]
        mov byte [eax], dl
        inc eax
        mov dword [dword_EDEE8], eax
        jmp short loc_97B2A
loc_97B9C:
        mov eax, dword [dword esp+0300h]
        mov dword [dword_EDEF0], ebx
        add esp, 304h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
sub_97BB8:
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, eax
        mov eax, edx
        xor edi, edi
        test ebx, ebx
        je short loc_97C24
        xor ecx, ecx
        mov cl, byte [ebx]
        lea edx, [byte ebx+01h]
        xor ebx, ebx
        mov bl, byte [edx]
        shl ecx, 8
        inc edx
        add ecx, ebx
        cmp ecx, 62FBh
        jne short loc_97BE4
        add edx, byte 3
        jmp short loc_97BEF
loc_97BE4:
        cmp ecx, 66FBh
        jne short loc_97BEF
        add edx, byte 4
loc_97BEF:
        movzx edi, byte [edx]
        inc edx
        xor ebx, ebx
        mov bl, byte [edx]
        shl edi, 8
        inc edx
        add edi, ebx
        xor ebx, ebx
        mov bl, byte [edx]
        shl edi, 8
        inc edx
        add edi, ebx
        lea esi, [eax+edi]
        xor ebx, ebx
        cmp eax, esi
        jae short loc_97C24
loc_97C10:
        xor ecx, ecx
        mov cl, byte [edx]
        inc edx
        add ebx, ecx
        and ebx, 0FFh
        mov byte [eax], bl
        inc eax
        cmp eax, esi
        jb short loc_97C10
loc_97C24:
        mov eax, edi
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
        db 090h
sub_97C2C:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        xor ebx, ebx
        mov dword [esp], ebx
        test eax, eax
        je near loc_97CD3
        mov bl, byte [eax]
        inc eax
        movzx esi, byte [eax]
        shl ebx, 8
        inc eax
        add ebx, esi
        cmp ebx, 7BFBh
        jne short loc_97C58
        add eax, byte 3
loc_97C58:
        xor ebx, ebx
        mov bl, byte [eax]
        mov dword [esp], ebx
        inc eax
        movzx esi, byte [eax]
        shl ebx, 8
        inc eax
        add ebx, esi
        mov dword [esp], ebx
        xor ebx, ebx
        mov bl, byte [eax]
        mov esi, dword [esp]
        shl esi, 8
        inc eax
        add esi, ebx
        mov dword [esp], esi
        movzx ebp, byte [eax]
        inc eax
        xor ebx, ebx
        mov bl, byte [eax]
        inc eax
        dec ebx
        mov dword [byte esp+04h], ebx
loc_97C8A:
        mov ebx, dword [byte esp+04h]
        movsx edi, byte [eax]
        inc eax
        test ebx, ebx
        je short loc_97CA2
loc_97C96:
        movzx esi, byte [eax]
        shl edi, 8
        inc eax
        add edi, esi
        dec ebx
        jne short loc_97C96
loc_97CA2:
        test edi, edi
        jge short loc_97CB8
        mov ebx, edi
        neg ebx
        imul ebx, ebp
loc_97CAD:
        mov cl, byte [eax]
        mov byte [edx], cl
        inc eax
        inc edx
        dec ebx
        je short loc_97CCF
        jmp short loc_97CAD
loc_97CB8:
        je short loc_97CCF
        lea esi, [byte edi+01h]
loc_97CBD:
        mov ebx, ebp
loc_97CBF:
        mov cl, byte [eax]
        mov byte [edx], cl
        inc eax
        inc edx
        dec ebx
        jne short loc_97CBF
        sub eax, ebp
        dec esi
        jne short loc_97CBD
        add eax, ebp
loc_97CCF:
        test edi, edi
        jne short loc_97C8A
loc_97CD3:
        mov eax, dword [esp]
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
        db 090h
sub_97CE0:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ecx, eax
        mov eax, edx
        mov esi, ebx
        xor edx, edx
        mov dword [esp], edx
        test ecx, ecx
        je near loc_97EAD
        xor ebx, ebx
        mov bl, byte [ecx]
        lea edx, [byte ecx+01h]
        xor ecx, ecx
        mov cl, byte [edx]
        shl ebx, 8
        inc edx
        add ebx, ecx
        test bh, 1
        je short loc_97D13
        add edx, byte 3
loc_97D13:
        xor ebx, ebx
        mov bl, byte [edx]
        mov dword [esp], ebx
        inc edx
        xor ecx, ecx
        mov cl, byte [edx]
        shl ebx, 8
        inc edx
        add ebx, ecx
        mov dword [esp], ebx
        xor ebx, ebx
        mov bl, byte [edx]
        mov ecx, dword [esp]
        shl ecx, 8
        inc edx
        add ecx, ebx
        mov dword [esp], ecx
        test esi, esi
        je near loc_97EAD
loc_97D40:
        movzx esi, byte [edx]
        inc edx
        mov ecx, esi
        and ecx, byte 3
        test si, 80h
        jne short loc_97D92
        movzx edi, byte [edx]
        mov ebx, ecx
        inc edx
        test ecx, ecx
        je short loc_97D63
loc_97D5A:
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        dec ebx
        jne short loc_97D5A
loc_97D63:
        mov ebx, esi
        and ebx, byte 60h
        shl ebx, 3
        add ebx, edi
        inc ebx
        mov ecx, eax
        sub ecx, ebx
        mov ebx, ecx
        and esi, byte 1Ch
        shr esi, 2
        inc esi
        mov cl, byte [ecx]
        mov byte [eax], cl
        inc ebx
        inc eax
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
loc_97D87:
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
        dec esi
        je short loc_97D40
        jmp short loc_97D87
loc_97D92:
        test si, 40h
        jne short loc_97DE9
        movzx edi, byte [edx]
        inc edx
        movzx ebp, byte [edx]
        mov ebx, edi
        shr ebx, 6
        inc edx
        test ebx, ebx
        je short loc_97DB3
loc_97DAA:
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        dec ebx
        jne short loc_97DAA
loc_97DB3:
        and edi, byte 3Fh
        shl edi, 8
        add edi, ebp
        lea ebx, [byte edi+01h]
        mov ecx, eax
        sub ecx, ebx
        mov ebx, ecx
        and esi, byte 3Fh
        inc esi
        mov cl, byte [ecx]
        mov byte [eax], cl
        inc ebx
        inc eax
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
loc_97DDA:
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
        dec esi
        je near loc_97D40
        jmp short loc_97DDA
loc_97DE9:
        test si, 20h
        jne near loc_97E6F
        xor ebx, ebx
        mov bl, byte [edx]
        mov dword [byte esp+08h], ebx
        inc edx
        xor ebx, ebx
        mov bl, byte [edx]
        mov dword [byte esp+04h], ebx
        inc edx
        movzx edi, byte [edx]
        mov ebx, ecx
        inc edx
        test ecx, ecx
        je short loc_97E19
loc_97E10:
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        dec ebx
        jne short loc_97E10
loc_97E19:
        mov ebx, esi
        and ebx, byte 10h
        shr ebx, 4
        shl ebx, 10h
        mov ecx, dword [byte esp+08h]
        shl ecx, 8
        add ebx, ecx
        add ebx, dword [byte esp+04h]
        inc ebx
        mov ecx, eax
        sub ecx, ebx
        mov ebx, ecx
        mov ecx, esi
        and ecx, byte 0Ch
        shr ecx, 2
        shl ecx, 8
        add ecx, edi
        lea esi, [byte ecx+01h]
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
loc_97E60:
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
        dec esi
        je near loc_97D40
        jmp short loc_97E60
loc_97E6F:
        cmp esi, 0FCh
        jae short loc_97E9E
        mov ebx, esi
        and ebx, byte 1Fh
        inc ebx
loc_97E7D:
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        dec ebx
        je near loc_97D40
        jmp short loc_97E7D
loc_97E9E:
        mov ebx, ecx
        test ecx, ecx
        je short loc_97EAD
loc_97EA4:
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        dec ebx
        jne short loc_97EA4
loc_97EAD:
        mov eax, dword [esp]
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
unpack:
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, dword [byte esp+014h]
        mov esi, dword [byte esp+018h]
        mov ebp, dword [byte esp+01Ch]
        push ebp
        push esi
        push edi
        call dword [off_D308C]
        add esp, byte 0Ch
        test eax, eax
        je short loc_97EE1
        mov edi, eax
        jmp near loc_9801E
loc_97EE1:
        push ebp
        push edi
        call sub_9762C
        add esp, byte 8
        mov dword [esp], eax
        mov eax, edi
        call sub_97300
        mov ecx, eax
        mov ebp, eax
        xor edi, edi
        cmp byte [byte eax+01h], 0FBh
        jne near loc_98009
        mov al, byte [ecx]
        and al, 0FEh
        cmp al, 60h
        jb short loc_97F64
        jbe near loc_97FBE
        cmp al, 6Ah
        jb short loc_97F49
        jbe near loc_97FCB
        cmp al, 72h
        jb short loc_97F3C
        jbe near loc_97FBE
        cmp al, 7Ah
        jb near loc_97FEF
        cmp al, 7Bh
        jbe near loc_97FE1
        jmp near loc_97FEF
loc_97F3C:
        cmp al, 6Eh
        je near loc_97FCB
        jmp near loc_97FEF
loc_97F49:
        cmp al, 62h
        jb near loc_97FEF
        jbe near loc_97FBE
        cmp al, 66h
        je near loc_97FBE
        jmp near loc_97FEF
loc_97F64:
        cmp al, 32h
        jb short loc_97F7D
        jbe short loc_97F9F
        cmp al, 34h
        jb near loc_97FEF
        jbe short loc_97F9F
        cmp al, 46h
        je short loc_97FB1
        jmp near loc_97FEF
loc_97F7D:
        cmp al, 10h
        jb near loc_97FEF
        jbe short loc_97F8D
        cmp al, 30h
        je short loc_97F9F
        jmp short loc_97FEF
loc_97F8D:
        mov ebx, 1
        mov edx, esi
        mov eax, ecx
        call sub_97CE0
        mov edi, eax
        jmp short loc_98009
loc_97F9F:
        mov ebx, 1
        mov edx, esi
        mov eax, ebp
        call sub_97740
        mov edi, eax
        jmp short loc_98009
loc_97FB1:
        mov edx, esi
        mov eax, ecx
        call sub_97A38
        mov edi, eax
        jmp short loc_98009
loc_97FBE:
        mov edx, esi
        mov eax, ebp
        call sub_97BB8
        mov edi, eax
        jmp short loc_98009
loc_97FCB:
        mov edx, dword [esp]
        push edx
        push esi
        lea eax, [byte ebp+05h]
        push eax
        call sub_B3ABC
        add esp, byte 0Ch
        mov edi, dword [esp]
        jmp short loc_98009
loc_97FE1:
        mov edx, esi
        mov eax, ecx
        call sub_97C2C
        mov dword [esp], eax
        jmp short loc_98009
loc_97FEF:
        cmp dword [byte esp+020h], byte 0
        je short loc_98009
        xor eax, eax
        mov al, byte [byte ebp+00h]
        push eax
        push str_UnpackINVALIDPACKCODE
        call FatalError
        add esp, byte 8
loc_98009:
        test edi, edi
        jne short loc_9801E
        mov ecx, dword [esp]
        push ecx
        push esi
        push ebp
        call sub_B3ABC
        add esp, byte 0Ch
        mov edi, dword [esp]
loc_9801E:
        mov eax, edi
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
sub_98028:
        push byte 1
        mov edx, dword [byte esp+010h]
        push edx
        mov ebx, dword [byte esp+010h]
        push ebx
        mov ecx, dword [byte esp+010h]
        push ecx
        call unpack
        add esp, byte 10h
        ret
        db 08Bh,0C0h
sub_98044:
        push byte 0
        mov edx, dword [byte esp+010h]
        push edx
        mov ebx, dword [byte esp+010h]
        push ebx
        mov ecx, dword [byte esp+010h]
        push ecx
        call unpack
        add esp, byte 10h
        ret
