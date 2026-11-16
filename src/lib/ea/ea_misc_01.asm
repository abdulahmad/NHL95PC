; Small helpers from the EA libraries.
bits 32
%include "hockey.inc"
section s_9B498 progbits alloc exec nowrite align=1
extern KeyedDraw, FillRect, PlotPixel, FillRectSpansCore, unk_9B470
global FillRectSpans, loc_9B4B9, loc_9B544, loc_9B565, loc_9B589, loc_9B58C, loc_9B5A9, loc_9B5AC
global loc_9B5C9, loc_9B5E1, loc_9B61A, loc_9B632, loc_9B66B, loc_9B67E, loc_9B6B3, loc_9B6C6
global loc_9B6F7, loc_9B706
FillRectSpans:
        push esi
        push edi
        push ebp
        sub esp, byte 2Ch
        mov eax, dword [byte esp+03Ch]
        cmp dword [KeyedDraw], byte 0
        jne short loc_9B4B9
        push eax
        call FillRectSpansCore
        add esp, byte 4
        jmp near loc_9B706
loc_9B4B9:
        mov edx, dword [byte eax+04h]
        shl edx, 10h
        mov ebx, dword [eax]
        sar ebx, 10h
        and ebx, 0FFFFh
        add edx, ebx
        add edx, 8000h
        mov dword [byte esp+04h], edx
        mov ebx, dword [byte eax+08h]
        sar ebx, 10h
        and ebx, 0FFFFh
        mov edx, dword [byte eax+0Ch]
        shl edx, 10h
        add edx, ebx
        lea ebx, [dword edx+08000h]
        mov edi, dword [byte esp+04h]
        sar edi, 10h
        and edi, 0FFFFh
        mov ebp, ebx
        sar ebp, 10h
        and ebp, 0FFFFh
        mov edx, dword [byte eax+01Ch]
        mov dword [byte esp+028h], edx
        mov esi, dword [byte eax+018h]
        mov dl, byte [byte eax+034h]
        cmp dl, 9
        ja near loc_9B706
        and edx, 0FFh
        shl edx, 2
        mov dword [esp], edx
        mov edx, dword [byte esp+04h]
        and edx, 0FFFFh
        and ebx, 0FFFFh
        mov ecx, dword [esp]
        jmp dword [dword cs:ecx+unk_9B470]
loc_9B544:
        test esi, esi
        je near loc_9B706
        mov eax, dword [byte esp+028h]
        push eax
        push byte 1
        push esi
        push ebp
        push edi
        call FillRect
        add esp, byte 14h
        add esp, byte 2Ch
        pop ebp
        pop edi
        pop esi
        ret
loc_9B565:
        mov eax, dword [byte eax+0Ch]
        test esi, esi
        je near loc_9B706
        mov ecx, dword [byte esp+028h]
        push ecx
        push esi
        push byte 1
        push eax
        push edi
        call FillRect
        add esp, byte 14h
        add esp, byte 2Ch
        pop ebp
        pop edi
        pop esi
        ret
loc_9B589:
        mov ebp, dword [byte eax+0Ch]
loc_9B58C:
        dec esi
        cmp esi, byte 0FFFFFFFFh
        je near loc_9B706
        mov ecx, dword [byte esp+028h]
        push ecx
        push ebp
        push edi
        inc ebp
        dec edi
        call PlotPixel
        add esp, byte 0Ch
        jmp short loc_9B58C
loc_9B5A9:
        mov ebp, dword [byte eax+0Ch]
loc_9B5AC:
        dec esi
        cmp esi, byte 0FFFFFFFFh
        je near loc_9B706
        mov ebx, dword [byte esp+028h]
        push ebx
        push ebp
        push edi
        inc ebp
        inc edi
        call PlotPixel
        add esp, byte 0Ch
        jmp short loc_9B5AC
loc_9B5C9:
        mov ebx, dword [byte eax+0Ch]
        mov dword [byte esp+018h], ebx
        mov eax, dword [byte eax+030h]
        shr eax, 10h
        and eax, 0FFFFh
        mov dword [byte esp+014h], eax
        mov ebp, edx
loc_9B5E1:
        dec esi
        cmp esi, byte 0FFFFFFFFh
        je near loc_9B706
        mov ebx, dword [byte esp+028h]
        push ebx
        mov ecx, dword [byte esp+01Ch]
        push ecx
        push edi
        lea eax, [byte ecx+01h]
        mov dword [byte esp+024h], eax
        call PlotPixel
        add esp, byte 0Ch
        add ebp, dword [byte esp+014h]
        test ebp, 0FFFF0000h
        je short loc_9B5E1
        and ebp, 0FFFFh
        dec edi
        jmp short loc_9B5E1
loc_9B61A:
        mov ebx, dword [byte eax+0Ch]
        mov dword [byte esp+01Ch], ebx
        mov eax, dword [byte eax+030h]
        shr eax, 10h
        and eax, 0FFFFh
        mov dword [byte esp+08h], eax
        mov ebp, edx
loc_9B632:
        dec esi
        cmp esi, byte 0FFFFFFFFh
        je near loc_9B706
        mov ebx, dword [byte esp+028h]
        push ebx
        mov ecx, dword [byte esp+020h]
        push ecx
        push edi
        lea eax, [byte ecx+01h]
        mov dword [byte esp+028h], eax
        call PlotPixel
        add esp, byte 0Ch
        add ebp, dword [byte esp+08h]
        test ebp, 0FFFF0000h
        je short loc_9B632
        and ebp, 0FFFFh
        inc edi
        jmp short loc_9B632
loc_9B66B:
        mov eax, dword [byte eax+030h]
        shr eax, 10h
        and eax, 0FFFFh
        mov dword [byte esp+010h], eax
        mov dword [byte esp+020h], ebx
loc_9B67E:
        dec esi
        cmp esi, byte 0FFFFFFFFh
        je near loc_9B706
        mov ecx, dword [byte esp+028h]
        push ecx
        push ebp
        push edi
        call PlotPixel
        add esp, byte 0Ch
        dec edi
        mov eax, dword [byte esp+010h]
        add dword [byte esp+020h], eax
        test word [byte esp+022h], 0FFFFh
        je short loc_9B67E
        xor eax, eax
        mov word [byte esp+022h], ax
        inc ebp
        jmp short loc_9B67E
loc_9B6B3:
        mov eax, dword [byte eax+030h]
        shr eax, 10h
        and eax, 0FFFFh
        mov dword [byte esp+0Ch], eax
        mov dword [byte esp+024h], ebx
loc_9B6C6:
        dec esi
        cmp esi, byte 0FFFFFFFFh
        je short loc_9B706
        mov edx, dword [byte esp+028h]
        push edx
        push ebp
        push edi
        call PlotPixel
        add esp, byte 0Ch
        inc edi
        mov eax, dword [byte esp+0Ch]
        add dword [byte esp+024h], eax
        test word [byte esp+026h], 0FFFFh
        je short loc_9B6C6
        xor ebx, ebx
        mov word [byte esp+026h], bx
        inc ebp
        jmp short loc_9B6C6
loc_9B6F7:
        mov ebx, dword [byte esp+028h]
        push ebx
        push ebp
        push edi
        call PlotPixel
        add esp, byte 0Ch
loc_9B706:
        add esp, byte 2Ch
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h
