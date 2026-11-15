; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_91984 progbits alloc exec nowrite align=1
extern __allocfp_, __chktty_, __doclose_, __ExpandDGROUP_, __freefp_, __MemAllocator, __MemFree, __set_errno_
extern byte_F24C5, dword_D43E8, dword_D43EC, dword_D43F0, dword_D4F21, dword_EDF00, dword_F24C8, fseek_
extern sopen_, sub_9AFAD, tolower_
global _nmalloc_, loc_9199D, loc_919A4, loc_919B7, loc_919C3, loc_919D5, loc_919E3, loc_919E7
global loc_91A18, loc_91A1B, loc_91A30, loc_91A45, loc_91A4E, loc_91A58, _nfree_, loc_91A75
global loc_91A7D, loc_91A80, loc_91A87, loc_91AB8, strlen_, __open_flags_, loc_91B11, loc_91B38
global loc_91B3A, loc_91B3E, loc_91B57, loc_91B63, loc_91B6F, loc_91B71, loc_91B7D, loc_91B86
global loc_91B89, loc_91B8B, __doopen_, loc_91BC7, loc_91BD2, loc_91BD5, loc_91BD9, loc_91BF1
global loc_91BF3, loc_91BFE, loc_91C01, loc_91C06, loc_91C26, loc_91C4E, _fsopen_, loc_91C72
global fopen_, close_file_, loc_91C89, loc_91CA6, loc_91CAC, loc_91CB0, loc_91CB5, loc_91CD3
global loc_91CD7
_nmalloc_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push es
        push fs
        push gs
        push ebp
        sub esp, byte 4
        mov esi, eax
        test eax, eax
        je short loc_9199D
        cmp eax, byte 0FFFFFFD4h
        jbe short loc_919A4
loc_9199D:
        xor eax, eax
        jmp near loc_91A58
loc_919A4:
        mov ebp, dword_D43E8
        lea edi, [byte esi+03h]
        xor ah, ah
        xor ebx, ebx
        mov byte [esp], ah
        and di, byte 0FFFCh
loc_919B7:
        mov eax, edi
        cmp edi, byte 0Ch
        jae short loc_919C3
        mov eax, 0Ch
loc_919C3:
        cmp eax, dword [dword_D43F0]
        jbe short loc_919E3
        mov ecx, dword [dword_D43EC]
        test ecx, ecx
        jne short loc_91A1B
loc_919D5:
        mov dword [dword_D43F0], ecx
        mov ecx, dword [dword_D43E8]
        jmp short loc_91A1B
loc_919E3:
        xor ecx, ecx
        jmp short loc_919D5
loc_919E7:
        mov edx, ds
        mov eax, ebp
        mov dword [dword_D43EC], ecx
        and edx, 0FFFFh
        mov eax, esi
        mov ebx, ecx
        call __MemAllocator
        mov ebx, eax
        test eax, eax
        jne short loc_91A4E
        mov eax, dword [dword_D43F0]
        mov edx, dword [byte ecx+014h]
        cmp edx, eax
        jbe short loc_91A18
        mov dword [dword_D43F0], edx
loc_91A18:
        mov ecx, dword [byte ecx+08h]
loc_91A1B:
        test ecx, ecx
        jne short loc_919E7
        cmp byte [esp], 0
        jne short loc_91A30
        mov eax, esi
        call __ExpandDGROUP_
        test eax, eax
        jne short loc_91A45
loc_91A30:
        mov eax, esi
        call sub_9AFAD
        test eax, eax
        je short loc_91A4E
        xor cl, cl
        mov byte [esp], cl
        jmp near loc_919B7
loc_91A45:
        mov byte [esp], 1
        jmp near loc_919B7
loc_91A4E:
        xor ch, ch
        mov eax, ebx
        mov byte [byte_F24C5], ch
loc_91A58:
        add esp, byte 4
        pop ebp
        pop gs
        pop fs
        pop es
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
_nfree_:
        push ebx
        push ecx
        push edx
        push ebp
        mov ebx, eax
        mov ecx, dword [dword_D43E8]
        jmp short loc_91A80
loc_91A75:
        cmp ecx, ebx
        ja short loc_91A7D
        cmp ebx, edx
        jb short loc_91A87
loc_91A7D:
        mov ecx, dword [byte ecx+08h]
loc_91A80:
        mov edx, dword [byte ecx+08h]
        test edx, edx
        jne short loc_91A75
loc_91A87:
        mov eax, dword_D43E8
        mov edx, ds
        and edx, 0FFFFh
        mov eax, ebx
        mov ebx, ecx
        call __MemFree
        cmp ecx, dword [dword_D43EC]
        je short loc_91AB8
        mov ebp, dword [dword_D43F0]
        mov edx, dword [byte ecx+014h]
        cmp edx, ebp
        jbe short loc_91AB8
        mov dword [dword_D43F0], edx
loc_91AB8:
        xor ah, ah
        mov byte [byte_F24C5], ah
        pop ebp
        pop edx
        pop ecx
        pop ebx
        ret
strlen_:
        push ecx
        push edi
        mov edi, eax
        push es
        mov eax, ds
        mov es, eax
        sub ecx, ecx
        dec ecx
        xor eax, eax
        repne scasb
        not ecx
        dec ecx
        pop es
        mov eax, ecx
        pop edi
        pop ecx
        ret
__open_flags_:
        push ebx
        push ecx
        push edx
        sub esp, byte 4
        mov edx, eax
        xor eax, eax
        mov al, byte [edx]
        xor ebx, ebx
        call tolower_
        mov byte [esp], al
        cmp al, 72h
        je short loc_91B11
        cmp al, 77h
        je short loc_91B11
        cmp al, 61h
        je short loc_91B11
        mov eax, 9
        call __set_errno_
        xor eax, eax
        jmp near loc_91B8B
loc_91B11:
        mov eax, ebx
        mov cl, byte [byte edx+01h]
        or al, 3
        cmp cl, 2Bh
        jne short loc_91B3E
        mov ebx, eax
        mov cl, byte [byte edx+02h]
        or al, 40h
        cmp cl, 62h
        je short loc_91B3A
        cmp cl, 74h
        je short loc_91B71
        cmp dword [dword_D4F21], 200h
loc_91B38:
        jne short loc_91B71
loc_91B3A:
        mov ebx, eax
        jmp short loc_91B71
loc_91B3E:
        mov ecx, ebx
        or cl, 40h
        cmp byte [byte edx+01h], 62h
        jne short loc_91B57
        mov al, byte [byte edx+02h]
        mov ebx, ecx
        cmp al, 2Bh
        jne short loc_91B71
        or cl, 3
        jmp short loc_91B6F
loc_91B57:
        cmp byte [byte edx+01h], 74h
        jne short loc_91B63
        cmp byte [byte edx+02h], 2Bh
        jmp short loc_91B38
loc_91B63:
        cmp dword [dword_D4F21], 200h
        jne short loc_91B71
loc_91B6F:
        mov ebx, ecx
loc_91B71:
        mov al, byte [esp]
        cmp al, 77h
        jne short loc_91B7D
        or bl, 2
        jmp short loc_91B89
loc_91B7D:
        cmp al, 61h
        jne short loc_91B86
        or bl, 82h
        jmp short loc_91B89
loc_91B86:
        or bl, 1
loc_91B89:
        mov eax, ebx
loc_91B8B:
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
__doopen_:
        push esi
        push edi
        mov esi, eax
        and byte [byte ecx+0Ch], 0FCh
        mov eax, edx
        call __open_flags_
        mov edi, dword [byte ecx+0Ch]
        or edi, eax
        xor eax, eax
        mov dword [byte ecx+0Ch], edi
        mov al, byte [edx]
        call tolower_
        mov dl, al
        cmp al, 72h
        jne short loc_91BD9
        mov dh, byte [byte ecx+0Ch]
        xor eax, eax
        test dh, 2
        je short loc_91BC7
        mov eax, 2
loc_91BC7:
        test byte [byte ecx+0Ch], 40h
        je short loc_91BD2
        or ah, 2
        jmp short loc_91BD5
loc_91BD2:
        or ah, 1
loc_91BD5:
        push byte 0
        jmp short loc_91C06
loc_91BD9:
        test byte [byte ecx+0Ch], 1
        setne al
        and eax, 0FFh
        add eax, byte 21h
        cmp dl, 61h
        jne short loc_91BF1
        or al, 10h
        jmp short loc_91BF3
loc_91BF1:
        or al, 40h
loc_91BF3:
        test byte [byte ecx+0Ch], 40h
        je short loc_91BFE
        or ah, 2
        jmp short loc_91C01
loc_91BFE:
        or ah, 1
loc_91C01:
        push dword 180h
loc_91C06:
        push ebx
        push eax
        push esi
        call sopen_
        add esp, byte 10h
        mov dword [byte ecx+010h], eax
        cmp dword [byte ecx+010h], byte 0FFFFFFFFh
        jne short loc_91C26
        mov eax, ecx
        call __freefp_
        xor eax, eax
        pop edi
        pop esi
        ret
loc_91C26:
        mov dword [byte ecx+04h], 0
        mov dword [byte ecx+08h], 0
        mov dword [byte ecx+014h], 0
        cmp dl, 61h
        jne short loc_91C4E
        mov ebx, 2
        mov eax, ecx
        xor edx, edx
        call fseek_
loc_91C4E:
        mov eax, ecx
        call __chktty_
        mov eax, ecx
        pop edi
        pop esi
        ret
_fsopen_:
        push ecx
        push esi
        mov esi, eax
        xor eax, eax
        call __allocfp_
        mov ecx, eax
        test eax, eax
        je short loc_91C72
        mov eax, esi
        call __doopen_
loc_91C72:
        pop esi
        pop ecx
        ret
fopen_:
        push ebx
        xor ebx, ebx
        call _fsopen_
        pop ebx
        ret
close_file_:
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov eax, dword [dword_F24C8]
loc_91C89:
        test eax, eax
        je short loc_91CB0
        mov edx, dword [byte eax+04h]
        cmp ebx, edx
        jne short loc_91CAC
        test byte [byte edx+0Ch], 3
        je short loc_91CA6
        mov eax, edx
        mov edx, 1
        call __doclose_
loc_91CA6:
        mov eax, ebx
        pop edx
        pop ecx
        pop ebx
        ret
loc_91CAC:
        mov eax, dword [eax]
        jmp short loc_91C89
loc_91CB0:
        mov edx, dword_EDF00
loc_91CB5:
        mov eax, dword [edx]
        test eax, eax
        je short loc_91CD7
        cmp ebx, dword [byte eax+04h]
        jne short loc_91CD3
        mov ecx, dword [eax]
        mov dword [edx], ecx
        mov edx, dword [dword_F24C8]
        mov dword [dword_F24C8], eax
        mov dword [eax], edx
        jmp short loc_91CA6
loc_91CD3:
        mov edx, eax
        jmp short loc_91CB5
loc_91CD7:
        mov eax, 4
        call __set_errno_
        xor eax, eax
        pop edx
        pop ecx
        pop ebx
        ret
