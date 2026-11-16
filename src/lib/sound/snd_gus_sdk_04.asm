; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_B0100 progbits alloc exec nowrite align=1
extern byte_D89E4, KeyedDraw, RowCopyFunc, DmaDefaultMode, DrawArtOpaque, bcopy, BlitBlockRemapKeyed
global GetBytesLE, loc_B010E, loc_B0123, GetBytesBE, loc_B0132, loc_B0144, PutBytesLE, loc_B015B
global loc_B016A, PutBytesBE, loc_B018F, loc_B01A3, CopyRowShadowKeyed, loc_B01BD, loc_B01CE, loc_B01DC
global loc_B01E1, DrawArtKeyedRemap, loc_B0205, DrawArtKeyedRemapOwnPos, RemapBytes, loc_B027D, loc_B0285, SetDmaDefaultMode
GetBytesLE:
        push esi
        push edi
        mov edx, dword [byte esp+0Ch]
        mov ebx, dword [byte esp+010h]
        xor esi, esi
        xor eax, eax
loc_B010E:
        dec ebx
        cmp ebx, byte 0FFFFFFFFh
        je short loc_B0123
        movzx edi, byte [edx]
        mov cl, al
        shl edi, cl
        inc edx
        add esi, edi
        add eax, byte 8
        jmp short loc_B010E
loc_B0123:
        mov eax, esi
        pop edi
        pop esi
        ret
GetBytesBE:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        xor ebx, ebx
loc_B0132:
        dec edx
        cmp edx, byte 0FFFFFFFFh
        je short loc_B0144
        xor ecx, ecx
        mov cl, byte [eax]
        shl ebx, 8
        inc eax
        add ebx, ecx
        jmp short loc_B0132
loc_B0144:
        mov eax, ebx
        ret
        db 090h
PutBytesLE:
        sub esp, byte 4
        mov eax, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        mov edx, dword [byte esp+010h]
        test edx, edx
        je short loc_B016A
loc_B015B:
        mov dword [esp], ebx
        mov cl, byte [esp]
        mov byte [eax], cl
        shr ebx, 8
        inc eax
        dec edx
        jne short loc_B015B
loc_B016A:
        add esp, byte 4
        ret
        db 08Bh,0C0h
PutBytesBE:
        sub esp, byte 4
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        mov eax, dword [byte esp+010h]
        mov ecx, 4
        sub ecx, eax
        shl ecx, 3
        shl ebx, cl
        test eax, eax
        je short loc_B01A3
loc_B018F:
        mov ecx, ebx
        shr ecx, 18h
        mov dword [esp], ecx
        mov cl, byte [esp]
        mov byte [edx], cl
        shl ebx, 8
        inc edx
        dec eax
        jne short loc_B018F
loc_B01A3:
        mov eax, edx
        add esp, byte 4
        ret
        db 00h,00h,00h,00h,00h,00h,00h
CopyRowShadowKeyed:
        push esi
        mov ecx, dword [byte esp+010h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
loc_B01BD:
        dec ecx
        cmp ecx, byte 0FFFFFFFFh
        je short loc_B01E1
        mov dl, byte [ebx]
        inc ebx
        cmp dl, 0FFh
        jne short loc_B01CE
        inc eax
        jmp short loc_B01BD
loc_B01CE:
        cmp dl, 0FEh
        jne short loc_B01DC
        movzx esi, byte [eax]
        mov dl, byte [dword esi+byte_D89E4]
loc_B01DC:
        mov byte [eax], dl
        inc eax
        jmp short loc_B01BD
loc_B01E1:
        pop esi
        ret
        db 090h
DrawArtKeyedRemap:
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short loc_B0205
        push eax
        push ebx
        push edx
        call BlitBlockRemapKeyed
        add esp, byte 0Ch
        ret
loc_B0205:
        mov dword [RowCopyFunc], CopyRowShadowKeyed
        push eax
        push ebx
        push edx
        call DrawArtOpaque
        add esp, byte 0Ch
        mov dword [RowCopyFunc], bcopy
        ret
        db 08Dh,040h,00h
DrawArtKeyedRemapOwnPos:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call DrawArtKeyedRemap
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
        call DrawArtKeyedRemap
        add esp, byte 0Ch
        ret
RemapBytes:
        push ebp
        LD mov, ebp, esp
        push edi
        mov edi, dword [byte ebp+08h]
        mov ebx, dword [byte ebp+0Ch]
        mov ecx, dword [byte ebp+010h]
        LD xor, eax, eax
        jecxz loc_B0285
loc_B027D:
        mov al, byte [edi]
        mov al, byte [ebx+eax]
        stosb
        loop loc_B027D
loc_B0285:
        pop edi
        leave
        ret
SetDmaDefaultMode:
        mov dword [DmaDefaultMode], eax
        ret
