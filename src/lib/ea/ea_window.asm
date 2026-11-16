; On-screen windows.
bits 32
%include "hockey.inc"
section s_8E7A0 progbits alloc exec nowrite align=1
extern str_SUBWINDOW, str_SubwindowdefadrOUTOFROW, byte_D42C0, byte_D42C1, byte_D42C2, byte_D42C3, byte_D42C4, byte_D42C5
extern byte_D42C6, dword_D42AC, dword_D42B0, dword_D42B4, dword_D42B8, dword_D42BC, dword_D42C8, dword_D42CC
extern dword_D42D0, dword_D42D4, dword_D42D8, dword_D42DC, dword_D42E0, FatalError, fontcolor, off_D42A4
extern AllocMemBlock, AllocMemBlockEx, FindCachedFile, FillRowTable, LoadFileCached, DosOpenFile, DosCloseFile, DosReadFile
extern ZeroMem
global subwindowdefadr, loc_8E816, sub_8E81C, loc_8E82B, LoadBank, loc_8E853, loc_8E868, sub_8E86A
global unk_8E870, sub_8E8A0, sub_8E8B8, sub_8E8D0, loc_8E8ED, sub_8E8F0, sub_8E908, LoadDataFileExt
global loc_8E963, loc_8E991, loc_8E9B4, TextSetColors, sub_8E9D4, TextSaveState, TextRestoreState, TextSetFont
global loc_8EA81, loc_8EA83, loc_8EA98, loc_8EAAA, loc_8EABF, loc_8EAD1
subwindowdefadr:
        push esi
        push edi
        push ebp
        mov ebp, dword [byte esp+010h]
        push byte 0
        push byte 30h
        push str_SUBWINDOW
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        mov edi, eax
        push byte 30h
        push eax
        call ZeroMem
        add esp, byte 8
        mov eax, dword [byte esp+01Ch]
        mov dword [byte esi+020h], eax
        mov dword [byte esi+010h], eax
        mov dword [byte esi+01Ch], eax
        mov eax, dword [byte esp+020h]
        mov dword [byte esi+04h], eax
        mov dword [byte esi+014h], eax
        mov eax, dword [byte ebp+00h]
        mov dword [esi], eax
        mov eax, dword [byte ebp+02Ch]
        mov dword [byte esi+02Ch], eax
        mov edx, dword [byte esp+018h]
        mov eax, dword [byte ebp+028h]
        mov eax, dword [eax+edx*4]
        add eax, dword [byte esp+014h]
        mov edx, dword [esi]
        mov ebx, dword [byte esp+020h]
        call FillRowTable
        mov dword [byte esi+028h], eax
        test eax, eax
        jne short loc_8E816
        push str_SubwindowdefadrOUTOFROW
        call FatalError
        add esp, byte 4
loc_8E816:
        mov eax, edi
        pop ebp
        pop edi
        pop esi
        ret
sub_8E81C:
        push ebp
        LD mov, ebp, esp
        LD xor, eax, eax
        jmp short loc_8E82B
        push ebp
        LD mov, ebp, esp
        mov eax, 1
loc_8E82B:
        push eax
        push dword [byte ebp+0Ch]
        db 0FFh,075h,08h                        ; insn: push dword [ebp+8]
        db 0E8h                                 ; insn: call 00098E50h
        dd LoadFileCached-$-4
        add esp, byte 0Ch
        leave
        ret
LoadBank:
        push ebp
        LD mov, ebp, esp
        mov eax, 1
        jmp short loc_8E853
        push ebp
        LD mov, ebp, esp
        LD xor, eax, eax
        jmp short loc_8E853
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+010h]
loc_8E853:
        push eax
        push dword [byte ebp+0Ch]
        push dword [byte ebp+08h]
        call LoadFileCached
        add esp, byte 0Ch
        LD or, eax, eax
        je short loc_8E868
        mov eax, dword [eax]
loc_8E868:
        leave
        ret
sub_8E86A:
        jmp near LoadFileCached
        db 00h
unk_8E870:
        db 06Ch,06Fh,063h,061h,074h,065h,073h,068h,061h,070h,065h,020h,02Dh,020h,027h,025h
        db 02Dh,034h,02Eh,034h,073h,027h,020h,053h,048h,041h,050h,045h,020h,04Eh,04Fh,054h
        db 020h,046h,04Fh,055h,04Eh,044h,0Dh,0Ah,00h,00h,00h,00h,00h,00h,00h,00h
sub_8E8A0:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call sub_8E8D0
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
sub_8E8B8:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call sub_8E8D0
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
sub_8E8D0:
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        mov ecx, dword [byte esp+0Ch]
        push ecx
        call LoadDataFileExt
        add esp, byte 0Ch
        test eax, eax
        je short loc_8E8ED
        mov eax, dword [eax]
loc_8E8ED:
        ret
        db 08Bh,0C0h
sub_8E8F0:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call LoadDataFileExt
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
sub_8E908:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call LoadDataFileExt
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
LoadDataFileExt:
        push esi
        push edi
        sub esp, byte 0Ch
        mov esi, dword [byte esp+018h]
        push esi
        call FindCachedFile
        add esp, byte 4
        test eax, eax
        jne near loc_8E9B4
        mov edx, dword [byte esp+020h]
        push edx
        lea eax, [byte esp+0Ch]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        push esi
        call DosOpenFile
        add esp, byte 14h
        mov ebx, dword [byte esp+08h]
        test ebx, ebx
        jne short loc_8E963
        xor eax, eax
        jmp short loc_8E9B4
loc_8E963:
        mov ecx, dword [byte esp+020h]
        push ecx
        mov edi, dword [byte esp+020h]
        push edi
        push ebx
        push esi
        call AllocMemBlockEx
        mov esi, eax
        add esp, byte 10h
        test eax, eax
        jne short loc_8E991
        mov esi, dword [esp]
        push esi
        call DosCloseFile
        add esp, byte 4
        xor eax, eax
        add esp, byte 0Ch
        pop edi
        pop esi
        ret
loc_8E991:
        mov eax, dword [byte esp+08h]
        push eax
        mov edx, dword [esi]
        push edx
        mov ebx, dword [byte esp+08h]
        push ebx
        call DosReadFile
        add esp, byte 0Ch
        mov ecx, dword [esp]
        push ecx
        call DosCloseFile
        add esp, byte 4
        mov eax, esi
loc_8E9B4:
        add esp, byte 0Ch
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h
TextSetColors:
        mov eax, dword [byte esp+04h]
        mov dword [fontcolor], eax
        mov eax, dword [byte esp+08h]
        mov dword [dword_D42AC], eax
        ret
        db 090h
sub_8E9D4:
        mov eax, dword [byte esp+04h]
        mov dword [dword_D42B0], eax
        mov eax, dword [byte esp+08h]
        mov dword [dword_D42B4], eax
        ret
        db 090h
TextSaveState:
        push esi
        push edi
        mov ecx, 10h
        mov edi, dword [byte esp+0Ch]
        mov esi, off_D42A4
        rep movsd
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
TextRestoreState:
        push esi
        push edi
        mov ecx, 10h
        mov edi, off_D42A4
        mov esi, dword [byte esp+0Ch]
        rep movsd
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
TextSetFont:
        mov edx, dword [byte esp+04h]
        mov eax, edx
        mov dword [off_D42A4], edx
        mov ebx, dword [edx]
        mov dword [dword_D42BC], ebx
        mov bl, byte [byte edx+04h]
        mov byte [byte_D42C0], bl
        mov bl, byte [byte edx+05h]
        mov byte [byte_D42C1], bl
        mov bl, byte [byte edx+06h]
        mov byte [byte_D42C2], bl
        mov bl, byte [byte edx+07h]
        mov byte [byte_D42C3], bl
        mov bl, byte [byte edx+08h]
        mov byte [byte_D42C4], bl
        mov bl, byte [byte edx+09h]
        mov byte [byte_D42C5], bl
        mov bl, byte [byte edx+0Ah]
        mov byte [byte_D42C6], bl
        xor ebx, ebx
        mov dword [dword_D42B8], ebx
        mov ebx, dword [byte edx+010h]
        sar ebx, 10h
        test ebx, ebx
        je short loc_8EA81
        add edx, ebx
        jmp short loc_8EA83
loc_8EA81:
        xor edx, edx
loc_8EA83:
        mov dword [dword_D42C8], edx
        mov edx, dword [byte eax+014h]
        shl edx, 10h
        sar edx, 10h
        test edx, edx
        je short loc_8EA98
        add edx, eax
loc_8EA98:
        mov dword [dword_D42CC], edx
        mov edx, dword [byte eax+014h]
        sar edx, 10h
        test edx, edx
        je short loc_8EAAA
        add edx, eax
loc_8EAAA:
        mov dword [dword_D42D0], edx
        mov edx, dword [byte eax+018h]
        shl edx, 10h
        sar edx, 10h
        test edx, edx
        je short loc_8EABF
        add edx, eax
loc_8EABF:
        mov dword [dword_D42D4], edx
        mov edx, dword [byte eax+018h]
        sar edx, 10h
        test edx, edx
        je short loc_8EAD1
        add edx, eax
loc_8EAD1:
        mov dword [dword_D42D8], edx
        mov edx, dword [byte eax+01Ch]
        lea ebx, [eax+edx]
        mov dword [dword_D42DC], ebx
        add eax, byte 20h
        mov dword [dword_D42E0], eax
        ret
