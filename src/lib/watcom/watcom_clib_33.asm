; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_9B710 progbits alloc exec nowrite align=1
extern __flushall_, __ioalloc_, __qread_, __set_errno_, byte_C4C70, dword_D500C, dword_D5060, getche_
extern memset_
global isatty_, __IOMode_, loc_9B741, loc_9B777, __SetIOMode_, __fsetbits_, loc_9B7C1, loc_9B7E6
global __setbits_, loc_9B80A, loc_9B829, fgetc_, loc_9B859, loc_9B86D, loc_9B879, loc_9B898
global loc_9B8A4, loc_9B8B7, __filbuf_, loc_9B8D3, __fill_buffer_, loc_9B8FC, loc_9B913, loc_9B953
global loc_9B960, loc_9B963, loc_9B970, loc_9B97F, loc_9B98E, ungetc_, loc_9B9AA, loc_9B9B1
global loc_9B9C4, loc_9B9E3, loc_9BA04, loc_9BA06, loc_9BA12
isatty_:
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov al, 0
        mov ah, 44h
        int 21h
        rcl edx, 1
        ror edx, 1
        test dl, 80h
        setne al
        and eax, 0FFh
        pop edx
        pop ecx
        pop ebx
        ret
__IOMode_:
        push ebx
        push ecx
        push edx
        mov edx, eax
        cmp eax, dword [dword_D500C]
        jb short loc_9B741
        xor eax, eax
        pop edx
        pop ecx
        pop ebx
        ret
loc_9B741:
        cmp eax, byte 5
        jg short loc_9B777
        mov ebx, eax
        mov eax, dword [dword_D5060]
        shl ebx, 2
        add eax, ebx
        mov cl, byte [byte eax+01h]
        test cl, 40h
        jne short loc_9B777
        mov ch, cl
        or ch, 40h
        mov byte [byte eax+01h], ch
        mov eax, edx
        call isatty_
        test eax, eax
        je short loc_9B777
        mov eax, dword [dword_D5060]
        or byte [byte ebx+eax+01h], 20h
loc_9B777:
        mov eax, dword [dword_D5060]
        mov eax, dword [eax+edx*4]
        pop edx
        pop ecx
        pop ebx
        ret
__SetIOMode_:
        push ebx
        or dh, 40h
        mov ebx, edx
        mov edx, eax
        mov eax, dword [dword_D5060]
        shl edx, 2
        mov dword [edx+eax], ebx
        pop ebx
        ret
__fsetbits_:
        push esi
        push edi
        push es
        push fs
        push gs
        mov gs, edx
        mov esi, eax
        mov es, ecx
        mov ecx, 20h
        mov edi, eax
        xor al, al
        push es
        push edi
        mov es, edx
        mov ah, al
        shr ecx, 1
        db 0F2h,066h,0ABh                       ; insn: repne stosw (nasm 3 emits 66h F2h)
        adc ecx, ecx
        repne stosb
        pop edi
        pop es
        jmp short loc_9B7E6
loc_9B7C1:
        xor eax, eax
        mov ecx, gs
        mov al, dl
        mov fs, ecx
        sar eax, 3
        and dl, 7
        and edx, 0FFh
        mov dl, byte [dword edx+byte_C4C70]
        mov dh, byte [fs:esi+eax]
        or dh, dl
        inc ebx
        mov byte [fs:esi+eax], dh
loc_9B7E6:
        mov dl, byte [es:ebx]
        test dl, dl
        jne short loc_9B7C1
        pop gs
        pop fs
        pop es
        pop edi
        pop esi
        ret
__setbits_:
        push ebx
        push ecx
        push esi
        mov esi, eax
        mov ecx, edx
        mov ebx, 20h
        xor edx, edx
        call memset_
        jmp short loc_9B829
loc_9B80A:
        xor eax, eax
        mov al, dl
        sar eax, 3
        and dl, 7
        and edx, 0FFh
        mov dl, byte [dword edx+byte_C4C70]
        mov dh, byte [esi+eax]
        or dh, dl
        inc ecx
        mov byte [esi+eax], dh
loc_9B829:
        mov dl, byte [ecx]
        test dl, dl
        jne short loc_9B80A
        pop esi
        pop ecx
        pop ebx
        ret
fgetc_:
        push ebx
        push ecx
        push edx
        push esi
        mov edx, eax
        test byte [byte eax+0Ch], 1
        jne short loc_9B859
        mov eax, 4
        call __set_errno_
        mov bl, byte [byte edx+0Ch]
        or bl, 20h
        mov eax, 0FFFFFFFFh
        mov byte [byte edx+0Ch], bl
        jmp short loc_9B879
loc_9B859:
        mov ebx, dword [byte edx+04h]
        dec ebx
        mov dword [byte edx+04h], ebx
        test ebx, ebx
        jge short loc_9B86D
        mov eax, edx
        call __filbuf_
        jmp short loc_9B879
loc_9B86D:
        mov ebx, dword [edx]
        mov al, byte [ebx]
        inc ebx
        and eax, 0FFh
        mov dword [edx], ebx
loc_9B879:
        test byte [byte edx+0Ch], 40h
        jne short loc_9B8B7
        cmp eax, byte 0Dh
        jne short loc_9B8A4
        mov esi, dword [byte edx+04h]
        dec esi
        mov dword [byte edx+04h], esi
        test esi, esi
        jge short loc_9B898
        mov eax, edx
        call __filbuf_
        jmp short loc_9B8A4
loc_9B898:
        mov ebx, dword [edx]
        mov al, byte [ebx]
        inc ebx
        and eax, 0FFh
        mov dword [edx], ebx
loc_9B8A4:
        cmp eax, byte 1Ah
        jne short loc_9B8B7
        mov cl, byte [byte edx+0Ch]
        or cl, 10h
        mov eax, 0FFFFFFFFh
        mov byte [byte edx+0Ch], cl
loc_9B8B7:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
__filbuf_:
        push ebx
        push ecx
        push edx
        mov edx, eax
        call __fill_buffer_
        test eax, eax
        jne short loc_9B8D3
        mov eax, 0FFFFFFFFh
        pop edx
        pop ecx
        pop ebx
        ret
loc_9B8D3:
        mov ebx, dword [byte edx+04h]
        mov ecx, dword [edx]
        dec ebx
        inc ecx
        mov dword [byte edx+04h], ebx
        mov dword [edx], ecx
        mov al, byte [byte ecx-01h]
        and eax, 0FFh
        pop edx
        pop ecx
        pop ebx
        ret
__fill_buffer_:
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, eax
        cmp dword [byte eax+08h], byte 0
        jne short loc_9B8FC
        call __ioalloc_
loc_9B8FC:
        mov ah, byte [byte ecx+0Dh]
        test ah, 20h
        je short loc_9B913
        test ah, 6
        je short loc_9B913
        mov eax, 2000h
        call __flushall_
loc_9B913:
        mov edx, dword [byte ecx+0Ch]
        mov bl, byte [byte ecx+0Ch]
        mov eax, dword [byte ecx+08h]
        and bl, 0FBh
        mov dword [ecx], eax
        and edx, 2400h
        mov byte [byte ecx+0Ch], bl
        cmp edx, 2400h
        jne short loc_9B953
        mov ebx, dword [byte ecx+010h]
        test ebx, ebx
        jne short loc_9B953
        mov dword [byte ecx+04h], ebx
        call getche_
        cmp eax, byte 0FFFFFFFFh
        je short loc_9B970
        mov ebx, dword [ecx]
        mov byte [ebx], al
        mov dword [byte ecx+04h], 1
        jmp short loc_9B970
loc_9B953:
        test byte [byte ecx+0Dh], 4
        je short loc_9B960
        mov ebx, 1
        jmp short loc_9B963
loc_9B960:
        mov ebx, dword [byte ecx+014h]
loc_9B963:
        mov edx, dword [ecx]
        mov eax, dword [byte ecx+010h]
        call __qread_
        mov dword [byte ecx+04h], eax
loc_9B970:
        mov esi, dword [byte ecx+04h]
        test esi, esi
        jg short loc_9B98E
        jne short loc_9B97F
        or byte [byte ecx+0Ch], 10h
        jmp short loc_9B98E
loc_9B97F:
        mov al, byte [byte ecx+0Ch]
        mov dword [byte ecx+04h], 0
        or al, 20h
        mov byte [byte ecx+0Ch], al
loc_9B98E:
        mov eax, dword [byte ecx+04h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
ungetc_:
        push ebx
        push esi
        push ebp
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je near loc_9BA12
        test byte [byte edx+0Dh], 10h
        je short loc_9B9B1
loc_9B9AA:
        mov ebx, 0FFFFFFFFh
        jmp short loc_9BA12
loc_9B9B1:
        test byte [byte edx+0Ch], 1
        je short loc_9B9AA
        cmp dword [byte edx+08h], byte 0
        jne short loc_9B9C4
        mov eax, edx
        call __ioalloc_
loc_9B9C4:
        mov esi, dword [byte edx+04h]
        test esi, esi
        jne short loc_9B9E3
        mov eax, dword [byte edx+08h]
        add eax, dword [byte edx+014h]
        dec eax
        mov dword [edx], eax
        or byte [byte edx+0Ch], 4
        mov eax, dword [edx]
        mov dword [byte edx+04h], 1
        jmp short loc_9BA06
loc_9B9E3:
        mov eax, dword [edx]
        cmp eax, dword [byte edx+08h]
        je short loc_9B9AA
        mov eax, dword [edx]
        lea ebp, [byte esi+01h]
        dec eax
        mov dword [byte edx+04h], ebp
        mov dword [edx], eax
        mov al, byte [eax]
        and eax, 0FFh
        cmp eax, ebx
        je short loc_9BA04
        or byte [byte edx+0Ch], 4
loc_9BA04:
        mov eax, dword [edx]
loc_9BA06:
        mov byte [eax], bl
        and byte [byte edx+0Ch], 0EFh
        and ebx, 0FFh
loc_9BA12:
        mov eax, ebx
        pop ebp
        pop esi
        pop ebx
        ret
