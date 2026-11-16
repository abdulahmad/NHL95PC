; Playing an MVI movie.
bits 32
%include "hockey.inc"
section s_96440 progbits alloc exec nowrite align=1
extern _os_handle_3, str_FrameRate3dFrames, str_Width3dHeight3d, str_Colours3d1stColour, str_Mvipal, str_DATABUFFER, cliprect_x0, cliprect_x1
extern cliprect_y0, cliprect_y1, DebugPrintf, ScreenWidth, KeyedDraw, DrawVideoBase, ScreenRowTable, FreeMemBlock
extern AllocMemHandleLocked, AllocMemBlock, AllocMemBlockUnlocked, PushMemDescriptorLocked, MemDescPtr, LoadDataFileErr, FreeBitmap, SaveDrawState
extern RestoreDrawState, bcopy, openhandle, DosCloseFile, DosReadFile, DosSeekFile, SetScreenTarget, SetClipWindow
extern CreateBitmap, VesaSetBankArg, BlitShapeClipped
global DrawShapeClippedKeyed, DrawShapeClippedKeyedAtOwnPos, MviPrintInfo, MviLoadPalette, MviOpen, MviRewind, MviGetPalette
DrawShapeClippedKeyed:
        push esi
        push edi
        push ebp
        sub esp, byte 1Ch
        mov edx, dword [byte esp+02Ch]
        mov edi, dword [byte esp+030h]
        mov eax, dword [byte esp+034h]
        cmp dword [KeyedDraw], byte 0
        jne short .1
        push eax
        push edi
        push edx
        call BlitShapeClipped
        add esp, byte 0Ch
        jmp near .10
.1:
        mov word [byte edx+0Ch], di
        mov word [byte edx+0Eh], ax
        lea esi, [byte edx+010h]
        mov ebx, dword [byte edx+02h]
        sar ebx, 10h
        mov dword [byte esp+010h], ebx
        mov ebp, dword [byte edx+04h]
        sar ebp, 10h
        mov edx, dword [DrawVideoBase]
        mov dword [byte esp+08h], edx
        xor ecx, ecx
        mov dword [byte esp+04h], ecx
        mov edx, dword [cliprect_y0]
        sub edx, eax
        test edx, edx
        jle short .2
        imul ebx, edx
        add esi, ebx
        sub ebp, edx
        add eax, edx
.2:
        lea edx, [eax+ebp]
        sub edx, dword [cliprect_y1]
        test edx, edx
        jle short .3
        sub ebp, edx
.3:
        mov edx, dword [cliprect_x0]
        sub edx, edi
        test edx, edx
        jle short .4
        add esi, edx
        sub dword [byte esp+010h], edx
        add edi, edx
        add dword [byte esp+04h], edx
.4:
        mov edx, dword [byte esp+010h]
        add edx, edi
        sub edx, dword [cliprect_x1]
        test edx, edx
        jle short .5
        add dword [byte esp+04h], edx
        sub dword [byte esp+010h], edx
.5:
        add edi, dword [nosplit eax*4+ScreenRowTable]
        mov eax, dword [ScreenWidth]
        mov ebx, dword [byte esp+010h]
        sub eax, ebx
        mov dword [esp], eax
        mov eax, edi
        shr eax, 10h
        mov dword [byte esp+018h], eax
        push eax
        call VesaSetBankArg
        add esp, byte 4
        and edi, 0FFFFh
        mov dword [byte esp+0Ch], ebp
        cmp dword [byte esp+010h], byte 0
        jle near .10
.6:
        cmp dword [byte esp+0Ch], byte 0
        jle near .10
        mov eax, dword [byte esp+010h]
        add eax, edi
        mov dword [byte esp+014h], eax
        mov eax, dword [byte esp+08h]
        add eax, edi
        test byte [byte esp+016h], 1
        je short .7
        mov ebp, 10000h
        sub ebp, edi
        push ebp
        push esi
        push eax
        call bcopy
        add esp, byte 0Ch
        add esi, ebp
        mov ebp, dword [byte esp+014h]
        and ebp, 0FFFFh
        mov ecx, dword [byte esp+018h]
        inc ecx
        mov dword [byte esp+018h], ecx
        push ecx
        call VesaSetBankArg
        add esp, byte 4
        push ebp
        push esi
        mov eax, dword [byte esp+010h]
        push eax
        call bcopy
        add esp, byte 0Ch
        mov edi, ebp
        add esi, ebp
        jmp short .8
.7:
        mov edx, dword [byte esp+010h]
        push edx
        push esi
        push eax
        call bcopy
        add esp, byte 0Ch
        mov edi, dword [byte esp+014h]
        add esi, dword [byte esp+010h]
.8:
        add edi, dword [esp]
        add esi, dword [byte esp+04h]
        test edi, 10000h
        je short .9
        and edi, 0FFFFh
        mov ecx, dword [byte esp+018h]
        inc ecx
        mov dword [byte esp+018h], ecx
        push ecx
        call VesaSetBankArg
        add esp, byte 4
.9:
        dec dword [byte esp+0Ch]
        jmp near .6
.10:
        add esp, byte 1Ch
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
DrawShapeClippedKeyedAtOwnPos:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call DrawShapeClippedKeyed
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
        call DrawShapeClippedKeyed
        add esp, byte 0Ch
        ret
        push esi
        push edi
        push ebp
        sub esp, byte 60h
        mov ebp, dword [byte esp+070h]
        mov edi, dword [byte esp+074h]
        mov eax, esp
        push eax
        call SaveDrawState
        add esp, byte 4
        mov esi, dword [DrawVideoBase]
        call SetScreenTarget
        mov eax, dword [dword esp+084h]
        add eax, edi
        push eax
        push edi
        mov eax, dword [dword esp+088h]
        add eax, ebp
        push eax
        push ebp
        call SetClipWindow
        add esp, byte 10h
        mov edx, dword [byte esp+07Ch]
        mov eax, edi
        sub eax, edx
        push eax
        mov ebx, dword [byte esp+07Ch]
        mov eax, ebp
        sub eax, ebx
        push eax
        push esi
        call DrawShapeClippedKeyed
        add esp, byte 0Ch
        mov eax, esp
        push eax
        call RestoreDrawState
        add esp, byte 4
        add esp, byte 60h
        pop ebp
        pop edi
        pop esi
        ret
        db 00h
MviPrintInfo:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov esi, eax
        mov edx, dword [byte eax+020h]
        push edx
        mov ebx, dword [eax]
        push ebx
        mov ecx, dword [byte eax+08h]
        push ecx
        push str_FrameRate3dFrames
        call DebugPrintf
        add esp, byte 10h
        mov edi, dword [byte esi+010h]
        push edi
        mov ebp, dword [byte esi+0Ch]
        push ebp
        push str_Width3dHeight3d
        call DebugPrintf
        add esp, byte 0Ch
        mov eax, dword [byte esi+014h]
        push eax
        mov edx, dword [byte esi+018h]
        push edx
        push str_Colours3d1stColour
        call DebugPrintf
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
MviLoadPalette:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 1Ch
        mov edi, eax
        lea esi, [byte edx+02h]
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte esp+0Ch], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte esp+0Ch], eax
        movzx ebp, byte [esi]
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add ebp, eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte esp+018h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte esp+018h], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte esp+08h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte esp+08h], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte esp+04h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte esp+04h], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte esp+010h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte esp+010h], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte esp+014h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        mov ecx, dword [byte esp+014h]
        add ecx, eax
        mov dword [byte esp+014h], ecx
        push byte 0
        lea eax, [nosplit ecx*4+00h]
        sub eax, ecx
        mov dword [byte esp+04h], eax
        push eax
        push str_Mvipal
        call AllocMemBlock
        add esp, byte 0Ch
        mov edx, edi
        mov dword [byte edx+01Ch], eax
        xor eax, eax
        mov ecx, dword [esp]
        test ecx, ecx
        jle short .2
.1:
        xor edx, edx
        mov dl, byte [esi]
        sar edx, 2
        mov bl, dl
        mov edx, dword [byte edi+01Ch]
        inc esi
        mov byte [edx+eax], bl
        inc eax
        cmp eax, ecx
        jl short .1
.2:
        mov eax, dword [byte esp+010h]
        mov dword [byte edi+014h], eax
        mov eax, dword [byte esp+014h]
        mov dword [byte edi+018h], eax
        mov eax, dword [byte esp+0Ch]
        mov dword [edi], eax
        mov dword [byte edi+04h], 1
        mov eax, dword [byte esp+08h]
        mov dword [byte edi+020h], eax
        mov dword [byte edi+0Ch], ebp
        mov eax, dword [byte esp+018h]
        mov dword [byte edi+010h], eax
        add ecx, byte 10h
        mov dword [byte edi+028h], ecx
        mov dword [byte edi+02Ch], ecx
        mov eax, dword [byte esp+04h]
        mov dword [byte edi+08h], eax
        push byte 0
        mov ebx, dword [byte esp+01Ch]
        push ebx
        push ebp
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [byte edi+034h], eax
        push byte 0
        mov ecx, dword [byte esp+01Ch]
        push ecx
        push ebp
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [byte edi+038h], eax
        push byte 0
        mov esi, dword [byte esp+01Ch]
        push esi
        push ebp
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [byte edi+03Ch], eax
        add esp, byte 1Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
MviOpen:
        push esi
        push edi
        push ebp
        sub esp, 31Ch
        mov ebp, dword [dword esp+032Ch]
        push byte 0
        push byte 40h
        push ebp
        call AllocMemBlockUnlocked
        mov esi, eax
        add esp, byte 0Ch
        mov edi, eax
        test eax, eax
        je near .7
        mov edx, dword [dword esp+0330h]
        cmp edx, byte 1
        je short .1
        test edx, edx
        jne short .4
.1:
        push byte 0
        push ebp
        call LoadDataFileErr
        mov esi, eax
        add esp, byte 8
        test eax, eax
        jne short .2
        cmp dword [dword esp+0330h], byte 0
        je short .3
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        jmp near .7
.2:
        push eax
        call MemDescPtr
        add esp, byte 4
        push eax
        call _os_handle_3
        add esp, byte 4
        mov edx, eax
        mov eax, edi
        call MviLoadPalette
        mov dword [byte edi+030h], esi
        mov dword [byte edi+024h], 0
.3:
        mov eax, edi
        jmp near .7
.4:
        lea eax, [dword esp+0310h]
        push eax
        lea eax, [dword esp+0318h]
        push eax
        lea eax, [dword esp+0320h]
        push eax
        push ebp
        call openhandle
        add esp, byte 10h
        mov ecx, dword [dword esp+0318h]
        test ecx, ecx
        jne short .5
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        add esp, 31Ch
        pop ebp
        pop edi
        pop esi
        ret
.5:
        push dword 310h
        lea eax, [byte esp+04h]
        push eax
        push ecx
        call DosReadFile
        add esp, byte 0Ch
        mov edx, esp
        mov eax, esi
        call MviLoadPalette
        mov eax, dword [dword esp+0318h]
        mov dword [byte esi+024h], eax
        mov eax, dword [dword esp+0314h]
        add dword [byte esi+028h], eax
        push byte 40h
        mov eax, dword [byte esi+0Ch]
        imul eax, dword [byte esi+010h]
        push eax
        push str_DATABUFFER
        call AllocMemHandleLocked
        add esp, byte 0Ch
        mov dword [byte esi+030h], eax
        test eax, eax
        jne short .6
        mov ebp, dword [dword esp+0318h]
        push ebp
        call DosCloseFile
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        add esp, 31Ch
        pop ebp
        pop edi
        pop esi
        ret
.6:
        mov ecx, dword [byte esi+028h]
        push ecx
        mov edi, dword [dword esp+031Ch]
        push edi
        call DosSeekFile
        add esp, byte 8
        mov eax, esi
.7:
        add esp, 31Ch
        pop ebp
        pop edi
        pop esi
        ret
        push esi
        push ebp
        mov eax, dword [byte esp+0Ch]
        mov esi, eax
        test eax, eax
        je short .10
        mov edx, dword [byte eax+024h]
        test edx, edx
        je short .8
        push edx
        call DosCloseFile
        add esp, byte 4
.8:
        mov ecx, dword [byte esi+030h]
        test ecx, ecx
        je short .9
        push ecx
        call PushMemDescriptorLocked
        add esp, byte 4
.9:
        mov ebp, dword [byte esi+034h]
        push ebp
        call FreeBitmap
        add esp, byte 4
        mov eax, dword [byte esi+038h]
        push eax
        call FreeBitmap
        add esp, byte 4
        mov edx, dword [byte esi+03Ch]
        push edx
        call FreeBitmap
        add esp, byte 4
        mov ebx, dword [byte esi+01Ch]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
.10:
        pop ebp
        pop esi
        ret
MviRewind:
        mov eax, dword [byte esp+04h]
        mov dword [byte eax+04h], 1
        mov edx, dword [byte eax+024h]
        test edx, edx
        jne short .1
        mov edx, dword [byte eax+028h]
        mov dword [byte eax+02Ch], edx
        ret
.1:
        mov ebx, dword [byte eax+028h]
        push ebx
        push edx
        call DosSeekFile
        add esp, byte 8
        ret
        db 090h
MviGetPalette:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+014h]
        mov ebx, dword [byte esp+08h]
        mov dword [ebx], eax
        mov eax, dword [byte edx+018h]
        mov ebx, dword [byte esp+0Ch]
        mov dword [ebx], eax
        mov eax, dword [byte edx+01Ch]
        mov edx, dword [byte esp+010h]
        mov dword [edx], eax
        ret
