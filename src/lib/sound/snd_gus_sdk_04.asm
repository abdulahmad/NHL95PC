; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_B0100 progbits alloc exec nowrite align=1
extern byte_D89E4, KeyedDraw, RowCopyFunc, DmaDefaultMode, DrawArtOpaque, bcopy, BlitBlockRemapKeyed
global GetBytesLE, GetBytesBE, PutBytesLE, PutBytesBE, CopyRowShadowKeyed, DrawArtKeyedRemap, DrawArtKeyedRemapOwnPos, RemapBytes
global SetDmaDefaultMode
GetBytesLE:
        push esi
        push edi
        mov edx, dword [byte esp+0Ch]
        mov ebx, dword [byte esp+010h]
        xor esi, esi
        xor eax, eax
.1:
        dec ebx
        cmp ebx, byte 0FFFFFFFFh
        je short .2
        movzx edi, byte [edx]
        mov cl, al
        shl edi, cl
        inc edx
        add esi, edi
        add eax, byte 8
        jmp short .1
.2:
        mov eax, esi
        pop edi
        pop esi
        ret
GetBytesBE:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        xor ebx, ebx
.1:
        dec edx
        cmp edx, byte 0FFFFFFFFh
        je short .2
        xor ecx, ecx
        mov cl, byte [eax]
        shl ebx, 8
        inc eax
        add ebx, ecx
        jmp short .1
.2:
        mov eax, ebx
        ret
        db 090h
PutBytesLE:
        sub esp, byte 4
        mov eax, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        mov edx, dword [byte esp+010h]
        test edx, edx
        je short .2
.1:
        mov dword [esp], ebx
        mov cl, byte [esp]
        mov byte [eax], cl
        shr ebx, 8
        inc eax
        dec edx
        jne short .1
.2:
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
        je short .2
.1:
        mov ecx, ebx
        shr ecx, 18h
        mov dword [esp], ecx
        mov cl, byte [esp]
        mov byte [edx], cl
        shl ebx, 8
        inc edx
        dec eax
        jne short .1
.2:
        mov eax, edx
        add esp, byte 4
        ret
        db 00h,00h,00h,00h,00h,00h,00h
CopyRowShadowKeyed:
        push esi
        mov ecx, dword [byte esp+010h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
.1:
        dec ecx
        cmp ecx, byte 0FFFFFFFFh
        je short .4
        mov dl, byte [ebx]
        inc ebx
        cmp dl, 0FFh
        jne short .2
        inc eax
        jmp short .1
.2:
        cmp dl, 0FEh
        jne short .3
        movzx esi, byte [eax]
        mov dl, byte [dword esi+byte_D89E4]
.3:
        mov byte [eax], dl
        inc eax
        jmp short .1
.4:
        pop esi
        ret
        db 090h
DrawArtKeyedRemap:
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short .1
        push eax
        push ebx
        push edx
        call BlitBlockRemapKeyed
        add esp, byte 0Ch
        ret
.1:
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
        jecxz .2
.1:
        mov al, byte [edi]
        mov al, byte [ebx+eax]
        stosb
        loop .1
.2:
        pop edi
        leave
        ret
SetDmaDefaultMode:
        mov dword [DmaDefaultMode], eax
        ret
