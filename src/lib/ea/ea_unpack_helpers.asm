; RefPack unpack.
bits 32
%include "hockey.inc"
section s_A2F40 progbits alloc exec nowrite align=1
extern _FtoS_, byte_D42E4, KeyedDraw, RowCopyFunc, forcedecpt_, ShapeBankCount, ShapeBankEntry, ShapeBankEntryId
extern PutBlock, sub_B01B0, sub_B026C, bcopy, BlitBlockShadow
global sub_A2F40, loc_A2F61, sub_A2F84, sub_A2FD0, loc_A3006, loc_A3015, loc_A3024, loc_A302C
global sub_A3050, loc_A308C, loc_A3092, loc_A30A1, loc_A30AA, _EFG_Format_, sub_A30F8, loc_A3105
global loc_A312B, loc_A312C, loc_A313F, loc_A3172, loc_A317C, loc_A3189, loc_A3196, loc_A3199
global loc_A319E, loc_A31BF, loc_A31EE, loc_A31F2, loc_A31FA, loc_A3210
sub_A2F40:
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short loc_A2F61
        push eax
        push ebx
        push edx
        call BlitBlockShadow
        add esp, byte 0Ch
        ret
loc_A2F61:
        mov dword [RowCopyFunc], sub_B01B0
        push eax
        push ebx
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov dword [RowCopyFunc], bcopy
        ret
        db 08Dh,040h,00h
sub_A2F84:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call sub_A2F40
        add esp, byte 0Ch
        ret
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+08h]
        sar eax, 10h
        mov ebx, dword [byte esp+0Ch]
        sub ebx, eax
        push ebx
        mov eax, dword [byte edx+06h]
        sar eax, 10h
        mov ebx, dword [byte esp+0Ch]
        sub ebx, eax
        push ebx
        push edx
        call sub_A2F40
        add esp, byte 0Ch
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h
sub_A2FD0:
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov eax, dword [byte esp+018h]
        mov eax, dword [byte eax+02h]
        sar eax, 10h
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esp+018h]
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        mov dword [esp], eax
        mov eax, dword [byte esp+018h]
        add eax, byte 10h
        xor edi, edi
        cmp dword [esp], byte 0
        jle short loc_A302C
        mov esi, dword [byte esp+04h]
        sar esi, 1
loc_A3006:
        mov ebp, dword [byte esp+04h]
        add ebp, eax
        lea edx, [byte ebp-01h]
        xor ebx, ebx
        test esi, esi
        jle short loc_A3024
loc_A3015:
        mov cl, byte [eax]
        mov ch, byte [edx]
        mov byte [eax], ch
        mov byte [edx], cl
        inc eax
        dec edx
        inc ebx
        cmp ebx, esi
        jl short loc_A3015
loc_A3024:
        mov eax, ebp
        inc edi
        cmp edi, dword [esp]
        jl short loc_A3006
loc_A302C:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+018h]
        mov bx, word [byte edx+08h]
        sub eax, ebx
        mov word [byte edx+08h], ax
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
sub_A3050:
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, dword [byte esp+018h]
        mov esi, dword [byte esi+02h]
        sar esi, 10h
        mov eax, dword [byte esp+018h]
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        mov dword [esp], eax
        mov edx, dword [byte esp+018h]
        add edx, byte 10h
        dec eax
        imul eax, esi
        add eax, edx
        xor edi, edi
        lea ebx, [esi+esi]
        mov dword [byte esp+04h], ebx
        mov ebp, dword [esp]
        sar ebp, 1
        test ebp, ebp
        jle short loc_A30AA
loc_A308C:
        xor ebx, ebx
        test esi, esi
        jle short loc_A30A1
loc_A3092:
        mov cl, byte [edx]
        mov ch, byte [eax]
        mov byte [edx], ch
        mov byte [eax], cl
        inc edx
        inc eax
        inc ebx
        cmp ebx, esi
        jl short loc_A3092
loc_A30A1:
        sub eax, dword [byte esp+04h]
        inc edi
        cmp edi, ebp
        jl short loc_A308C
loc_A30AA:
        mov eax, dword [esp]
        mov edx, dword [byte esp+018h]
        mov bx, word [byte edx+0Ah]
        sub eax, ebx
        mov word [byte edx+0Ah], ax
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
_EFG_Format_:
        mov ebx, dword [byte esp+04h]
        mov edx, dword [byte ebx+02h]
        sar edx, 10h
        mov eax, dword [byte ebx+04h]
        sar eax, 10h
        imul eax, edx
        push eax
        push byte_D42E4
        lea eax, [byte ebx+010h]
        push eax
        call sub_B026C
        add esp, byte 0Ch
        ret
        db 08Bh,0C0h
sub_A30F8:
        push esi
        push edi
        sub esp, byte 8
        mov edi, dword [byte esp+014h]
        xor esi, esi
        jmp short loc_A312C
loc_A3105:
        mov eax, esp
        push eax
        push esi
        push edi
        call ShapeBankEntryId
        add esp, byte 0Ch
        cmp byte [esp], 21h
        je short loc_A312B
        push esi
        push edi
        call ShapeBankEntry
        add esp, byte 8
        push eax
        call _EFG_Format_
        add esp, byte 4
loc_A312B:
        inc esi
loc_A312C:
        push edi
        call ShapeBankCount
        add esp, byte 4
        cmp esi, eax
        jl short loc_A3105
        add esp, byte 8
        pop edi
        pop esi
        ret
loc_A313F:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov esi, eax
        mov edi, ebx
        mov dword [byte ebx+0Ch], 0
        mov word [byte esp+08h], ds
        mov cl, byte [byte edi+015h]
        xor ebx, ebx
        cmp cl, 47h
        jb short loc_A317C
        jbe short loc_A3189
        cmp cl, 66h
        jb short loc_A3172
        jbe short loc_A319E
        cmp cl, 67h
        je short loc_A3189
        jmp near loc_A3210
loc_A3172:
        cmp cl, 65h
        je short loc_A3199
        jmp near loc_A3210
loc_A317C:
        cmp cl, 45h
        jb near loc_A3210
        jbe short loc_A3199
        jmp short loc_A319E
loc_A3189:
        cmp dword [byte edi+08h], byte 0
        jne short loc_A3196
        mov dword [byte edi+08h], 1
loc_A3196:
        sub cl, 2
loc_A3199:
        mov ebx, 1
loc_A319E:
        mov ebp, dword [edx]
        add ebp, byte 8
        mov dword [edx], ebp
        mov eax, dword [byte ebp-08h]
        mov dword [esp], eax
        mov eax, dword [byte ebp-04h]
        mov dword [byte esp+04h], eax
        cmp dword [byte edi+08h], byte 0FFFFFFFFh
        jne short loc_A31BF
        mov dword [byte edi+08h], 6
loc_A31BF:
        mov al, byte [byte edi+015h]
        and al, 5Fh
        and eax, 0FFh
        push eax
        xor eax, eax
        mov al, cl
        push eax
        push byte 3
        push ebx
        lea edx, [byte esp+010h]
        xor ecx, ecx
        push byte 27h
        mov eax, esi
        mov ebx, dword [byte edi+08h]
        call _FtoS_
        mov ah, byte [esi]
        cmp ah, 2Ah
        jne short loc_A31EE
        mov byte [byte edi+016h], ah
loc_A31EE:
        mov byte [byte esi+027h], 0
loc_A31F2:
        cmp byte [esi], 20h
        jne short loc_A31FA
        inc esi
        jmp short loc_A31F2
loc_A31FA:
        mov eax, esi
        mov edx, edi
        call forcedecpt_
        mov word [byte esp+08h], ds
        mov eax, esi
        mov dword [byte edi+08h], 0FFFFFFFFh
loc_A3210:
        mov edx, dword [byte esp+08h]
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
