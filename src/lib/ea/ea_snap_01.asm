; Taking a snapshot of the screen.
bits 32
%include "hockey.inc"
section s_9D090 progbits alloc exec nowrite align=1
extern _os_handle, str_SHAPE2, str_Snap, str_Pal31, str_Snap2, dword_D2F84, ScreenWidth, dword_D30A8
extern DrawRowBytes, dword_D5184, off_D517C, off_D518C, SetDrawBitmap, strncpy_, sub_8CC8C, PushMemDescriptorLocked
extern sub_8DBD4, SetPalette, DrawShapeAtOwnPos, sub_932EC, FindShape, SaveDrawState, RestoreDrawState, SetScreenTarget
global sub_9D090, loc_9D0B0, loc_9D0D7, loc_9D232, loc_9D24A, loc_9D251, loc_9D267, loc_9D269
global loc_9D280, loc_9D298, loc_9D299, loc_9D2C8, sub_9D2E0, loc_9D303
sub_9D090:
        push esi
        push edi
        push ebp
        sub esp, 0BCh
        mov edi, dword [dword esp+0CCh]
        xor ebp, ebp
        cmp dword [dword_D2F84], byte 7
        jne short loc_9D0B0
        mov ebp, 1
loc_9D0B0:
        mov eax, esp
        push eax
        call SaveDrawState
        add esp, byte 4
        call SetScreenTarget
        mov eax, dword [DrawRowBytes]
        imul eax, dword [dword_D30A8]
        cmp dword [dword_D2F84], byte 7
        jne short loc_9D0D7
        add eax, eax
loc_9D0D7:
        add eax, 340h
        mov dword [dword esp+0B8h], eax
        xor esi, esi
        push byte 20h
        push eax
        push str_SHAPE2
        call sub_8CC8C
        add esp, byte 0Ch
        mov dword [dword esp+0B4h], eax
        test eax, eax
        je near loc_9D2C8
        push eax
        call sub_8DBD4
        mov esi, eax
        add esp, byte 4
        mov dword [dword esp+0B0h], eax
        shl ebp, 2
        mov edx, dword [dword ebp+off_D518C]
        mov ebx, 4
        call strncpy_
        mov eax, dword [dword esp+0B8h]
        mov dword [byte esi+04h], eax
        mov dword [byte esi+08h], 2
        lea eax, [byte esi+0Ch]
        mov ebx, 4
        mov edx, str_Snap
        call strncpy_
        lea eax, [byte esi+010h]
        mov ebx, 4
        mov edx, str_Pal31
        call strncpy_
        mov dword [byte esi+014h], 20h
        lea eax, [byte esi+018h]
        mov ebx, 4
        mov edx, str_Snap2
        call strncpy_
        mov dword [byte esi+01Ch], 330h
        push str_Pal31
        push esi
        call FindShape
        add esp, byte 8
        mov dword [eax], 22h
        mov word [byte eax+04h], 100h
        mov word [byte eax+06h], 3
        mov word [byte eax+08h], 100h
        mov word [byte eax+0Ah], 0
        mov word [byte eax+0Ch], 0
        mov word [byte eax+0Eh], 0
        add eax, byte 10h
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push str_Snap2
        push esi
        call FindShape
        add esp, byte 8
        mov edx, dword [dword ebp+dword_D5184]
        and edx, 0FFh
        mov byte [eax], 0
        mov ebx, dword [eax]
        or ebx, edx
        mov ecx, ebx
        and ecx, 0FFh
        mov dword [eax], ecx
        mov dx, word [ScreenWidth]
        mov word [byte eax+04h], dx
        mov dx, word [dword_D30A8]
        mov word [byte eax+06h], dx
        mov word [byte eax+08h], 0
        mov word [byte eax+0Ah], 0
        mov word [byte eax+0Ch], 0
        mov word [byte eax+0Eh], 0
        push eax
        call DrawShapeAtOwnPos
        add esp, byte 4
        mov esi, edi
        lea edi, [byte esp+060h]
        push edi
loc_9D232:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je short loc_9D24A
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short loc_9D232
loc_9D24A:
        pop edi
        mov dl, 2Eh
        lea esi, [byte esp+060h]
loc_9D251:
        mov al, byte [esi]
        LD cmp, al, dl
        je short loc_9D269
        cmp al, 0
        je short loc_9D267
        inc esi
        mov al, byte [esi]
        LD cmp, al, dl
        je short loc_9D269
        inc esi
        cmp al, 0
        jne short loc_9D251
loc_9D267:
        LD sub, esi, esi
loc_9D269:
        test esi, esi
        jne short loc_9D299
        mov esi, dword [dword ebp+off_D517C]
        lea edi, [byte esp+060h]
        push edi
        LD sub, ecx, ecx
        dec ecx
        mov al, 0
        repne scasb
        dec edi
loc_9D280:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je short loc_9D298
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short loc_9D280
loc_9D298:
        pop edi
loc_9D299:
        mov esi, dword [dword esp+0B8h]
        push esi
        mov edi, dword [dword esp+0B4h]
        push edi
        lea eax, [byte esp+068h]
        push eax
        call sub_932EC
        add esp, byte 0Ch
        mov esi, eax
        mov ebp, dword [dword esp+0B4h]
        push ebp
        call PushMemDescriptorLocked
        add esp, byte 4
loc_9D2C8:
        mov eax, esp
        push eax
        call RestoreDrawState
        add esp, byte 4
        mov eax, esi
        add esp, 0BCh
        pop ebp
        pop edi
        pop esi
        ret
        db 00h
sub_9D2E0:
        push esi
        mov esi, dword [byte esp+08h]
        mov esi, dword [esi]
        test esi, esi
        je short loc_9D303
        lea eax, [byte esi+030h]
        push eax
        call _os_handle
        add esp, byte 4
        mov dword [byte esi+02Ch], eax
        push esi
        call SetDrawBitmap
        add esp, byte 4
loc_9D303:
        mov eax, esi
        pop esi
        ret
