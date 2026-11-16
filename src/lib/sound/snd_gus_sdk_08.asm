; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_B19E0 progbits alloc exec nowrite align=1
extern byte_D8B0E, byte_D8B10, byte_F79D8, byte_F79E8, dword_D89DC, dword_F79F8, dword_F79FC, dword_F7A00
extern dword_F7B78, inp_, outp_, outpw_, GusEnterCritical, GusLeaveCritical, GusSetVoiceCallbacks, word_D8764
extern word_D8766, word_D8772, word_D8774, word_D8776, word_D8778, word_F79A0
global sub_B19E0, sub_B1A04, loc_B1A35, loc_B1ABF, sub_B1AC8, loc_B1AF9, loc_B1B83, sub_B1B8C
global sub_B1BF8, sub_B1C70, loc_B1C8A, loc_B1CA9, sub_B1CBC, loc_B1CE9, loc_B1D46, loc_B1D71
global loc_B1D8B, loc_B1DA5, loc_B1DA6, loc_B1DD7, loc_B1E19, loc_B1E22, sub_B1E2C, sub_B1E64
global sub_B1EA0, sub_B1F1C, GusPokeFill, loc_B1FC4, loc_B1FC6, loc_B1FD1, loc_B2000, loc_B203D
global loc_B2043, loc_B2045, loc_B2067, GusTestDramBank, loc_B20C5, loc_B20F1, loc_B211D, loc_B2149
global loc_B2175, loc_B2181, loc_B21E7, loc_B21F4, loc_B21FA, loc_B2214
sub_B19E0:
        push ebp
        mov ebp, esp
        push edx
        mov ah, 1
        xor edx, edx
        mov byte [byte_D8B0E], ah
        mov dword [byte_F79E8], edx
        xor dl, dl
        xor eax, eax
        mov byte [byte_F79D8], dl
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
sub_B1A04:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        mov ebx, eax
        mov ecx, edx
        pushfw
        cli
        call GusEnterCritical
        mov eax, 2
        mov edx, ebx
        call GusSetVoiceCallbacks
        mov ebx, eax
        test eax, eax
        je short loc_B1A35
        call GusLeaveCritical
        popfw
        mov eax, ebx
        jmp near loc_B1ABF
loc_B1A35:
        mov edx, 47h
        mov ax, word [word_D8772]
        call outp_
        xor eax, eax
        mov edx, ecx
        mov ax, word [word_D8776]
        call outp_
        or byte [byte_F79D8], 8
        xor eax, eax
        mov edx, 45h
        mov ax, word [word_D8772]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte_F79D8]
        mov ax, word [word_D8776]
        call outp_
        mov dl, byte [byte_F79E8]
        xor eax, eax
        or dl, 2
        mov ax, word [word_D8764]
        mov byte [byte_F79E8], dl
        mov edx, 4
        call outp_
        xor eax, eax
        mov edx, dword [byte_F79E8]
        mov ax, word [word_D8766]
        call outp_
        call GusLeaveCritical
        popfw
        xor eax, eax
loc_B1ABF:
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
sub_B1AC8:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        mov ebx, eax
        mov ecx, edx
        pushfw
        cli
        call GusEnterCritical
        mov eax, 1
        mov edx, ebx
        call GusSetVoiceCallbacks
        mov ebx, eax
        test eax, eax
        je short loc_B1AF9
        call GusLeaveCritical
        popfw
        mov eax, ebx
        jmp near loc_B1B83
loc_B1AF9:
        mov edx, 46h
        mov ax, word [word_D8772]
        call outp_
        xor eax, eax
        mov edx, ecx
        mov ax, word [word_D8776]
        call outp_
        or byte [byte_F79D8], 4
        xor eax, eax
        mov edx, 45h
        mov ax, word [word_D8772]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte_F79D8]
        mov ax, word [word_D8776]
        call outp_
        mov dl, byte [byte_F79E8]
        xor eax, eax
        or dl, 1
        mov ax, word [word_D8764]
        mov byte [byte_F79E8], dl
        mov edx, 4
        call outp_
        xor eax, eax
        mov edx, dword [byte_F79E8]
        mov ax, word [word_D8766]
        call outp_
        call GusLeaveCritical
        popfw
        xor eax, eax
loc_B1B83:
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
sub_B1B8C:
        push ebp
        mov ebp, esp
        push edx
        pushfw
        cli
        call GusEnterCritical
        mov eax, 1
        xor edx, edx
        call GusSetVoiceCallbacks
        mov ah, byte [byte_F79D8]
        mov dl, byte [byte_F79E8]
        and ah, 0FBh
        and dl, 0FEh
        mov byte [byte_F79D8], ah
        mov byte [byte_F79E8], dl
        xor eax, eax
        mov edx, 45h
        mov ax, word [word_D8772]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte_F79D8]
        mov ax, word [word_D8776]
        call outp_
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 08Bh,0C0h
sub_B1BF8:
        push ebp
        mov ebp, esp
        push edx
        pushfw
        cli
        call GusEnterCritical
        mov eax, 2
        xor edx, edx
        call GusSetVoiceCallbacks
        mov ah, byte [byte_F79D8]
        mov dl, byte [byte_F79E8]
        and ah, 0F7h
        and dl, 0FDh
        mov byte [byte_F79D8], ah
        mov byte [byte_F79E8], dl
        xor eax, eax
        mov edx, 45h
        mov ax, word [word_D8772]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte_F79D8]
        mov ax, word [word_D8776]
        call outp_
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
sub_B1C70:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ah, 1
        xor edx, edx
        xor ebx, ebx
        mov byte [byte_D8B10], ah
        mov dword [dword_F7B78], edx
        jmp short loc_B1CA9
loc_B1C8A:
        xor edx, edx
        mov dx, bx
        lea eax, [nosplit edx*4+00h]
        sub eax, edx
        xor ecx, ecx
        mov dword [nosplit eax*4+dword_F79F8], ecx
        inc ebx
        mov dword [nosplit eax*4+dword_F79FC], ecx
loc_B1CA9:
        cmp bx, word [word_F79A0]
        jb short loc_B1C8A
        xor eax, eax
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
sub_B1CBC:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 0Ch
        mov esi, eax
        mov edi, edx
        pushfw
        cli
        call GusEnterCritical
        mov edx, 0FFFFFFFFh
        mov ebx, 1
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ebx
        xor ebx, ebx
        jmp near loc_B1DA6
loc_B1CE9:
        mov eax, 1
        mov ecx, ebx
        shl eax, cl
        mov ecx, eax
        mov eax, dword [dword_F7B78]
        test ecx, eax
        jne short loc_B1D46
        mov edx, eax
        or edx, ecx
        mov dword [dword_F7B78], edx
        and ebx, 0FFFFh
        lea eax, [nosplit ebx*4+00h]
        sub eax, ebx
        mov edx, dword [dword_D89DC]
        mov dword [nosplit eax*4+dword_F79FC], esi
        mov dword [nosplit eax*4+dword_F79F8], edx
        inc edx
        mov dword [nosplit eax*4+dword_F7A00], edi
        mov dword [dword_D89DC], edx
        call GusLeaveCritical
        popfw
        mov eax, ebx
        jmp near loc_B1E22
loc_B1D46:
        xor eax, eax
        mov ax, bx
        mov dword [byte ebp-01Ch], eax
        mov ecx, dword [byte ebp-01Ch]
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [dword eax+dword_F79FC]
        cmp ecx, dword [byte ebp-014h]
        jb short loc_B1DA5
        ja short loc_B1D71
        mov ecx, dword [byte ebp-018h]
        cmp ecx, dword [dword eax+dword_F79F8]
        jbe short loc_B1D8B
loc_B1D71:
        xor ecx, ecx
        mov cx, bx
        lea eax, [nosplit ecx*4+00h]
        sub eax, ecx
        mov eax, dword [nosplit eax*4+dword_F79F8]
        mov edx, ecx
        mov dword [byte ebp-018h], eax
loc_B1D8B:
        xor eax, eax
        mov ax, bx
        mov dword [byte ebp-01Ch], eax
        mov ecx, dword [byte ebp-01Ch]
        shl eax, 2
        sub eax, ecx
        mov eax, dword [nosplit eax*4+dword_F79FC]
        mov dword [byte ebp-014h], eax
loc_B1DA5:
        inc ebx
loc_B1DA6:
        cmp bx, word [word_F79A0]
        jb near loc_B1CE9
        cmp edx, byte 0FFFFFFFFh
        je short loc_B1E19
        lea eax, [nosplit edx*4+00h]
        sub eax, edx
        shl eax, 2
        cmp dword [dword eax+dword_F7A00], byte 0
        je short loc_B1DD7
        mov ebx, eax
        mov eax, edx
        call dword [dword ebx+dword_F7A00]
loc_B1DD7:
        mov eax, 1
        mov cl, dl
        shl eax, cl
        mov ecx, dword [dword_F7B78]
        or ecx, eax
        lea eax, [nosplit edx*4+00h]
        sub eax, edx
        mov ebx, dword [dword_D89DC]
        mov dword [nosplit eax*4+dword_F79FC], esi
        mov dword [dword_F7B78], ecx
        mov dword [nosplit eax*4+dword_F79F8], ebx
        inc ebx
        mov dword [nosplit eax*4+dword_F7A00], edi
        mov dword [dword_D89DC], ebx
loc_B1E19:
        call GusLeaveCritical
        popfw
        mov eax, edx
loc_B1E22:
        lea esp, [byte ebp-010h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
sub_B1E2C:
        push ebp
        mov ebp, esp
        push ecx
        push edx
        mov ecx, eax
        pushfw
        cli
        call GusEnterCritical
        mov eax, 1
        shl eax, cl
        mov ecx, eax
        mov edx, dword [dword_F7B78]
        not ecx
        and edx, ecx
        mov dword [dword_F7B78], edx
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-08h]
        pop edx
        pop ecx
        pop ebp
        ret
        db 08Bh,0C0h
sub_B1E64:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        mov ecx, eax
        mov ebx, edx
        pushfw
        cli
        mov edx, ecx
        call GusEnterCritical
        lea eax, [nosplit edx*4+00h]
        sub eax, edx
        add dword [nosplit eax*4+dword_F79FC], ebx
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
sub_B1EA0:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov ebx, eax
        pushfw
        cli
        call GusEnterCritical
        xor eax, eax
        mov edx, 43h
        mov ax, word [word_D8772]
        call outp_
        xor eax, eax
        mov edx, ebx
        mov ax, word [word_D8774]
        call outpw_
        shr ebx, 10h
        xor eax, eax
        mov edx, 44h
        mov ax, word [word_D8772]
        and ebx, 0FFh
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [word_D8776]
        mov dl, bl
        call outp_
        xor eax, eax
        mov ax, word [word_D8778]
        call inp_
        mov ebx, eax
        call GusLeaveCritical
        popfw
        mov al, bl
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 090h
sub_B1F1C:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        mov ebx, eax
        mov cl, dl
        pushfw
        cli
        call GusEnterCritical
        xor eax, eax
        mov edx, 43h
        mov ax, word [word_D8772]
        call outp_
        xor eax, eax
        mov edx, ebx
        mov ax, word [word_D8774]
        call outpw_
        shr ebx, 10h
        xor eax, eax
        mov edx, 44h
        mov ax, word [word_D8772]
        and ebx, 0FFh
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [word_D8776]
        mov dl, bl
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [word_D8778]
        mov dl, cl
        call outp_
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusPokeFill:
        push ebp
        mov ebp, esp
        push esi
        sub esp, byte 10h
        mov esi, eax
        mov al, cl
        mov ah, cl
        and ah, 40h
        mov ecx, edx
        mov byte [byte ebp-08h], ah
        shr edx, 10h
        xor ah, ah
        mov byte [byte ebp-014h], dl
        mov byte [byte ebp-010h], ah
        test al, 80h
        je short loc_B1FC4
        mov al, 80h
        jmp short loc_B1FC6
loc_B1FC4:
        xor al, al
loc_B1FC6:
        mov byte [byte ebp-0Ch], al
        pushfw
        cli
        call GusEnterCritical
loc_B1FD1:
        test ebx, ebx
        je near loc_B2067
        xor eax, eax
        mov edx, 44h
        mov ax, word [word_D8772]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-014h]
        mov ax, word [word_D8776]
        call outp_
        inc byte [byte ebp-014h]
loc_B2000:
        xor eax, eax
        mov edx, 43h
        mov ax, word [word_D8772]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [word_D8774]
        mov dx, cx
        inc esi
        call outpw_
        mov ah, byte [byte ebp-0Ch]
        mov dl, byte [byte ebp-08h]
        mov al, byte [byte esi-01h]
        inc ecx
        xor ah, al
        test dl, dl
        je short loc_B2043
        cmp byte [byte ebp-010h], 0
        je short loc_B203D
        mov al, ah
loc_B203D:
        xor byte [byte ebp-010h], 1
        jmp short loc_B2045
loc_B2043:
        mov al, ah
loc_B2045:
        xor edx, edx
        mov dl, al
        xor eax, eax
        mov ax, word [word_D8778]
        call outp_
        dec ebx
        je near loc_B1FD1
        test cx, cx
        jne short loc_B2000
        jmp near loc_B1FD1
loc_B2067:
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-04h]
        pop esi
        pop ebp
        ret
GusTestDramBank:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 18h
        mov ebx, eax
        mov ecx, eax
        call sub_B1EA0
        xor cl, 20h
        mov byte [byte ebp-028h], al
        mov byte [byte ebp-01Ch], al
        mov eax, ecx
        mov edx, 55h
        call sub_B1EA0
        mov byte [byte ebp-020h], al
        mov byte [byte ebp-018h], al
        mov eax, ebx
        call sub_B1F1C
        mov eax, ecx
        xor edx, edx
        call sub_B1F1C
        mov eax, ebx
        call sub_B1EA0
        cmp al, 55h
        je short loc_B20C5
        xor al, al
        jmp near loc_B2214
loc_B20C5:
        mov eax, ebx
        xor edx, edx
        call sub_B1F1C
        mov edx, 55h
        mov eax, ecx
        call sub_B1F1C
        mov eax, ebx
        call sub_B1EA0
        test al, al
        je short loc_B20F1
        xor al, al
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
loc_B20F1:
        mov edx, 0AAh
        mov eax, ebx
        call sub_B1F1C
        mov eax, ecx
        xor edx, edx
        call sub_B1F1C
        mov eax, ebx
        call sub_B1EA0
        cmp al, 0AAh
        je short loc_B211D
        xor al, al
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
loc_B211D:
        mov edx, 0FFh
        mov eax, ebx
        call sub_B1F1C
        mov eax, ecx
        xor edx, edx
        call sub_B1F1C
        mov eax, ebx
        call sub_B1EA0
        cmp al, 0FFh
        je short loc_B2149
        xor al, al
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
loc_B2149:
        cmp ebx, 3FFFFh
        ja short loc_B2175
        xor edx, edx
        mov eax, ebx
        mov dl, byte [byte ebp-028h]
        call sub_B1F1C
        xor edx, edx
        mov eax, ecx
        mov dl, byte [byte ebp-020h]
        call sub_B1F1C
        mov al, 1
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
loc_B2175:
        mov edx, ebx
        shr edx, 12h
        xor edi, edi
        mov dword [byte ebp-02Ch], edx
        jmp short loc_B21F4
loc_B2181:
        cmp di, word [byte ebp-02Ch]
        je short loc_B21FA
        xor edx, edx
        mov esi, ebx
        mov dx, di
        and esi, 3FFFFh
        shl edx, 12h
        or esi, edx
        mov eax, esi
        mov edx, 0AAh
        call sub_B1EA0
        mov byte [byte ebp-024h], al
        mov eax, esi
        call sub_B1F1C
        mov eax, ecx
        xor edx, edx
        call sub_B1F1C
        mov eax, ebx
        call sub_B1EA0
        cmp al, 0AAh
        jne short loc_B21E7
        xor edx, edx
        mov eax, ebx
        mov dl, byte [byte ebp-01Ch]
        call sub_B1F1C
        xor edx, edx
        mov eax, ecx
        mov dl, byte [byte ebp-018h]
        call sub_B1F1C
        xor al, al
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
loc_B21E7:
        xor edx, edx
        mov eax, esi
        mov dl, byte [byte ebp-024h]
        inc edi
        call sub_B1F1C
loc_B21F4:
        cmp di, byte 4
        jne short loc_B2181
loc_B21FA:
        xor edx, edx
        mov eax, ebx
        mov dl, byte [byte ebp-01Ch]
        call sub_B1F1C
        xor edx, edx
        mov eax, ecx
        mov dl, byte [byte ebp-018h]
        call sub_B1F1C
        mov al, 2
loc_B2214:
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h,00h
