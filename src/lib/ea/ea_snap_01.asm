; Taking a snapshot of the screen.
bits 32
%include "hockey.inc"
section s_9D090 progbits alloc exec nowrite align=1
extern _os_handle, str_SHAPE2, str_Snap, str_Pal31, str_Snap2, SnapFormat, ScreenWidth, ScreenHeight
extern DrawRowBytes, SnapShapeSizes, SnapFileExts, SnapShapeTags, SetDrawBitmap, strncpy_, AllocMemHandle, PushMemDescriptorLocked
extern MemDescPtr, SetPalette, DrawShapeAtOwnPos, WriteFileQuiet, FindShape, SaveDrawState, RestoreDrawState, SetScreenTarget
global SnapScreenToShape, SelectBitmap
;-----------------------------------------------------------------------------
; SnapScreenToShape                               9D090  95 PC, low confidence
; Copies the screen into a new shape for the screenshot file
;-----------------------------------------------------------------------------
SnapScreenToShape:
        push esi
        push edi
        push ebp
        sub esp, 0BCh
        mov edi, dword [dword esp+0CCh]
        xor ebp, ebp
        cmp dword [SnapFormat], byte 7
        jne short .1
        mov ebp, 1
.1:
        mov eax, esp
        push eax
        call SaveDrawState
        add esp, byte 4
        call SetScreenTarget
        mov eax, dword [DrawRowBytes]
        imul eax, dword [ScreenHeight]
        cmp dword [SnapFormat], byte 7
        jne short .2
        add eax, eax
.2:
        add eax, 340h
        mov dword [dword esp+0B8h], eax
        xor esi, esi
        push byte 20h
        push eax
        push str_SHAPE2
        call AllocMemHandle
        add esp, byte 0Ch
        mov dword [dword esp+0B4h], eax
        test eax, eax
        je near .11
        push eax
        call MemDescPtr
        mov esi, eax
        add esp, byte 4
        mov dword [dword esp+0B0h], eax
        shl ebp, 2
        mov edx, dword [dword ebp+SnapShapeTags]
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
        mov edx, dword [dword ebp+SnapShapeSizes]
        and edx, 0FFh
        mov byte [eax], 0
        mov ebx, dword [eax]
        or ebx, edx
        mov ecx, ebx
        and ecx, 0FFh
        mov dword [eax], ecx
        mov dx, word [ScreenWidth]
        mov word [byte eax+04h], dx
        mov dx, word [ScreenHeight]
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
.3:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je short .4
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short .3
.4:
        pop edi
        mov dl, 2Eh
        lea esi, [byte esp+060h]
.5:
        mov al, byte [esi]
        LD cmp, al, dl
        je short .7
        cmp al, 0
        je short .6
        inc esi
        mov al, byte [esi]
        LD cmp, al, dl
        je short .7
        inc esi
        cmp al, 0
        jne short .5
.6:
        LD sub, esi, esi
.7:
        test esi, esi
        jne short .10
        mov esi, dword [dword ebp+SnapFileExts]
        lea edi, [byte esp+060h]
        push edi
        LD sub, ecx, ecx
        dec ecx
        mov al, 0
        repne scasb
        dec edi
.8:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je short .9
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short .8
.9:
        pop edi
.10:
        mov esi, dword [dword esp+0B8h]
        push esi
        mov edi, dword [dword esp+0B4h]
        push edi
        lea eax, [byte esp+068h]
        push eax
        call WriteFileQuiet
        add esp, byte 0Ch
        mov esi, eax
        mov ebp, dword [dword esp+0B4h]
        push ebp
        call PushMemDescriptorLocked
        add esp, byte 4
.11:
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
;-----------------------------------------------------------------------------
; SelectBitmap                                    9D2E0  95 PC, low confidence
; Points a bitmap at its pixel data and makes it the draw target
;-----------------------------------------------------------------------------
SelectBitmap:
        push esi
        mov esi, dword [byte esp+08h]
        mov esi, dword [esi]
        test esi, esi
        je short .1
        lea eax, [byte esi+030h]
        push eax
        call _os_handle
        add esp, byte 4
        mov dword [byte esi+02Ch], eax
        push esi
        call SetDrawBitmap
        add esp, byte 4
.1:
        mov eax, esi
        pop esi
        ret
