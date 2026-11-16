; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_91D0B progbits alloc exec nowrite align=1
extern __close_, __flush_, __freefp_, __ioalloc_, _nfree_, dword_F24C8, fputc_, ftell_
extern j_unlink_, lseek_, GetPsp
global fclose_, loc_91D14, loc_91D20, loc_91D2B, __shutdown_stream_, __hex_, loc_91D5A, __MkTmpFile_
global loc_91D76, __doclose_, loc_91DDC, loc_91DEF, loc_91E07, loc_91E15, loc_91E2A, loc_91E43
global strncpy_, loc_91E53, loc_91E5E, loc_91E62, loc_91E6D, fputs_, loc_91E88, loc_91EA7
global loc_91EAB, loc_91EC2, loc_91EE3, loc_91EEB, strcmp_, loc_91F08, loc_91F74, loc_91F79
global loc_91F9A, sub_91FA4, memcmp_, loc_91FD5
fclose_:
        push ebx
        push edx
        mov edx, eax
        mov eax, dword [dword_F24C8]
loc_91D14:
        test eax, eax
        jne short loc_91D20
        mov eax, 0FFFFFFFFh
        pop edx
        pop ebx
        ret
loc_91D20:
        mov ebx, dword [byte eax+04h]
        cmp edx, ebx
        je short loc_91D2B
        mov eax, dword [eax]
        jmp short loc_91D14
loc_91D2B:
        mov edx, 1
        mov eax, ebx
        call __shutdown_stream_
        pop edx
        pop ebx
        ret
__shutdown_stream_:
        push ebx
        mov ebx, eax
        call __doclose_
        mov edx, eax
        mov eax, ebx
        call __freefp_
        mov eax, edx
        pop ebx
        ret
__hex_:
        add eax, byte 30h
        cmp eax, byte 39h
        jle short loc_91D5A
        add eax, byte 27h
loc_91D5A:
        ret
__MkTmpFile_:
        push ebx
        push ecx
        push esi
        push edi
        mov ecx, eax
        mov edi, edx
        call GetPsp
        mov edx, 4
        mov ebx, eax
        mov esi, ecx
        mov byte [ecx], 74h
        add edx, ecx
loc_91D76:
        mov eax, ebx
        and eax, byte 0Fh
        call __hex_
        mov byte [edx], al
        dec edx
        shr ebx, 4
        cmp edx, esi
        jne short loc_91D76
        mov eax, edi
        sar eax, 4
        and eax, byte 0Fh
        mov byte [byte ecx+05h], 5Fh
        call __hex_
        mov byte [byte ecx+06h], al
        mov eax, edi
        and eax, byte 0Fh
        call __hex_
        mov byte [byte ecx+08h], 2Eh
        mov byte [byte ecx+09h], 74h
        mov byte [byte ecx+0Ah], 6Dh
        mov byte [byte ecx+0Bh], 70h
        mov byte [byte ecx+0Ch], 0
        mov byte [byte ecx+07h], al
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
__doclose_:
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 10h
        mov ecx, eax
        mov edi, edx
        cmp dword [byte eax+0Ch], byte 0
        jne short loc_91DDC
        mov esi, 0FFFFFFFFh
        jmp short loc_91E43
loc_91DDC:
        mov ah, byte [byte eax+0Dh]
        xor esi, esi
        test ah, 10h
        je short loc_91DEF
        mov eax, ecx
        call __flush_
        mov esi, eax
loc_91DEF:
        mov eax, ecx
        call ftell_
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je short loc_91E07
        mov eax, dword [byte ecx+010h]
        xor ebx, ebx
        call lseek_
loc_91E07:
        test edi, edi
        je short loc_91E15
        mov eax, dword [byte ecx+010h]
        call __close_
        or esi, eax
loc_91E15:
        test byte [byte ecx+0Ch], 8
        je short loc_91E2A
        mov eax, dword [byte ecx+08h]
        call _nfree_
        mov dword [byte ecx+08h], 0
loc_91E2A:
        test byte [byte ecx+0Dh], 8
        je short loc_91E43
        xor edx, edx
        mov eax, esp
        mov dl, byte [byte ecx+019h]
        call __MkTmpFile_
        mov eax, esp
        call j_unlink_
loc_91E43:
        mov eax, esi
        add esp, byte 10h
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
strncpy_:
        push ecx
        push esi
        mov esi, eax
        jmp short loc_91E5E
loc_91E53:
        mov cl, byte [edx]
        test cl, cl
        je short loc_91E62
        inc edx
        dec ebx
        mov byte [eax], cl
        inc eax
loc_91E5E:
        test ebx, ebx
        jne short loc_91E53
loc_91E62:
        test ebx, ebx
        je short loc_91E6D
        dec ebx
        mov byte [eax], 0
        inc eax
        jmp short loc_91E62
loc_91E6D:
        mov eax, esi
        pop esi
        pop ecx
        ret
fputs_:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ecx, eax
        mov ebx, edx
        cmp dword [byte edx+08h], byte 0
        jne short loc_91E88
        mov eax, ebx
        call __ioalloc_
loc_91E88:
        mov ah, byte [byte ebx+0Dh]
        xor edi, edi
        test ah, 4
        je short loc_91EA7
        mov dl, ah
        and dl, 0F9h
        mov dh, dl
        mov byte [byte ebx+0Dh], dl
        or dh, 2
        mov edi, 1
        mov byte [byte ebx+0Dh], dh
loc_91EA7:
        mov ebp, ecx
        xor esi, esi
loc_91EAB:
        xor eax, eax
        mov al, byte [ecx]
        test eax, eax
        je short loc_91EC2
        mov edx, ebx
        inc ecx
        call fputc_
        cmp eax, byte 0FFFFFFFFh
        jne short loc_91EAB
        mov esi, eax
loc_91EC2:
        test edi, edi
        je short loc_91EE3
        mov al, byte [byte ebx+0Dh]
        and al, 0F9h
        mov ah, al
        mov byte [byte ebx+0Dh], al
        or ah, 4
        mov byte [byte ebx+0Dh], ah
        test esi, esi
        jne short loc_91EE3
        mov eax, ebx
        call __flush_
        mov esi, eax
loc_91EE3:
        test esi, esi
        jne short loc_91EEB
        mov esi, ecx
        sub esi, ebp
loc_91EEB:
        mov eax, esi
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
strcmp_:
        push ebx
        push ecx
        mov ebx, eax
        cmp eax, edx
        je short loc_91F74
loc_91F08:
        mov eax, dword [ebx]
        mov ecx, dword [edx]
        cmp ecx, eax
        jne short loc_91F79
        not ecx
        add eax, 0FEFEFEFFh
        and eax, ecx
        and eax, 80808080h
        jne short loc_91F74
        mov eax, dword [byte ebx+04h]
        mov ecx, dword [byte edx+04h]
        cmp ecx, eax
        jne short loc_91F79
        not ecx
        add eax, 0FEFEFEFFh
        and eax, ecx
        and eax, 80808080h
        jne short loc_91F74
        mov eax, dword [byte ebx+08h]
        mov ecx, dword [byte edx+08h]
        cmp ecx, eax
        jne short loc_91F79
        not ecx
        add eax, 0FEFEFEFFh
        and eax, ecx
        and eax, 80808080h
        jne short loc_91F74
        mov eax, dword [byte ebx+0Ch]
        mov ecx, dword [byte edx+0Ch]
        cmp ecx, eax
        jne short loc_91F79
        add ebx, byte 10h
        add edx, byte 10h
        not ecx
        add eax, 0FEFEFEFFh
        and eax, ecx
        and eax, 80808080h
        je short loc_91F08
loc_91F74:
        sub eax, eax
        pop ecx
        pop ebx
        ret
loc_91F79:
        cmp al, cl
        jne short loc_91F9A
        cmp al, 0
        je short loc_91F74
        cmp ah, ch
        jne short loc_91F9A
        cmp ah, 0
        je short loc_91F74
        shr eax, 10h
        shr ecx, 10h
        cmp al, cl
        jne short loc_91F9A
        cmp al, 0
        je short loc_91F74
        cmp ah, ch
loc_91F9A:
        sbb eax, eax
        or al, 1
        pop ecx
        pop ebx
        ret
        db 00h,00h,00h
sub_91FA4:
        mov eax, dword [byte esp+04h]
        imul dword [byte esp+08h]
        add eax, 7FFFh
        adc edx, byte 0
        shrd eax, edx, 10h
        ret
        db 00h,00h,00h
memcmp_:
        push ecx
        push esi
        push edi
        mov esi, eax
        mov edi, edx
        mov ecx, ebx
        push es
        mov eax, ds
        mov es, eax
        xor eax, eax
        repe cmpsb
        je short loc_91FD5
        sbb eax, eax
        sbb eax, byte 0FFFFFFFFh
loc_91FD5:
        pop es
        pop edi
        pop esi
        pop ecx
        ret
        db 00h,00h,00h,00h,00h,00h
