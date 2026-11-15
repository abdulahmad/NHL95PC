; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_9AFB0 progbits alloc exec nowrite align=1
extern __qwrite_, __set_errno_, __SetIOMode_, _nfree_, _nmalloc_, dword_EDF00, dword_F24C8, isatty_
extern loc_9B544, loc_9B565, loc_9B589, loc_9B5A9, loc_9B5C9, loc_9B61A, loc_9B66B, loc_9B6B3
extern loc_9B6F7, lseek_, memset_, tell_, unk_D4D18, unk_D4F20, _psp
global tolower_, loc_9AFBD, __allocfp_, loc_9AFE6, loc_9AFED, loc_9B00A, loc_9B00D, loc_9B02F
global loc_9B054, loc_9B060, __freefp_, loc_9B070, loc_9B081, loc_9B09B, loc_9B09F, loc_9B0A0
global loc_9B0BB, __update_buffer_, loc_9B0E9, fseek_, loc_9B125, loc_9B12F, loc_9B138, loc_9B140
global loc_9B14C, loc_9B167, loc_9B175, loc_9B17B, loc_9B1A0, loc_9B1D1, loc_9B1F5, loc_9B1F7
global __chktty_, loc_9B228, sub_9B22C, __flush_, loc_9B280, loc_9B29F, loc_9B2CE, loc_9B2DE
global ftell_, loc_9B319, loc_9B31D, __close_, loc_9B341, __ioalloc_, loc_9B373, loc_9B381
global loc_9B388, loc_9B3B7, loc_9B3BB, fputc_, loc_9B3E5, loc_9B3EF, loc_9B3FC, loc_9B439
global loc_9B459, loc_9B464, loc_9B468, unk_9B470
tolower_:
        cmp eax, byte 41h
        jl short loc_9AFBD
        cmp eax, byte 5Ah
        jg short loc_9AFBD
        add eax, byte 20h
loc_9AFBD:
        ret
__allocfp_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov esi, dword [dword_EDF00]
        test esi, esi
        je short loc_9AFE6
        mov ecx, dword [byte esi+04h]
        mov edi, dword [byte ecx+0Ch]
        mov eax, dword [esi]
        and edi, 4003h
        mov dword [dword_EDF00], eax
        or di, byte 3
        jmp short loc_9B02F
loc_9AFE6:
        mov ecx, unk_D4D18
        jmp short loc_9B00D
loc_9AFED:
        test byte [byte ecx+0Ch], 3
        jne short loc_9B00A
        mov eax, 8
        call _nmalloc_
        mov esi, eax
        test eax, eax
        je short loc_9B054
        mov edi, 3
        jmp short loc_9B02F
loc_9B00A:
        add ecx, byte 1Ah
loc_9B00D:
        cmp ecx, unk_D4F20
        jb short loc_9AFED
        mov eax, 22h
        mov edi, 4003h
        call _nmalloc_
        mov ecx, eax
        mov esi, eax
        test eax, eax
        je short loc_9B054
        lea ecx, [byte eax+08h]
loc_9B02F:
        mov ebx, 1Ah
        mov eax, ecx
        xor edx, edx
        call memset_
        mov dword [byte ecx+0Ch], edi
        mov eax, dword [dword_F24C8]
        mov dword [byte esi+04h], ecx
        mov dword [dword_F24C8], esi
        mov dword [esi], eax
        mov eax, ecx
        jmp short loc_9B060
loc_9B054:
        mov eax, 5
        call __set_errno_
        xor eax, eax
loc_9B060:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
__freefp_:
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov edx, dword_F24C8
loc_9B070:
        mov eax, dword [edx]
        test eax, eax
        je short loc_9B09B
        mov ecx, dword [byte eax+04h]
        cmp ebx, ecx
        je short loc_9B081
        mov edx, eax
        jmp short loc_9B070
loc_9B081:
        mov cl, byte [byte ecx+0Ch]
        or cl, 3
        mov byte [byte ebx+0Ch], cl
        mov ebx, dword [eax]
        mov dword [edx], ebx
        mov edx, dword [dword_EDF00]
        mov dword [dword_EDF00], eax
        mov dword [eax], edx
loc_9B09B:
        pop edx
        pop ecx
        pop ebx
        ret
loc_9B09F:
        push edx
loc_9B0A0:
        mov edx, dword [dword_EDF00]
        test edx, edx
        je short loc_9B0BB
        mov eax, edx
        mov edx, dword [edx]
        call _nfree_
        mov dword [dword_EDF00], edx
        jmp short loc_9B0A0
loc_9B0BB:
        pop edx
        ret
__update_buffer_:
        push ebx
        push ecx
        push esi
        push edi
        and byte [byte edx+0Ch], 0EFh
        cmp eax, dword [byte edx+04h]
        jg short loc_9B0E9
        mov ebx, dword [byte edx+08h]
        mov ecx, dword [edx]
        sub ebx, ecx
        cmp eax, ebx
        jl short loc_9B0E9
        mov edi, dword [byte edx+04h]
        lea esi, [ecx+eax]
        sub edi, eax
        mov dword [edx], esi
        xor eax, eax
        mov dword [byte edx+04h], edi
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
loc_9B0E9:
        mov eax, dword [byte edx+08h]
        mov dword [byte edx+04h], 0
        mov dword [edx], eax
        mov eax, 1
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
fseek_:
        push ecx
        push esi
        push edi
        mov ecx, eax
        mov esi, edx
        test byte [byte eax+0Ch], 6
        je short loc_9B167
        test byte [byte ecx+0Dh], 10h
        je short loc_9B138
        mov eax, ecx
        call __flush_
        test eax, eax
        je short loc_9B14C
        test ebx, ebx
        jne short loc_9B12F
        test esi, esi
        jge short loc_9B12F
loc_9B125:
        mov eax, 9
        call __set_errno_
loc_9B12F:
        mov eax, 0FFFFFFFFh
        pop edi
        pop esi
        pop ecx
        ret
loc_9B138:
        cmp ebx, byte 1
        jne short loc_9B140
        sub esi, dword [byte ecx+04h]
loc_9B140:
        mov eax, dword [byte ecx+08h]
        mov dword [byte ecx+04h], 0
        mov dword [ecx], eax
loc_9B14C:
        and byte [byte ecx+0Ch], 0EBh
        mov edx, esi
        mov eax, dword [byte ecx+010h]
        call lseek_
        cmp eax, byte 0FFFFFFFFh
        jne near loc_9B1F5
        pop edi
        pop esi
        pop ecx
        ret
loc_9B167:
        cmp ebx, byte 1
        jb short loc_9B175
        jbe short loc_9B17B
        cmp ebx, byte 2
        je short loc_9B1D1
        jmp short loc_9B125
loc_9B175:
        test ebx, ebx
        je short loc_9B1A0
        jmp short loc_9B125
loc_9B17B:
        mov eax, edx
        mov edx, ecx
        mov edi, dword [byte ecx+04h]
        call __update_buffer_
        test eax, eax
        je short loc_9B1F5
        mov edx, esi
        mov eax, dword [byte ecx+010h]
        sub edx, edi
        call lseek_
        cmp eax, byte 0FFFFFFFFh
        jne short loc_9B1F5
        pop edi
        pop esi
        pop ecx
        ret
loc_9B1A0:
        mov eax, dword [byte ecx+010h]
        call tell_
        mov edx, dword [byte ecx+04h]
        mov edi, esi
        sub eax, edx
        sub edi, eax
        mov edx, ecx
        mov eax, edi
        call __update_buffer_
        test eax, eax
        je short loc_9B1F5
        mov edx, esi
        mov eax, dword [byte ecx+010h]
        call lseek_
        cmp eax, byte 0FFFFFFFFh
        jne short loc_9B1F5
        pop edi
        pop esi
        pop ecx
        ret
loc_9B1D1:
        mov eax, dword [byte ecx+08h]
        mov dl, byte [byte ecx+0Ch]
        mov dword [ecx], eax
        and dl, 0EFh
        mov eax, dword [byte ecx+010h]
        mov byte [byte ecx+0Ch], dl
        mov edx, esi
        mov dword [byte ecx+04h], 0
        call lseek_
        cmp eax, byte 0FFFFFFFFh
        je short loc_9B1F7
loc_9B1F5:
        xor eax, eax
loc_9B1F7:
        pop edi
        pop esi
        pop ecx
        ret
__chktty_:
        push ebx
        push ecx
        push edx
        mov edx, eax
        test byte [byte eax+0Dh], 20h
        jne short loc_9B228
        mov eax, dword [byte edx+010h]
        call isatty_
        test eax, eax
        je short loc_9B228
        mov bl, byte [byte edx+0Dh]
        or bl, 20h
        mov byte [byte edx+0Dh], bl
        test bl, 7
        jne short loc_9B228
        mov cl, bl
        or cl, 2
        mov byte [byte edx+0Dh], cl
loc_9B228:
        pop edx
        pop ecx
        pop ebx
        ret
sub_9B22C:
        mov eax, dword [_psp]
        ret
__flush_:
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, eax
        mov ah, byte [byte eax+0Dh]
        xor esi, esi
        test ah, 10h
        je short loc_9B29F
        mov bh, byte [byte ecx+0Dh]
        and bh, 0EFh
        mov al, byte [byte ecx+0Ch]
        mov byte [byte ecx+0Dh], bh
        test al, 2
        je near loc_9B2DE
        cmp dword [byte ecx+08h], byte 0
        je near loc_9B2DE
        mov ebx, dword [byte ecx+04h]
        mov edx, dword [byte ecx+08h]
        mov eax, dword [byte ecx+010h]
        call __qwrite_
        cmp eax, byte 0FFFFFFFFh
        jne short loc_9B280
        mov dl, byte [byte ecx+0Ch]
        or dl, 20h
        mov esi, eax
        mov byte [byte ecx+0Ch], dl
        jmp short loc_9B2DE
loc_9B280:
        cmp eax, dword [byte ecx+04h]
        je short loc_9B2DE
        mov eax, 0Ch
        call __set_errno_
        mov ah, byte [byte ecx+0Ch]
        or ah, 20h
        mov esi, 0FFFFFFFFh
        mov byte [byte ecx+0Ch], ah
        jmp short loc_9B2DE
loc_9B29F:
        cmp dword [byte ecx+08h], byte 0
        je short loc_9B2DE
        mov dl, byte [byte ecx+0Ch]
        and dl, 0EFh
        mov dh, byte [byte ecx+0Dh]
        mov byte [byte ecx+0Ch], dl
        test dh, 20h
        jne short loc_9B2DE
        mov eax, dword [byte ecx+04h]
        test eax, eax
        je short loc_9B2CE
        mov edx, eax
        mov ebx, 1
        neg edx
        mov eax, dword [byte ecx+010h]
        call lseek_
loc_9B2CE:
        cmp eax, byte 0FFFFFFFFh
        jne short loc_9B2DE
        mov bl, byte [byte ecx+0Ch]
        or bl, 20h
        mov esi, eax
        mov byte [byte ecx+0Ch], bl
loc_9B2DE:
        mov eax, dword [byte ecx+08h]
        mov dword [byte ecx+04h], 0
        mov dword [ecx], eax
        mov eax, esi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
ftell_:
        push ebx
        push ecx
        push edx
        mov edx, eax
        mov eax, dword [byte eax+010h]
        call tell_
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je short loc_9B31D
        mov ecx, dword [byte edx+04h]
        test ecx, ecx
        je short loc_9B31D
        test byte [byte edx+0Dh], 10h
        je short loc_9B319
        lea eax, [ecx+ebx]
        pop edx
        pop ecx
        pop ebx
        ret
loc_9B319:
        mov eax, ebx
        sub eax, ecx
loc_9B31D:
        pop edx
        pop ecx
        pop ebx
        ret
__close_:
        push ebx
        push edx
        mov edx, eax
        mov ebx, eax
        mov ah, 3Eh
        int 21h
        rcl eax, 1
        ror eax, 1
        test eax, eax
        jl short loc_9B341
        mov eax, edx
        xor edx, edx
        call __SetIOMode_
        xor eax, eax
        pop edx
        pop ebx
        ret
loc_9B341:
        mov eax, 4
        call __set_errno_
        mov eax, 0FFFFFFFFh
        pop edx
        pop ebx
        ret
__ioalloc_:
        push ecx
        push edx
        mov edx, eax
        call __chktty_
        cmp dword [byte edx+014h], byte 0
        jne short loc_9B388
        mov ah, byte [byte edx+0Dh]
        test ah, 2
        je short loc_9B373
        mov dword [byte edx+014h], 86h
        jmp short loc_9B388
loc_9B373:
        test ah, 4
        je short loc_9B381
        mov dword [byte edx+014h], 1
        jmp short loc_9B388
loc_9B381:
        mov dword [byte edx+014h], 1000h
loc_9B388:
        mov eax, dword [byte edx+014h]
        call _nmalloc_
        mov dword [byte edx+08h], eax
        test eax, eax
        jne short loc_9B3B7
        lea eax, [byte edx+018h]
        mov cl, byte [byte edx+0Dh]
        mov dword [byte edx+014h], 1
        and cl, 0F8h
        mov dword [byte edx+08h], eax
        mov ch, cl
        mov byte [byte edx+0Dh], cl
        or ch, 4
        mov byte [byte edx+0Dh], ch
        jmp short loc_9B3BB
loc_9B3B7:
        or byte [byte edx+0Ch], 8
loc_9B3BB:
        mov eax, dword [byte edx+08h]
        mov dword [byte edx+04h], 0
        mov dword [edx], eax
        pop edx
        pop ecx
        ret
fputc_:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebx, eax
        test byte [byte edx+0Ch], 2
        jne short loc_9B3EF
        mov eax, 4
        call __set_errno_
        or byte [byte edx+0Ch], 20h
loc_9B3E5:
        mov eax, 0FFFFFFFFh
        jmp near loc_9B468
loc_9B3EF:
        cmp dword [byte edx+08h], byte 0
        jne short loc_9B3FC
        mov eax, edx
        call __ioalloc_
loc_9B3FC:
        mov ecx, 400h
        cmp ebx, byte 0Ah
        jne short loc_9B439
        mov al, byte [byte edx+0Ch]
        mov ecx, 600h
        test al, 40h
        jne short loc_9B439
        or byte [byte edx+0Dh], 10h
        mov eax, dword [edx]
        mov byte [eax], 0Dh
        mov esi, dword [edx]
        inc esi
        mov edi, dword [byte edx+04h]
        mov dword [edx], esi
        inc edi
        mov ebp, dword [byte edx+014h]
        mov dword [byte edx+04h], edi
        cmp edi, ebp
        jne short loc_9B439
        mov eax, edx
        call __flush_
        test eax, eax
        jne short loc_9B3E5
loc_9B439:
        or byte [byte edx+0Dh], 10h
        mov eax, dword [edx]
        mov byte [eax], bl
        mov eax, dword [edx]
        inc eax
        mov esi, dword [byte edx+04h]
        mov dword [edx], eax
        inc esi
        mov edi, dword [byte edx+0Ch]
        mov dword [byte edx+04h], esi
        test ecx, edi
        jne short loc_9B459
        cmp esi, dword [byte edx+014h]
        jne short loc_9B464
loc_9B459:
        mov eax, edx
        call __flush_
        test eax, eax
        jne short loc_9B3E5
loc_9B464:
        xor eax, eax
        mov al, bl
loc_9B468:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
        db 00h,00h
unk_9B470:
        dd loc_9B544
        dd loc_9B544
        dd loc_9B565
        dd loc_9B589
        dd loc_9B5A9
        dd loc_9B5C9
        dd loc_9B61A
        dd loc_9B66B
        dd loc_9B6B3
        dd loc_9B6F7
