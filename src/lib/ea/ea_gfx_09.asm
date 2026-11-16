; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_92890 progbits alloc exec nowrite align=1
extern byte_D42C0, byte_D42C1, byte_D42C2, byte_D42C3, byte_D42C4, cliprect_y0, cliprect_y1, ScreenWidth
extern dword_D30A8, dword_D42AC, dword_D42B0, dword_D42B4, dword_D42BC, dword_D42C8, dword_D42CC, dword_D42D0
extern dword_D42D4, dword_D42D8, dword_D42DC, dword_D42E0, fontcolor, off_D42A4, sub_8E9D4, PutBlock
extern sub_90EC0, SetClipWindow, sub_B5D80
global sub_92890, loc_92901, loc_92930, loc_92936, loc_92951, loc_92957, loc_9296F, loc_9297A
global loc_92993, loc_92995, loc_929B9, loc_929BB, loc_92A3D, loc_92A6A, loc_92A9A, loc_92ABC
global loc_92AC5, loc_92AD9, loc_92AED, loc_92B02, loc_92B17, loc_92B2C, loc_92B41, loc_92B56
global loc_92B6B, loc_92B80, loc_92B95, loc_92B9B, loc_92BBF, loc_92BE1, loc_92BE7, loc_92BF7
global loc_92C0D, loc_92C29, loc_92C3A, loc_92C3D, loc_92C56, loc_92C74, loc_92C7A, loc_92C86
global loc_92CA5, loc_92CAC, loc_92CAF, loc_92CB9, loc_92CC6, sub_92CD0, sub_92CF0
sub_92890:
        push esi
        push edi
        push ebp
        sub esp, byte 40h
        mov eax, dword [off_D42A4]
        mov dword [byte esp+02Ch], eax
        xor eax, eax
        mov al, byte [byte_D42C1]
        movzx esi, byte [byte_D42C0]
        sub eax, esi
        inc eax
        mov dword [byte esp+014h], eax
        xor eax, eax
        mov esi, dword [byte esp+02Ch]
        mov al, byte [byte esi+03h]
        sub eax, byte 30h
        mov dword [byte esp+010h], eax
        mov eax, dword [fontcolor]
        mov dword [byte esp+03Ch], eax
        mov eax, dword [dword_D42AC]
        mov dword [byte esp+0Ch], eax
        cmp dword [dword_D42BC], 464E544Dh
        sete al
        and eax, 0FFh
        mov dword [byte esp+04h], eax
        mov eax, dword [dword_D42DC]
        mov dword [esp], eax
        mov eax, dword [byte esp+050h]
        cmp byte [eax], 0
        je near loc_92CC6
loc_92901:
        mov eax, dword [byte esp+050h]
        lea ebx, [byte eax+01h]
        mov dword [byte esp+050h], ebx
        mov al, byte [eax]
        sub al, byte [byte_D42C0]
        movzx esi, al
        cmp esi, dword [byte esp+014h]
        jge near loc_92CB9
        mov edi, dword [dword_D42C8]
        test edi, edi
        je short loc_92930
        mov ah, byte [edi+esi]
        jmp short loc_92936
loc_92930:
        mov ah, byte [byte_D42C2]
loc_92936:
        movzx esi, ah
        mov dword [byte esp+038h], esi
        mov ebp, dword [dword_D42CC]
        test ebp, ebp
        je short loc_92951
        movzx esi, al
        mov edi, ebp
        mov ah, byte [edi+esi]
        jmp short loc_92957
loc_92951:
        mov ah, byte [byte_D42C3]
loc_92957:
        movzx esi, ah
        mov edx, dword [dword_D42D0]
        test edx, edx
        je short loc_9296F
        movzx edi, al
        mov ebp, edx
        movzx edi, byte [edi+ebp]
        jmp short loc_9297A
loc_9296F:
        movzx edi, byte [byte_D42C4]
        add edi, dword [byte esp+038h]
loc_9297A:
        mov dword [byte esp+08h], edi
        mov ecx, dword [dword_D42D4]
        test ecx, ecx
        je short loc_92993
        movzx edi, al
        mov ebp, ecx
        movzx edi, byte [edi+ebp]
        jmp short loc_92995
loc_92993:
        xor edi, edi
loc_92995:
        mov ebp, dword [dword_D42B0]
        add ebp, edi
        mov dword [byte esp+01Ch], ebp
        cmp dword [dword_D42D8], byte 0
        je short loc_929B9
        movzx edi, al
        mov ebp, dword [dword_D42D8]
        movzx ebp, byte [edi+ebp]
        jmp short loc_929BB
loc_929B9:
        xor ebp, ebp
loc_929BB:
        add ebp, dword [dword_D42B4]
        and eax, 0FFh
        lea edi, [nosplit eax*4+00h]
        mov eax, dword [dword_D42E0]
        mov edi, dword [edi+eax]
        cmp dword [byte esp+04h], byte 0
        je short loc_92A3D
        cmp dword [byte esp+038h], byte 0
        jle near loc_92CAF
        test esi, esi
        jle near loc_92CAF
        add esi, ebp
        push esi
        push ebp
        mov eax, dword [byte esp+024h]
        add eax, dword [byte esp+040h]
        push eax
        mov ebx, dword [byte esp+028h]
        push ebx
        call SetClipWindow
        add esp, byte 10h
        push ebp
        mov eax, dword [byte esp+020h]
        sub eax, edi
        push eax
        mov ecx, dword [byte esp+08h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov esi, dword [dword_D30A8]
        push esi
        push byte 0
        mov edi, dword [ScreenWidth]
        push edi
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        jmp near loc_92CAF
loc_92A3D:
        test edi, edi
        je near loc_92CAF
        add edi, dword [byte esp+02Ch]
        mov dword [byte esp+020h], esi
        mov eax, dword [byte esp+010h]
        cmp eax, byte 4
        jb short loc_92A6A
        jbe near loc_92B9B
        cmp eax, byte 8
        je near loc_92C3D
        jmp near loc_92CAF
loc_92A6A:
        cmp eax, byte 1
        jne near loc_92CAF
        mov edx, dword [byte esp+0Ch]
        push edx
        push esi
        mov ebx, dword [byte esp+040h]
        push ebx
        push ebp
        mov ecx, dword [byte esp+02Ch]
        push ecx
        call sub_90EC0
        add esp, byte 14h
        mov eax, dword [byte esp+038h]
        add eax, byte 7
        sar eax, 3
        mov dword [byte esp+018h], eax
loc_92A9A:
        mov edx, dword [byte esp+020h]
        dec edx
        mov dword [byte esp+020h], edx
        cmp edx, byte 0FFFFFFFFh
        je near loc_92CAF
        cmp ebp, dword [cliprect_y0]
        jl short loc_92ABC
        cmp ebp, dword [cliprect_y1]
        jl short loc_92AC5
loc_92ABC:
        add edi, dword [byte esp+018h]
        jmp near loc_92B95
loc_92AC5:
        mov esi, dword [byte esp+01Ch]
        mov eax, dword [byte esp+038h]
        mov dword [byte esp+030h], eax
        test eax, eax
        jle near loc_92B95
loc_92AD9:
        test byte [edi], 80h
        je short loc_92AED
        mov eax, dword [byte esp+03Ch]
        push eax
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_92AED:
        inc esi
        test byte [edi], 40h
        je short loc_92B02
        mov edx, dword [byte esp+03Ch]
        push edx
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_92B02:
        inc esi
        test byte [edi], 20h
        je short loc_92B17
        mov ebx, dword [byte esp+03Ch]
        push ebx
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_92B17:
        inc esi
        test byte [edi], 10h
        je short loc_92B2C
        mov ecx, dword [byte esp+03Ch]
        push ecx
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_92B2C:
        inc esi
        test byte [edi], 8
        je short loc_92B41
        mov eax, dword [byte esp+03Ch]
        push eax
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_92B41:
        inc esi
        test byte [edi], 4
        je short loc_92B56
        mov edx, dword [byte esp+03Ch]
        push edx
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_92B56:
        inc esi
        test byte [edi], 2
        je short loc_92B6B
        mov ebx, dword [byte esp+03Ch]
        push ebx
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_92B6B:
        inc esi
        test byte [edi], 1
        je short loc_92B80
        mov ecx, dword [byte esp+03Ch]
        push ecx
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_92B80:
        inc esi
        mov ebx, dword [byte esp+030h]
        sub ebx, byte 8
        mov dword [byte esp+030h], ebx
        inc edi
        test ebx, ebx
        jg near loc_92AD9
loc_92B95:
        inc ebp
        jmp near loc_92A9A
loc_92B9B:
        mov edx, dword [byte esp+0Ch]
        push edx
        push esi
        mov ebx, dword [byte esp+040h]
        push ebx
        push ebp
        mov ecx, dword [byte esp+02Ch]
        push ecx
        call sub_90EC0
        add esp, byte 14h
        mov eax, dword [byte esp+038h]
        inc eax
        sar eax, 1
        mov dword [byte esp+034h], eax
loc_92BBF:
        mov ebx, dword [byte esp+020h]
        dec ebx
        mov dword [byte esp+020h], ebx
        cmp ebx, byte 0FFFFFFFFh
        je near loc_92CAF
        cmp ebp, dword [cliprect_y0]
        jl short loc_92BE1
        cmp ebp, dword [cliprect_y1]
        jl short loc_92BE7
loc_92BE1:
        add edi, dword [byte esp+034h]
        jmp short loc_92C3A
loc_92BE7:
        mov esi, dword [byte esp+01Ch]
        mov eax, dword [byte esp+038h]
        mov dword [byte esp+024h], eax
        test eax, eax
        jle short loc_92C3A
loc_92BF7:
        xor eax, eax
        mov al, byte [edi]
        sar eax, 4
        test eax, eax
        je short loc_92C0D
        push eax
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_92C0D:
        inc esi
        mov cl, byte [edi]
        test cl, 0Fh
        je short loc_92C29
        mov al, cl
        and al, 0Fh
        and eax, 0FFh
        push eax
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_92C29:
        inc esi
        mov ecx, dword [byte esp+024h]
        sub ecx, byte 2
        mov dword [byte esp+024h], ecx
        inc edi
        test ecx, ecx
        jg short loc_92BF7
loc_92C3A:
        inc ebp
        jmp short loc_92BBF
loc_92C3D:
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push esi
        mov esi, dword [byte esp+040h]
        push esi
        push ebp
        mov eax, dword [byte esp+02Ch]
        push eax
        call sub_90EC0
        add esp, byte 14h
loc_92C56:
        mov eax, dword [byte esp+020h]
        dec eax
        mov dword [byte esp+020h], eax
        cmp eax, byte 0FFFFFFFFh
        je short loc_92CAF
        cmp ebp, dword [cliprect_y0]
        jl short loc_92C74
        cmp ebp, dword [cliprect_y1]
        jl short loc_92C7A
loc_92C74:
        add edi, dword [byte esp+038h]
        jmp short loc_92CAC
loc_92C7A:
        mov eax, dword [byte esp+01Ch]
        mov dword [byte esp+028h], eax
        mov esi, dword [byte esp+038h]
loc_92C86:
        dec esi
        cmp esi, byte 0FFFFFFFFh
        je short loc_92CAC
        mov bh, byte [edi]
        test bh, bh
        je short loc_92CA5
        xor eax, eax
        mov al, bh
        push eax
        push ebp
        mov eax, dword [byte esp+030h]
        push eax
        call sub_B5D80
        add esp, byte 0Ch
loc_92CA5:
        inc dword [byte esp+028h]
        inc edi
        jmp short loc_92C86
loc_92CAC:
        inc ebp
        jmp short loc_92C56
loc_92CAF:
        mov eax, dword [byte esp+08h]
        add dword [dword_D42B0], eax
loc_92CB9:
        mov eax, dword [byte esp+050h]
        cmp byte [eax], 0
        jne near loc_92901
loc_92CC6:
        add esp, byte 40h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
sub_92CD0:
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call sub_8E9D4
        add esp, byte 8
        mov ecx, dword [byte esp+04h]
        push ecx
        call sub_92890
        add esp, byte 4
        ret
sub_92CF0:
        sub esp, byte 4
        mov edx, dword [byte esp+010h]
        push edx
        mov ebx, dword [byte esp+010h]
        push ebx
        call sub_8E9D4
        add esp, byte 8
        mov al, byte [byte esp+08h]
        mov byte [esp], al
        xor ah, ah
        mov byte [byte esp+01h], ah
        mov eax, esp
        push eax
        call sub_92890
        add esp, byte 4
        add esp, byte 4
        ret
