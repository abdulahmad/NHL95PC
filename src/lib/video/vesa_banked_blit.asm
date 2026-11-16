; Blitting through a banked VESA mode.
bits 32
%include "hockey.inc"
section s_B5D80 progbits alloc exec nowrite align=1
extern ColourRemap, VesaBankShift, byte_D89E4, cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1, dword_D30BC
extern dword_D30C0, DrawRowBytes, KeyedDraw, DrawDestBuffer, DrawVideoBase, ScreenRowTable, dword_D4F4C, dword_D4F50
extern BlitColumnOffsets, BlitSourcePtr
global PutPixel, loc_B5DAC, PlotPixel, loc_B5DBC, loc_B5DD8, loc_B5DE0, VesaSetBankArg, VesaSetBank
global jpt_B5E1F, loc_B5E2B, loc_B5E49, loc_B5E4A, loc_B5E76, VesaSetMode, VgaSetModeTwice, VesaSetDisplayStart
global BlitBlockHot, BlitBlock, loc_B5F41, loc_B5F63, loc_B5F67, loc_B5F94, loc_B5FC2, loc_B5FE5
global loc_B5FEB, loc_B6024, loc_B6037, loc_B603B, loc_B603D, loc_B6055, BlitBlockXorHot, BlitBlockXor
global loc_B60BD, loc_B60DF, loc_B60E3, loc_B6110, loc_B613E, loc_B6161, loc_B6167, loc_B61A3
global loc_B61A6, loc_B61B8, loc_B61BC, loc_B61C2, loc_B61C5, loc_B61DE, loc_B61DF, BlitBlockAndHot
global BlitBlockAnd, loc_B6249, loc_B626B, loc_B626F, loc_B629C, loc_B62CA, loc_B62ED, loc_B62F3
global loc_B632F, loc_B6332, loc_B6344, loc_B6348, loc_B634E, loc_B6351, loc_B636A, loc_B636B
global AndPixelClipped, loc_B63A8, AndPixel, loc_B63B8, loc_B63D4, loc_B63DC, BlitBlockOrHot, BlitBlockOr
global loc_B6455, loc_B6477, loc_B647B, loc_B64A8, loc_B64D6, loc_B64F9, loc_B64FF, loc_B653B
global loc_B653E, loc_B6550, loc_B6554, loc_B655A, loc_B655D, loc_B6576, loc_B6577, OrPixelClipped
global loc_B65B4, OrPixel, loc_B65C4, loc_B65E0, loc_B65E8, FillRectClippedCore, loc_B6621, loc_B6634
global loc_B664B, loc_B6662, FillRectCore, loc_B6669, jpt_B66B3, loc_B66C3, loc_B66D0, loc_B66D6
global loc_B66E4, loc_B66F3, loc_B6703, loc_B670E, loc_B6710, loc_B671A, XorRectClippedCore, loc_B6739
global loc_B674C, loc_B6763, loc_B677A, XorRectCore, loc_B6781, jpt_B67CB, loc_B67DB, loc_B67E0
global loc_B67E7, loc_B67EF, loc_B67F6, loc_B67FB, loc_B6802, loc_B680C, loc_B680F, loc_B6814
global loc_B681B, loc_B6826, loc_B6829, loc_B682E, loc_B6835, loc_B6843, loc_B684E, loc_B6850
global loc_B685A, BlitArtOpaqueHot, BlitArtOpaque, loc_B68B9, loc_B68EC, loc_B68F6, loc_B68FA, loc_B68FC
global loc_B690B, BlitArtKeyFFHot, BlitArtKeyFF, loc_B6970, loc_B69A3, loc_B69A6, loc_B69B0, loc_B69B3
global BlitArtHot, BlitArt, loc_B6A18, loc_B6A3A, loc_B6A3F, loc_B6A6C, loc_B6A9A, loc_B6ABD
global loc_B6AC3, loc_B6AF6, loc_B6AF9, loc_B6B03, loc_B6B06, loc_B6B10, BlitShapeFastHot, BlitShapeFast
global loc_B6B79, loc_B6B94, loc_B6BA2, loc_B6BAE, BlitArtKeyColourHot, BlitArtKeyColour, loc_B6C1B, loc_B6C3D
global loc_B6C43, loc_B6C70, loc_B6C9E, loc_B6CC1, loc_B6CC7, loc_B6CFA, loc_B6CFD, loc_B6D0F
global loc_B6D12, loc_B6D1C, BlitArtMaskedHot, BlitArtMasked, loc_B6D79, loc_B6DAC, loc_B6DAF, loc_B6DBF
global loc_B6DC2, BlitShapeClippedHot, BlitShapeClipped, loc_B6E31, loc_B6E53, loc_B6E57, loc_B6E84, loc_B6EB2
global loc_B6ED5, loc_B6EDB, loc_B6F1E, loc_B6F2E, loc_B6F39, loc_B6F46, loc_B6F4B, loc_B6F57
global loc_B6F68, loc_B6F78, SetBitmapClip, loc_B6FB7, ShapeWidth, ShapeHeight, ShapeDataSize, loc_B7027
global loc_B702C, loc_B7037, loc_B7045, FillRectSpansCore, jpt_B708F, loc_B70B7, loc_B70CF, loc_B70FC
global loc_B710B, loc_B7111, loc_B712E, loc_B7139, loc_B7142, loc_B7146, loc_B714F, loc_B7158
global loc_B7179, loc_B7185, loc_B71A8, loc_B71B4, loc_B71D2, loc_B71DB, loc_B71DF, loc_B71E5
global loc_B7203, loc_B720C, loc_B7210, UnpackArtRle, loc_B7239, loc_B725D, loc_B7260, loc_B726C
global loc_B7271, loc_B7277, loc_B7280, loc_B7296, loc_B72A1, loc_B72A4, loc_B72B2, loc_B72B8
global loc_B72BA, loc_B72CB, loc_B72CF, SetBlitSource, CopyRowKeyFF, loc_B7309, loc_B7314, CopyRowRemapKeyed
global loc_B7340, loc_B7379, loc_B738A, loc_B73B6, loc_B73CB, loc_B73CD, loc_B73F9, loc_B7414
global loc_B7416, CopyRowFast, loc_B7445, loc_B7456, loc_B7482, unk_B74AA, loc_B74EA, loc_B74F3
global loc_B7501, loc_B7511, loc_B7521, loc_B7531, loc_B7541, loc_B7551, loc_B7561, loc_B7571
global loc_B7581, loc_B7591, loc_B75A1, loc_B75B1, loc_B75C1, loc_B75D1, loc_B75E1, loc_B7603
global BlitBlockShadowHot, BlitBlockShadow, loc_B766D, loc_B768F, loc_B7693, loc_B76C0, loc_B76EE, loc_B7711
global loc_B7717, loc_B7748, loc_B774B, loc_B7757, loc_B7764, loc_B7767, loc_B7771, SetRemapTable
global BlitBlockRemapKeyedHot, BlitBlockRemapKeyed, loc_B7828, loc_B7860, loc_B7863, loc_B786F, loc_B7877, loc_B787A
PutPixel:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        cmp eax, dword [dword_D30BC]
        jl short loc_B5DAC
        cmp eax, dword [dword_D30C0]
        jge short loc_B5DAC
        cmp edx, dword [cliprect_y0]
        jl short loc_B5DAC
        cmp edx, dword [cliprect_y1]
        jl short loc_B5DBC
loc_B5DAC:
        ret
        db 02Eh,0C0h,08Bh
PlotPixel:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
loc_B5DBC:
        cmp dword [KeyedDraw], byte 0
        jne short loc_B5DE0
        mov ecx, dword [DrawDestBuffer]
        add eax, dword [ecx+edx*4]
        add eax, dword [DrawVideoBase]
        mov byte [eax], bl
        ret
        db 090h
loc_B5DD8:
        call VesaSetBank
        mov byte [edx], bl
        ret
loc_B5DE0:
        add eax, dword [nosplit edx*4+ScreenRowTable]
        movzx edx, ax
        add edx, dword [DrawVideoBase]
        shr eax, 10h
        cmp al, byte [VesaBankShift]
        jne short loc_B5DD8
        mov byte [edx], bl
        ret
        db 00h,00h
VesaSetBankArg:
        mov eax, dword [byte esp+04h]
VesaSetBank:
        cmp al, byte [VesaBankShift]
        je short loc_B5E49
        mov byte [VesaBankShift], al
        push edx
        mov edx, dword [dword_D4F4C]
        jmp dword [nosplit edx*4+jpt_B5E1F]
jpt_B5E1F:
        dd loc_B5E2B
        dd loc_B5E4A
        dd loc_B5E76
loc_B5E2B:
        push ebx
        push ecx
        push ebp
        push esi
        push edi
        mov ecx, dword [dword_D4F50]
        shl al, cl
        movzx edx, al
        mov ax, 4F05h
        LD xor, ebx, ebx
        int 10h
        pop edi
        pop esi
        pop ebp
        pop ecx
        pop ebx
        pop edx
loc_B5E49:
        ret
loc_B5E4A:
        push ebx
        push ecx
        push ebp
        push esi
        push edi
        mov ecx, dword [dword_D4F50]
        shl al, cl
        movzx edx, al
        push edx
        mov ax, 4F05h
        LD xor, ebx, ebx
        int 10h
        pop edx
        mov ax, 4F05h
        mov ebx, 1
        int 10h
        pop edi
        pop esi
        pop ebp
        pop ecx
        pop ebx
        pop edx
        ret
loc_B5E76:
        mov dx, 1CEh
        mov al, 0BEh
        out dx, al
        inc dl
        in al, dx
        LD mov, ah, al
        and ah, 0F7h
        dec dl
        mov al, 0BEh
        out dx, ax
        mov dx, 1CEh
        mov al, 0B2h
        out dx, al
        inc dl
        in al, dx
        and al, 0E1h
        mov ah, byte [byte esp+08h]
        LD add, ah, ah
        LD or, ah, al
        mov al, 0B2h
        dec dl
        out dx, ax
        pop edx
        ret
VesaSetMode:
        mov ebx, dword [byte esp+04h]
        mov ax, 4F02h
        push ebp
        push esi
        push edi
        int 10h
        pop edi
        pop esi
        pop ebp
        ret
VgaSetModeTwice:
        mov eax, dword [byte esp+04h]
        push ebp
        push esi
        push edi
        int 10h
        pop edi
        pop esi
        pop ebp
        ret
VesaSetDisplayStart:
        push ecx
        LD mov, ecx, eax
        mov eax, 4F07h
        mov ebx, 0
        int 10h
        pop ecx
        ret
        push ecx
        movzx ebx, al
        movzx edx, dx
        mov eax, 4F05h
        int 10h
        pop ecx
        ret
        db 00h,00h
BlitBlockHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short loc_B5F41
BlitBlock:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B5F41
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B5F41:
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        lea edx, [byte esi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short loc_B5F67
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B5F94
        LD sub, ecx, eax
        jg short loc_B5F94
loc_B5F63:
        pop edi
        pop esi
        leave
        ret
loc_B5F67:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B5F63
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-010h], edx
        movsx edx, word [byte esi+04h]
        imul edx
        mov edx, dword [byte ebp-010h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B5F94
        LD sub, ecx, eax
        jle short loc_B5F63
loc_B5F94:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte esi+04h]
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        cmp eax, dword [dword_D30BC]
        jl short loc_B5FC2
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jl short loc_B5FEB
        LD sub, ecx, eax
        jle short loc_B5F63
        LD mov, edx, eax
        jmp short loc_B5FEB
loc_B5FC2:
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B5F63
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-018h], esi
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        jle short loc_B5F63
        LD cmp, eax, esi
        jl short loc_B5FE5
        LD mov, eax, esi
loc_B5FE5:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
loc_B5FEB:
        LD or, ecx, ecx
        jle short loc_B6037
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-018h]
        mov edx, dword [byte ebp-014h]
        mov ebx, dword [DrawRowBytes]
        sub ebx, dword [byte ebp-0Ch]
        mov eax, dword [byte ebp-0Ch]
        shr eax, 1
        jb short loc_B603B
loc_B6024:
        LD mov, ecx, eax
        shr ecx, 1
        rep movsd
        LD adc, ecx, ecx
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short loc_B6024
loc_B6037:
        pop edi
        pop esi
        leave
        ret
loc_B603B:
        je short loc_B6055
loc_B603D:
        LD mov, ecx, eax
        shr ecx, 1
        rep movsd
        LD adc, ecx, ecx
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        movsb
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short loc_B603D
        pop edi
        pop esi
        leave
        ret
loc_B6055:
        movsb
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short loc_B6055
        pop edi
        pop esi
        leave
        ret
        db 00h,00h
BlitBlockXorHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short loc_B60BD
BlitBlockXor:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B60BD
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B60BD:
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        lea edx, [byte esi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short loc_B60E3
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B6110
        LD sub, ecx, eax
        jg short loc_B6110
loc_B60DF:
        pop edi
        pop esi
        leave
        ret
loc_B60E3:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B60DF
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-010h], edx
        movsx edx, word [byte esi+04h]
        imul edx
        mov edx, dword [byte ebp-010h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B6110
        LD sub, ecx, eax
        jle short loc_B60DF
loc_B6110:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte esi+04h]
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        cmp eax, dword [dword_D30BC]
        jl short loc_B613E
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jl short loc_B6167
        LD sub, ecx, eax
        jle short loc_B60DF
        LD mov, edx, eax
        jmp short loc_B6167
loc_B613E:
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B60DF
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-018h], esi
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        jle short loc_B60DF
        LD cmp, eax, esi
        jl short loc_B6161
        LD mov, eax, esi
loc_B6161:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
loc_B6167:
        LD or, ecx, ecx
        jle short loc_B61B8
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-018h]
        mov edx, dword [byte ebp-014h]
        mov ebx, dword [DrawRowBytes]
        sub ebx, dword [byte ebp-0Ch]
        mov eax, dword [byte ebp-0Ch]
        shr eax, 1
        jb short loc_B61BC
        mov dword [byte ebp-01Ch], eax
loc_B61A3:
        mov ecx, dword [byte ebp-01Ch]
loc_B61A6:
        lodsw
        xor word [edi], ax
        add edi, byte 2
        loop loc_B61A6
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short loc_B61A3
loc_B61B8:
        pop edi
        pop esi
        leave
        ret
loc_B61BC:
        je short loc_B61DE
        mov dword [byte ebp-01Ch], eax
        inc ebx
loc_B61C2:
        mov ecx, dword [byte ebp-01Ch]
loc_B61C5:
        lodsw
        xor word [edi], ax
        add edi, byte 2
        loop loc_B61C5
        lodsb
        xor byte [edi], al
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short loc_B61C2
        pop edi
        pop esi
        leave
        ret
loc_B61DE:
        inc ebx
loc_B61DF:
        lodsb
        xor byte [edi], al
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short loc_B61DF
        pop edi
        pop esi
        leave
        ret
        db 00h,00h
BlitBlockAndHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short loc_B6249
BlitBlockAnd:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B6249
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B6249:
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        lea edx, [byte esi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short loc_B626F
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B629C
        LD sub, ecx, eax
        jg short loc_B629C
loc_B626B:
        pop edi
        pop esi
        leave
        ret
loc_B626F:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B626B
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-010h], edx
        movsx edx, word [byte esi+04h]
        imul edx
        mov edx, dword [byte ebp-010h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B629C
        LD sub, ecx, eax
        jle short loc_B626B
loc_B629C:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte esi+04h]
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        cmp eax, dword [dword_D30BC]
        jl short loc_B62CA
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jl short loc_B62F3
        LD sub, ecx, eax
        jle short loc_B626B
        LD mov, edx, eax
        jmp short loc_B62F3
loc_B62CA:
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B626B
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-018h], esi
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        jle short loc_B626B
        LD cmp, eax, esi
        jl short loc_B62ED
        LD mov, eax, esi
loc_B62ED:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
loc_B62F3:
        LD or, ecx, ecx
        jle short loc_B6344
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-018h]
        mov edx, dword [byte ebp-014h]
        mov ebx, dword [DrawRowBytes]
        sub ebx, dword [byte ebp-0Ch]
        mov eax, dword [byte ebp-0Ch]
        shr eax, 1
        jb short loc_B6348
        mov dword [byte ebp-01Ch], eax
loc_B632F:
        mov ecx, dword [byte ebp-01Ch]
loc_B6332:
        lodsw
        and word [edi], ax
        add edi, byte 2
        loop loc_B6332
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short loc_B632F
loc_B6344:
        pop edi
        pop esi
        leave
        ret
loc_B6348:
        je short loc_B636A
        mov dword [byte ebp-01Ch], eax
        inc ebx
loc_B634E:
        mov ecx, dword [byte ebp-01Ch]
loc_B6351:
        lodsw
        and word [edi], ax
        add edi, byte 2
        loop loc_B6351
        lodsb
        and byte [edi], al
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short loc_B634E
        pop edi
        pop esi
        leave
        ret
loc_B636A:
        inc ebx
loc_B636B:
        lodsb
        and byte [edi], al
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short loc_B636B
        pop edi
        pop esi
        leave
        ret
        db 00h,00h
AndPixelClipped:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        cmp eax, dword [dword_D30BC]
        jl short loc_B63A8
        cmp eax, dword [dword_D30C0]
        jge short loc_B63A8
        cmp edx, dword [cliprect_y0]
        jl short loc_B63A8
        cmp edx, dword [cliprect_y1]
        jl short loc_B63B8
loc_B63A8:
        ret
        db 02Eh,0C0h,08Bh
AndPixel:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
loc_B63B8:
        cmp dword [KeyedDraw], byte 0
        jne short loc_B63DC
        mov ecx, dword [DrawDestBuffer]
        add eax, dword [ecx+edx*4]
        add eax, dword [DrawVideoBase]
        and byte [eax], bl
        ret
        db 090h
loc_B63D4:
        call VesaSetBank
        and byte [edx], bl
        ret
loc_B63DC:
        add eax, dword [nosplit edx*4+ScreenRowTable]
        movzx edx, ax
        add edx, dword [DrawVideoBase]
        shr eax, 10h
        cmp al, byte [VesaBankShift]
        jne short loc_B63D4
        and byte [edx], bl
        ret
        db 00h,00h
BlitBlockOrHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short loc_B6455
BlitBlockOr:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B6455
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B6455:
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        lea edx, [byte esi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short loc_B647B
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B64A8
        LD sub, ecx, eax
        jg short loc_B64A8
loc_B6477:
        pop edi
        pop esi
        leave
        ret
loc_B647B:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B6477
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-010h], edx
        movsx edx, word [byte esi+04h]
        imul edx
        mov edx, dword [byte ebp-010h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B64A8
        LD sub, ecx, eax
        jle short loc_B6477
loc_B64A8:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte esi+04h]
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        cmp eax, dword [dword_D30BC]
        jl short loc_B64D6
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jl short loc_B64FF
        LD sub, ecx, eax
        jle short loc_B6477
        LD mov, edx, eax
        jmp short loc_B64FF
loc_B64D6:
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B6477
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-018h], esi
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        jle short loc_B6477
        LD cmp, eax, esi
        jl short loc_B64F9
        LD mov, eax, esi
loc_B64F9:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
loc_B64FF:
        LD or, ecx, ecx
        jle short loc_B6550
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-018h]
        mov edx, dword [byte ebp-014h]
        mov ebx, dword [DrawRowBytes]
        sub ebx, dword [byte ebp-0Ch]
        mov eax, dword [byte ebp-0Ch]
        shr eax, 1
        jb short loc_B6554
        mov dword [byte ebp-01Ch], eax
loc_B653B:
        mov ecx, dword [byte ebp-01Ch]
loc_B653E:
        lodsw
        or word [edi], ax
        add edi, byte 2
        loop loc_B653E
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short loc_B653B
loc_B6550:
        pop edi
        pop esi
        leave
        ret
loc_B6554:
        je short loc_B6576
        mov dword [byte ebp-01Ch], eax
        inc ebx
loc_B655A:
        mov ecx, dword [byte ebp-01Ch]
loc_B655D:
        lodsw
        or word [edi], ax
        add edi, byte 2
        loop loc_B655D
        lodsb
        or byte [edi], al
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short loc_B655A
        pop edi
        pop esi
        leave
        ret
loc_B6576:
        inc ebx
loc_B6577:
        lodsb
        or byte [edi], al
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short loc_B6577
        pop edi
        pop esi
        leave
        ret
        db 00h,00h
OrPixelClipped:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        cmp eax, dword [dword_D30BC]
        jl short loc_B65B4
        cmp eax, dword [dword_D30C0]
        jge short loc_B65B4
        cmp edx, dword [cliprect_y0]
        jl short loc_B65B4
        cmp edx, dword [cliprect_y1]
        jl short loc_B65C4
loc_B65B4:
        ret
        db 02Eh,0C0h,08Bh
OrPixel:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
loc_B65C4:
        cmp dword [KeyedDraw], byte 0
        jne short loc_B65E8
        mov ecx, dword [DrawDestBuffer]
        add eax, dword [ecx+edx*4]
        add eax, dword [DrawVideoBase]
        or byte [eax], bl
        ret
        db 090h
loc_B65E0:
        call VesaSetBank
        or byte [edx], bl
        ret
loc_B65E8:
        add eax, dword [nosplit edx*4+ScreenRowTable]
        movzx edx, ax
        add edx, dword [DrawVideoBase]
        shr eax, 10h
        cmp al, byte [VesaBankShift]
        jne short loc_B65E0
        or byte [edx], bl
        ret
        db 00h,00h
FillRectClippedCore:
        push ebp
        LD mov, ebp, esp
        push edi
        mov edx, dword [cliprect_x0]
        LD mov, eax, edx
        sub eax, dword [byte ebp+08h]
        jle short loc_B6621
        mov dword [byte ebp+08h], edx
        sub dword [byte ebp+010h], eax
        jle short loc_B6662
loc_B6621:
        mov eax, dword [byte ebp+08h]
        add eax, dword [byte ebp+010h]
        sub eax, dword [cliprect_x1]
        jle short loc_B6634
        sub dword [byte ebp+010h], eax
        jle short loc_B6662
loc_B6634:
        mov eax, dword [cliprect_y0]
        sub eax, dword [byte ebp+0Ch]
        jle short loc_B664B
        sub dword [byte ebp+014h], eax
        jle short loc_B6662
        mov eax, dword [cliprect_y0]
        mov dword [byte ebp+0Ch], eax
loc_B664B:
        mov eax, dword [byte ebp+0Ch]
        add eax, dword [byte ebp+014h]
        mov ebx, dword [cliprect_y1]
        LD sub, eax, ebx
        jle short loc_B6669
        sub dword [byte ebp+014h], eax
        jle short loc_B6662
        jmp short loc_B6669
loc_B6662:
        pop edi
        leave
        ret
FillRectCore:
        push ebp
        LD mov, ebp, esp
        push edi
loc_B6669:
        cld
        cmp dword [byte ebp+010h], byte 0
        jle short loc_B6662
        cmp dword [byte ebp+014h], byte 0
        jle short loc_B6662
        mov dl, byte [byte ebp+018h]
        LD mov, dh, dl
        shrd eax, edx, 10h
        LD mov, ax, dx
        mov ebx, dword [byte ebp+0Ch]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp+08h]
        mov ebx, dword [byte ebp+014h]
        mov ecx, dword [byte ebp+010h]
        mov edx, dword [DrawRowBytes]
        LD sub, edx, ecx
        shr dword [byte ebp+010h], 2
        and ecx, byte 3
        jmp dword [nosplit ecx*4+jpt_B66B3]
jpt_B66B3:
        dd loc_B66C3
        dd loc_B66D0
        dd loc_B66E4
        dd loc_B66F3
loc_B66C3:
        mov ecx, dword [byte ebp+010h]
        rep stosd
        LD add, edi, edx
        dec ebx
        jg short loc_B66C3
        pop edi
        leave
        ret
loc_B66D0:
        cmp dword [byte ebp+010h], byte 0
        je short loc_B6703
loc_B66D6:
        mov ecx, dword [byte ebp+010h]
        rep stosd
        stosb
        LD add, edi, edx
        dec ebx
        jg short loc_B66D6
        pop edi
        leave
        ret
loc_B66E4:
        mov ecx, dword [byte ebp+010h]
        rep stosd
        stosw
        LD add, edi, edx
        dec ebx
        jg short loc_B66E4
        pop edi
        leave
        ret
loc_B66F3:
        mov ecx, dword [byte ebp+010h]
        rep stosd
        stosw
        stosb
        LD add, edi, edx
        dec ebx
        jg short loc_B66F3
        pop edi
        leave
        ret
loc_B6703:
        inc edx
        LD mov, ecx, ebx
        shr ecx, 1
        jae short loc_B670E
        mov byte [edi], al
        LD add, edi, edx
loc_B670E:
        jecxz loc_B671A
loc_B6710:
        mov byte [edi], al
        mov byte [edx+edi], al
        lea edi, [edi+edx*2]
        loop loc_B6710
loc_B671A:
        pop edi
        leave
        ret
        db 00h,00h,00h
XorRectClippedCore:
        push ebp
        LD mov, ebp, esp
        push edi
        mov edx, dword [cliprect_x0]
        LD mov, eax, edx
        sub eax, dword [byte ebp+08h]
        jle short loc_B6739
        mov dword [byte ebp+08h], edx
        sub dword [byte ebp+010h], eax
        jle short loc_B677A
loc_B6739:
        mov eax, dword [byte ebp+08h]
        add eax, dword [byte ebp+010h]
        sub eax, dword [cliprect_x1]
        jle short loc_B674C
        sub dword [byte ebp+010h], eax
        jle short loc_B677A
loc_B674C:
        mov eax, dword [cliprect_y0]
        sub eax, dword [byte ebp+0Ch]
        jle short loc_B6763
        sub dword [byte ebp+014h], eax
        jle short loc_B677A
        mov eax, dword [cliprect_y0]
        mov dword [byte ebp+0Ch], eax
loc_B6763:
        mov eax, dword [byte ebp+0Ch]
        add eax, dword [byte ebp+014h]
        mov ebx, dword [cliprect_y1]
        LD sub, eax, ebx
        jle short loc_B6781
        sub dword [byte ebp+014h], eax
        jle short loc_B677A
        jmp short loc_B6781
loc_B677A:
        pop edi
        leave
        ret
XorRectCore:
        push ebp
        LD mov, ebp, esp
        push edi
loc_B6781:
        cld
        cmp dword [byte ebp+010h], byte 0
        jle short loc_B677A
        cmp dword [byte ebp+014h], byte 0
        jle short loc_B677A
        mov dl, byte [byte ebp+018h]
        LD mov, dh, dl
        shrd eax, edx, 10h
        LD mov, ax, dx
        mov ebx, dword [byte ebp+0Ch]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp+08h]
        mov ebx, dword [byte ebp+014h]
        mov ecx, dword [byte ebp+010h]
        mov edx, dword [DrawRowBytes]
        LD sub, edx, ecx
        shr dword [byte ebp+010h], 2
        and ecx, byte 3
        jmp dword [nosplit ecx*4+jpt_B67CB]
jpt_B67CB:
        dd loc_B67DB
        dd loc_B67EF
        dd loc_B680C
        dd loc_B6826
loc_B67DB:
        mov ecx, dword [byte ebp+010h]
        jecxz loc_B67E7
loc_B67E0:
        xor dword [edi], eax
        add edi, byte 4
        loop loc_B67E0
loc_B67E7:
        LD add, edi, edx
        dec ebx
        jg short loc_B67DB
        pop edi
        leave
        ret
loc_B67EF:
        cmp dword [byte ebp+010h], byte 0
        je short loc_B6843
        inc edx
loc_B67F6:
        mov ecx, dword [byte ebp+010h]
        jecxz loc_B6802
loc_B67FB:
        xor dword [edi], eax
        add edi, byte 4
        loop loc_B67FB
loc_B6802:
        xor byte [edi], al
        LD add, edi, edx
        dec ebx
        jg short loc_B67F6
        pop edi
        leave
        ret
loc_B680C:
        add edx, byte 2
loc_B680F:
        mov ecx, dword [byte ebp+010h]
        jecxz loc_B681B
loc_B6814:
        xor dword [edi], eax
        add edi, byte 4
        loop loc_B6814
loc_B681B:
        xor word [edi], ax
        LD add, edi, edx
        dec ebx
        jg short loc_B680F
        pop edi
        leave
        ret
loc_B6826:
        add edx, byte 3
loc_B6829:
        mov ecx, dword [byte ebp+010h]
        jecxz loc_B6835
loc_B682E:
        xor dword [edi], eax
        add edi, byte 4
        loop loc_B682E
loc_B6835:
        xor word [edi], ax
        xor byte [byte edi+02h], al
        LD add, edi, edx
        dec ebx
        jg short loc_B6829
        pop edi
        leave
        ret
loc_B6843:
        inc edx
        LD mov, ecx, ebx
        shr ecx, 1
        jae short loc_B684E
        xor byte [edi], al
        LD add, edi, edx
loc_B684E:
        jecxz loc_B685A
loc_B6850:
        xor byte [edi], al
        xor byte [edx+edi], al
        lea edi, [edi+edx*2]
        loop loc_B6850
loc_B685A:
        pop edi
        leave
        ret
        db 00h,00h,00h
BlitArtOpaqueHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short loc_B68B9
BlitArtOpaque:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B68B9
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B68B9:
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov edi, dword [ebx]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-04h]
        cld
        movsx edx, word [byte esi+06h]
        LD or, edx, edx
        je short loc_B68F6
        mov ebx, dword [DrawRowBytes]
        movsx eax, word [byte esi+04h]
        LD sub, ebx, eax
        add esi, byte 10h
        shr eax, 1
        jb short loc_B68FA
loc_B68EC:
        LD mov, ecx, eax
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        LD add, edi, ebx
        dec edx
        jg short loc_B68EC
loc_B68F6:
        pop edi
        pop esi
        leave
        ret
loc_B68FA:
        je short loc_B690B
loc_B68FC:
        LD mov, ecx, eax
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        movsb
        LD add, edi, ebx
        dec edx
        jg short loc_B68FC
        pop edi
        pop esi
        leave
        ret
loc_B690B:
        movsb
        LD add, edi, ebx
        dec edx
        jg short loc_B690B
        pop edi
        pop esi
        leave
        ret
        db 00h,00h,00h
BlitArtKeyFFHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short loc_B6970
BlitArtKeyFF:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B6970
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B6970:
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov edx, dword [DrawRowBytes]
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        LD sub, edx, eax
        movsx eax, word [byte esi+06h]
        mov dword [byte ebp-010h], eax
        cld
        add esi, byte 10h
        LD xor, ebx, ebx
loc_B69A3:
        mov ecx, dword [byte ebp-0Ch]
loc_B69A6:
        lodsb
        cmp al, 0FFh
        je short loc_B69B0
        stosb
        loop loc_B69A6
        jmp short loc_B69B3
loc_B69B0:
        inc edi
        loop loc_B69A6
loc_B69B3:
        LD add, edi, edx
        dec dword [byte ebp-010h]
        jg short loc_B69A3
        pop edi
        pop esi
        pop ds
        leave
        ret
        db 00h
BlitArtHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short loc_B6A18
BlitArt:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B6A18
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE8h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B6A18:
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        lea edx, [byte esi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short loc_B6A3F
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B6A6C
        LD sub, ecx, eax
        jg short loc_B6A6C
loc_B6A3A:
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B6A3F:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B6A3A
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-018h], edx
        movsx edx, word [byte esi+04h]
        mul edx
        mov edx, dword [byte ebp-018h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B6A6C
        LD sub, ecx, eax
        jle short loc_B6A3A
loc_B6A6C:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte esi+04h]
        LD xor, edx, edx
        mov eax, dword [byte ebp-04h]
        LD mov, ebx, eax
        cmp eax, dword [dword_D30BC]
        jl short loc_B6A9A
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jl short loc_B6AC3
        LD sub, ecx, eax
        jle short loc_B6A3A
        LD mov, edx, eax
        jmp short loc_B6AC3
loc_B6A9A:
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B6A3A
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-018h], esi
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        jle short loc_B6A3A
        LD cmp, eax, esi
        jl short loc_B6ABD
        LD mov, eax, esi
loc_B6ABD:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
loc_B6AC3:
        LD or, ecx, ecx
        jle short loc_B6B10
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-018h]
        mov edx, dword [DrawRowBytes]
        sub edx, dword [byte ebp-0Ch]
        LD xor, bh, bh
        mov ah, 0FFh
loc_B6AF6:
        mov ecx, dword [byte ebp-0Ch]
loc_B6AF9:
        lodsb
        LD cmp, al, ah
        je short loc_B6B03
        stosb
        loop loc_B6AF9
        jmp short loc_B6B06
loc_B6B03:
        inc edi
        loop loc_B6AF9
loc_B6B06:
        add esi, dword [byte ebp-010h]
        LD add, edi, edx
        dec dword [byte ebp-014h]
        jg short loc_B6AF6
loc_B6B10:
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
        db 00h,00h
BlitShapeFastHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF4h
        push esi
        push edi
        mov edi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte edi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte edi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short loc_B6B79
BlitShapeFast:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF4h
        push esi
        push edi
        mov edi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov word [byte edi+0Ch], ax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        mov word [byte edi+0Eh], ax
        jmp short loc_B6B79
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF4h
        push esi
        push edi
        mov edi, dword [byte ebp+08h]
        movsx eax, word [byte edi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte edi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B6B79:
        movsx eax, word [byte edi+04h]
        mov dword [byte ebp-0Ch], eax
        movsx edx, word [byte edi+06h]
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        add edi, byte 10h
        cld
loc_B6B94:
        mov esi, dword [ebx]
        add esi, dword [DrawVideoBase]
        add esi, dword [byte ebp-04h]
        mov ecx, dword [byte ebp-0Ch]
loc_B6BA2:
        test ecx, 3
        je short loc_B6BAE
        movsb
        dec ecx
        jmp short loc_B6BA2
loc_B6BAE:
        shr ecx, 2
        rep movsd
        add ebx, byte 4
        dec edx
        jg short loc_B6B94
        pop edi
        pop esi
        leave
        ret
        db 00h,00h,00h
BlitArtKeyColourHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push es
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short loc_B6C1B
BlitArtKeyColour:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push es
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B6C1B
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE8h
        push es
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B6C1B:
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        lea edx, [byte esi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short loc_B6C43
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B6C70
        LD sub, ecx, eax
        jg short loc_B6C70
loc_B6C3D:
        pop edi
        pop esi
        pop ds
        pop es
        leave
        ret
loc_B6C43:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B6C3D
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-018h], edx
        movsx edx, word [byte esi+04h]
        mul edx
        mov edx, dword [byte ebp-018h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B6C70
        LD sub, ecx, eax
        jle short loc_B6C3D
loc_B6C70:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte esi+04h]
        LD xor, edx, edx
        mov eax, dword [byte ebp-04h]
        LD mov, ebx, eax
        cmp eax, dword [dword_D30BC]
        jl short loc_B6C9E
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jl short loc_B6CC7
        LD sub, ecx, eax
        jle short loc_B6C3D
        LD mov, edx, eax
        jmp short loc_B6CC7
loc_B6C9E:
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B6C3D
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-018h], esi
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        jle short loc_B6C3D
        LD cmp, eax, esi
        jl short loc_B6CC1
        LD mov, eax, esi
loc_B6CC1:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
loc_B6CC7:
        LD or, ecx, ecx
        jle short loc_B6D1C
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-018h]
        mov edx, dword [DrawRowBytes]
        sub edx, dword [byte ebp-0Ch]
        LD xor, bh, bh
        mov ah, 0FFh
loc_B6CFA:
        mov ecx, dword [byte ebp-0Ch]
loc_B6CFD:
        lodsb
        LD mov, bl, al
        mov al, byte [dword ebx+ColourRemap]
        LD cmp, al, ah
        je short loc_B6D0F
        stosb
        loop loc_B6CFD
        jmp short loc_B6D12
loc_B6D0F:
        inc edi
        loop loc_B6CFD
loc_B6D12:
        add esi, dword [byte ebp-010h]
        LD add, edi, edx
        dec dword [byte ebp-014h]
        jg short loc_B6CFA
loc_B6D1C:
        cwde
        pop edi
        pop esi
        pop ds
        pop es
        leave
        ret
        db 00h
BlitArtMaskedHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short loc_B6D79
BlitArtMasked:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B6D79
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B6D79:
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov edi, dword [ebx]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-04h]
        mov edx, dword [DrawRowBytes]
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        LD sub, edx, eax
        movsx eax, word [byte esi+06h]
        mov dword [byte ebp-010h], eax
        cld
        add esi, byte 10h
        LD xor, eax, eax
loc_B6DAC:
        mov ecx, dword [byte ebp-0Ch]
loc_B6DAF:
        lodsb
        mov al, byte [dword eax+ColourRemap]
        cmp al, 0FFh
        je short loc_B6DBF
        stosb
        loop loc_B6DAF
        jmp short loc_B6DC2
loc_B6DBF:
        inc edi
        loop loc_B6DAF
loc_B6DC2:
        LD add, edi, edx
        dec dword [byte ebp-010h]
        jg short loc_B6DAC
        pop edi
        pop esi
        leave
        ret
        db 00h,00h,00h
BlitShapeClippedHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push edi
        push esi
        mov edi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte edi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte edi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short loc_B6E31
BlitShapeClipped:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push edi
        push esi
        mov edi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov word [byte edi+0Ch], ax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        mov word [byte edi+0Eh], ax
        jmp short loc_B6E31
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push edi
        push esi
        mov edi, dword [byte ebp+08h]
        movsx eax, word [byte edi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte edi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B6E31:
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte edi+06h]
        lea edx, [byte edi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short loc_B6E57
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B6E84
        LD sub, ecx, eax
        jg short loc_B6E84
loc_B6E53:
        pop esi
        pop edi
        leave
        ret
loc_B6E57:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B6E53
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-010h], edx
        movsx edx, word [byte edi+04h]
        imul edx
        mov edx, dword [byte ebp-010h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B6E84
        LD sub, ecx, eax
        jle short loc_B6E53
loc_B6E84:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte edi+04h]
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_x0]
        jl short loc_B6EB2
        LD add, eax, ecx
        sub eax, dword [cliprect_x1]
        jl short loc_B6EDB
        LD sub, ecx, eax
        jle short loc_B6E53
        LD mov, edx, eax
        jmp short loc_B6EDB
loc_B6EB2:
        mov ebx, dword [cliprect_x0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B6E53
        LD mov, edi, ecx
        LD sub, edi, eax
        add dword [byte ebp-018h], edi
        mov edi, dword [cliprect_x1]
        LD sub, edi, ebx
        jle short loc_B6E53
        LD cmp, eax, edi
        jl short loc_B6ED5
        LD mov, eax, edi
loc_B6ED5:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
loc_B6EDB:
        LD or, ecx, ecx
        jle short loc_B6F46
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov esi, dword [ebx]
        add esi, dword [DrawVideoBase]
        add esi, dword [byte ebp-04h]
        mov edi, dword [byte ebp-018h]
        mov edx, dword [byte ebp-014h]
        mov ebx, dword [DrawRowBytes]
        sub ebx, dword [byte ebp-0Ch]
        cmp dword [byte ebp-010h], byte 0
        je short loc_B6F4B
        mov eax, dword [byte ebp-0Ch]
        shr eax, 1
        jae short loc_B6F39
        je short loc_B6F2E
loc_B6F1E:
        LD mov, ecx, eax
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        movsb
        add edi, dword [byte ebp-010h]
        LD add, esi, ebx
        dec edx
        jg short loc_B6F1E
        jmp short loc_B6F46
loc_B6F2E:
        movsb
        add edi, dword [byte ebp-010h]
        LD add, esi, ebx
        dec edx
        jg short loc_B6F2E
        jmp short loc_B6F46
loc_B6F39:
        LD mov, ecx, eax
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        add edi, dword [byte ebp-010h]
        LD add, esi, ebx
        dec edx
        jg short loc_B6F39
loc_B6F46:
        jmp near loc_B6E53
loc_B6F4B:
        mov eax, dword [byte ebp-0Ch]
        shr eax, 1
        mov dword [byte ebp-01Ch], eax
        jae short loc_B6F68
        je short loc_B6F78
loc_B6F57:
        mov ecx, dword [byte ebp-01Ch]
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        movsb
        LD add, esi, ebx
        dec edx
        jg short loc_B6F57
        jmp near loc_B6E53
loc_B6F68:
        mov ecx, dword [byte ebp-01Ch]
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        LD add, esi, ebx
        dec edx
        jg short loc_B6F68
        jmp near loc_B6E53
loc_B6F78:
        movsb
        LD add, esi, ebx
        inc ebx
        dec edx
        jg short loc_B6F78
        jmp near loc_B6E53
SetBitmapClip:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte esi+02Ch]
        cmp dword [DrawVideoBase], eax
        je short loc_B6FB7
        mov eax, dword [byte ebp+0Ch]
        mov edx, dword [byte ebp+010h]
        mov ecx, dword [byte ebp+014h]
        mov ebx, dword [byte ebp+018h]
        mov dword [byte esi+08h], eax
        mov dword [byte esi+010h], edx
        mov dword [byte esi+0Ch], ecx
        mov dword [byte esi+014h], ebx
        mov dword [byte esi+018h], eax
        mov dword [byte esi+01Ch], edx
        pop esi
        leave
        ret
loc_B6FB7:
        mov eax, dword [byte ebp+0Ch]
        mov edx, dword [byte ebp+010h]
        mov ecx, dword [byte ebp+014h]
        mov ebx, dword [byte ebp+018h]
        mov dword [byte esi+08h], eax
        mov dword [byte esi+010h], edx
        mov dword [byte esi+0Ch], ecx
        mov dword [byte esi+014h], ebx
        mov dword [cliprect_x0], eax
        mov dword [cliprect_x1], edx
        mov dword [cliprect_y0], ecx
        mov dword [cliprect_y1], ebx
        mov dword [byte esi+018h], eax
        mov dword [byte esi+01Ch], edx
        mov dword [dword_D30BC], eax
        mov dword [dword_D30C0], edx
        pop esi
        leave
        ret
        db 00h,00h
ShapeWidth:
        mov ebx, dword [byte esp+04h]
        movsx eax, word [byte ebx+04h]
        ret
ShapeHeight:
        mov ebx, dword [byte esp+04h]
        movsx eax, word [byte ebx+06h]
        ret
ShapeDataSize:
        mov ebx, dword [byte esp+04h]
        mov al, byte [ebx]
        LD or, al, al
        js short loc_B7027
        movsx eax, word [byte ebx+04h]
        movsx ebx, word [byte ebx+06h]
        imul eax, ebx
        add eax, byte 10h
        ret
loc_B7027:
        LD mov, edx, ebx
        add ebx, byte 0Eh
loc_B702C:
        add ebx, byte 2
        LD xor, ecx, ecx
        or cl, byte [ebx]
        je short loc_B7045
        jns short loc_B702C
loc_B7037:
        neg cl
        lea ebx, [byte ebx+ecx+01h]
        LD xor, ecx, ecx
        or cl, byte [ebx]
        js short loc_B7037
        jne short loc_B702C
loc_B7045:
        neg edx
        lea eax, [byte ebx+edx+01h]
        ret
FillRectSpansCore:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF0h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [esi]
        mov edx, dword [byte esi+04h]
        add eax, 80000000h
        adc edx, byte 0
        mov dword [byte ebp-04h], eax
        mov dword [byte ebp-08h], edx
        mov eax, dword [byte esi+08h]
        mov edx, dword [byte esi+0Ch]
        add eax, 80000000h
        adc edx, byte 0
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-010h], edx
        mov ecx, dword [byte esi+018h]
        mov al, byte [byte esi+01Ch]
        mov ebx, dword [byte esi+034h]
        jmp dword [nosplit cs:ebx*4+jpt_B708F]
jpt_B708F:
        dd loc_B70CF
        dd loc_B70CF
        dd loc_B710B
        dd loc_B714F
        dd loc_B7146
        dd loc_B7185
        dd loc_B7158
        dd loc_B71E5
        dd loc_B71B4
        dd loc_B70B7
loc_B70B7:
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+edx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-08h]
        mov byte [edi], al
        pop edi
        pop esi
        leave
        ret
loc_B70CF:
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+edx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-08h]
        test ecx, 3
        jne short loc_B70FC
        shr ecx, 2
        LD mov, ah, al
        LD mov, edx, eax
        shl eax, 10h
        LD mov, ax, dx
        rep stosd
        pop edi
        pop esi
        leave
        ret
loc_B70FC:
        LD mov, ah, al
        shr ecx, 1
        db 0F3h,066h,0ABh                       ; insn: rep stosw (nasm 3 emits 66h F3h)
        LD adc, ecx, ecx
        rep stosb
        pop edi
        pop esi
        leave
        ret
loc_B710B:
        mov ebx, dword [DrawRowBytes]
loc_B7111:
        mov edx, dword [byte esi+0Ch]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+edx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-08h]
        shr ecx, 1
        jae short loc_B712E
        mov byte [edi], al
        LD add, edi, ebx
loc_B712E:
        LD or, ecx, ecx
        je short loc_B7142
        lea edx, [nosplit ebx*2+00h]
loc_B7139:
        mov byte [edi], al
        mov byte [ebx+edi], al
        LD add, edi, edx
        loop loc_B7139
loc_B7142:
        pop edi
        pop esi
        leave
        ret
loc_B7146:
        mov ebx, dword [DrawRowBytes]
        inc ebx
        jmp short loc_B7111
loc_B714F:
        mov ebx, dword [DrawRowBytes]
        dec ebx
        jmp short loc_B7111
loc_B7158:
        mov edx, dword [byte esi+0Ch]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+edx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-08h]
        mov edx, dword [byte esi+030h]
        mov esi, dword [DrawRowBytes]
        mov ebx, dword [byte ebp-04h]
loc_B7179:
        mov byte [edi], al
        LD add, ebx, edx
        LD adc, edi, esi
        loop loc_B7179
        pop edi
        pop esi
        leave
        ret
loc_B7185:
        mov edx, dword [byte esi+0Ch]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+edx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-08h]
        mov edx, dword [byte esi+030h]
        mov esi, dword [DrawRowBytes]
        neg esi
        mov ebx, dword [byte ebp-04h]
loc_B71A8:
        mov byte [edi], al
        LD add, ebx, edx
        LD sbb, edi, esi
        loop loc_B71A8
        pop edi
        pop esi
        leave
        ret
loc_B71B4:
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+edx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-08h]
        mov edx, dword [byte esi+030h]
        mov esi, dword [DrawRowBytes]
        mov ebx, dword [byte ebp-0Ch]
loc_B71D2:
        mov byte [edi], al
        inc edi
        LD add, ebx, edx
        jb short loc_B71DF
        loop loc_B71D2
loc_B71DB:
        pop edi
        pop esi
        leave
        ret
loc_B71DF:
        LD add, edi, esi
        loop loc_B71D2
        jmp short loc_B71DB
loc_B71E5:
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+edx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-08h]
        mov edx, dword [byte esi+030h]
        mov esi, dword [DrawRowBytes]
        mov ebx, dword [byte ebp-0Ch]
loc_B7203:
        mov byte [edi], al
        dec edi
        LD add, ebx, edx
        jb short loc_B7210
        loop loc_B7203
loc_B720C:
        pop edi
        pop esi
        leave
        ret
loc_B7210:
        LD add, edi, esi
        loop loc_B7203
        jmp short loc_B720C
        db 00h,00h
UnpackArtRle:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFFCh
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov edi, dword [byte ebp+0Ch]
        LD mov, edx, edi
        mov ecx, 4
        rep movsd
        cmp dword [byte ebp+010h], byte 0
        jne short loc_B7280
        LD xor, ecx, ecx
        jmp short loc_B7271
loc_B7239:
        add esi, byte 2
        mov al, byte [byte esi-01h]
        push ecx
        LD mov, ah, al
        shl eax, 8
        LD mov, al, ah
        shl eax, 8
        LD mov, al, ah
        shr ecx, 2
        rep stosd
        pop ecx
        and ecx, byte 3
        rep stosb
        or cl, byte [esi]
        je short loc_B7277
        jns short loc_B7239
loc_B725D:
        inc esi
        neg cl
loc_B7260:
        test ecx, 3
        je short loc_B726C
        movsb
        dec ecx
        jmp short loc_B7260
loc_B726C:
        shr ecx, 2
        rep movsd
loc_B7271:
        or cl, byte [esi]
        js short loc_B725D
        jne short loc_B7239
loc_B7277:
        LD mov, eax, edx
        and byte [eax], 7Fh
        pop edi
        pop esi
        leave
        ret
loc_B7280:
        mov eax, dword [byte edi-0Ch]
        sub eax, dword [byte edi-08h]
        mov dword [byte edi-08h], eax
        LD mov, ebx, edi
        mov edx, dword [byte edi-0Ch]
        mov dword [byte ebp-04h], edx
        LD add, edi, edx
        dec edi
        LD xor, ecx, ecx
loc_B7296:
        mov cl, byte [esi]
        inc esi
        LD or, cl, cl
        jg short loc_B72A1
        jl short loc_B72B8
        jmp short loc_B72CF
loc_B72A1:
        mov al, byte [esi]
        std
loc_B72A4:
        stosb
        dec edx
        jne short loc_B72B2
        mov edx, dword [byte ebp-04h]
        LD add, ebx, edx
        LD mov, edi, ebx
        LD add, edi, edx
        dec edi
loc_B72B2:
        loop loc_B72A4
        cld
        inc esi
        jmp short loc_B7296
loc_B72B8:
        neg cl
loc_B72BA:
        lodsb
        std
        stosb
        cld
        dec edx
        jne short loc_B72CB
        mov edx, dword [byte ebp-04h]
        LD add, ebx, edx
        LD mov, edi, ebx
        LD add, edi, edx
        dec edi
loc_B72CB:
        loop loc_B72BA
        jmp short loc_B7296
loc_B72CF:
        mov edx, dword [byte ebp+0Ch]
        jmp short loc_B7277
SetBlitSource:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov dword [BlitSourcePtr], eax
        mov eax, dword [byte ebp+0Ch]
        mov dword [BlitColumnOffsets], eax
        leave
        ret
CopyRowKeyFF:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+0Ch]
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+010h]
        add esi, dword [BlitSourcePtr]
        add edi, dword [DrawVideoBase]
        mov edx, dword [BlitColumnOffsets]
loc_B7309:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        cmp al, 0FFh
        je short loc_B7314
        mov byte [edi], al
loc_B7314:
        add edx, byte 4
        inc edi
        loop loc_B7309
        pop edi
        pop esi
        leave
        ret
CopyRowRemapKeyed:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+0Ch]
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+010h]
        add esi, dword [BlitSourcePtr]
        add edi, dword [DrawVideoBase]
        mov edx, dword [BlitColumnOffsets]
        LD xor, eax, eax
loc_B7340:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        mov al, byte [dword eax+ColourRemap]
        mov byte [edi], al
        add edx, byte 4
        inc edi
        loop loc_B7340
        pop edi
        pop esi
        leave
        ret
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+0Ch]
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+010h]
        add esi, dword [BlitSourcePtr]
        add edi, dword [DrawVideoBase]
        mov edx, dword [BlitColumnOffsets]
        LD xor, eax, eax
loc_B7379:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        mov al, byte [dword eax+ColourRemap]
        cmp al, 0FFh
        je short loc_B738A
        mov byte [edi], al
loc_B738A:
        add edx, byte 4
        inc edi
        loop loc_B7379
        pop edi
        pop esi
        leave
        ret
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+0Ch]
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+010h]
        add esi, dword [BlitSourcePtr]
        add edi, dword [DrawVideoBase]
        mov edx, dword [BlitColumnOffsets]
        LD xor, eax, eax
loc_B73B6:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        cmp al, 0FFh
        je short loc_B73CD
        cmp al, 0FEh
        jne short loc_B73CB
        mov al, byte [edi]
        mov al, byte [dword eax+byte_D89E4]
loc_B73CB:
        mov byte [edi], al
loc_B73CD:
        add edx, byte 4
        inc edi
        loop loc_B73B6
        pop edi
        pop esi
        leave
        ret
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+0Ch]
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+010h]
        add esi, dword [BlitSourcePtr]
        add edi, dword [DrawVideoBase]
        mov edx, dword [BlitColumnOffsets]
        LD xor, eax, eax
loc_B73F9:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        mov al, byte [dword eax+ColourRemap]
        cmp al, 0FFh
        je short loc_B7416
        cmp al, 0FEh
        jne short loc_B7414
        mov al, byte [edi]
        mov al, byte [dword eax+byte_D89E4]
loc_B7414:
        mov byte [edi], al
loc_B7416:
        add edx, byte 4
        inc edi
        loop loc_B73F9
        pop edi
        pop esi
        leave
        ret
CopyRowFast:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+0Ch]
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+010h]
        add esi, dword [BlitSourcePtr]
        add edi, dword [DrawVideoBase]
        mov edx, dword [BlitColumnOffsets]
        cmp ecx, byte 8
        jg short loc_B7482
loc_B7445:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        mov byte [edi], al
        add edx, byte 4
        inc edi
        loop loc_B7445
        pop edi
        pop esi
        leave
        ret
loc_B7456:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        mov byte [edi], al
        inc edi
        add edx, byte 4
        dec ecx
        LD mov, ebx, ecx
        and ebx, byte 0FFFFFFFEh
        neg ebx
        and ebx, byte 1Eh
        sub ecx, byte 20h
        LD add, ecx, ebx
        LD sub, edi, ebx
        LD sub, edx, ebx
        LD sub, edx, ebx
        LD sub, edx, ebx
        LD sub, edx, ebx
        jmp dword [nosplit ebx*2+unk_B74AA]
loc_B7482:
        test edi, 1
        jne short loc_B7456
        LD mov, ebx, ecx
        and ebx, byte 0FFFFFFFEh
        neg ebx
        and ebx, byte 1Eh
        sub ecx, byte 20h
        LD add, ecx, ebx
        LD sub, edi, ebx
        LD sub, edx, ebx
        LD sub, edx, ebx
        LD sub, edx, ebx
        LD sub, edx, ebx
        jmp dword [nosplit ebx*2+unk_B74AA]
unk_B74AA:
        dd loc_B74F3
        dd loc_B7501
        dd loc_B7511
        dd loc_B7521
        dd loc_B7531
        dd loc_B7541
        dd loc_B7551
        dd loc_B7561
        dd loc_B7571
        dd loc_B7581
        dd loc_B7591
        dd loc_B75A1
        dd loc_B75B1
        dd loc_B75C1
        dd loc_B75D1
        dd loc_B75E1
loc_B74EA:
        add edi, byte 20h
        add edx, 80h
loc_B74F3:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+04h]
        mov ah, byte [ebx+esi]
        mov word [edi], ax
loc_B7501:
        mov ebx, dword [byte edx+08h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+0Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+02h], ax
loc_B7511:
        mov ebx, dword [byte edx+010h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+014h]
        mov ah, byte [ebx+esi]
        mov word [byte edi+04h], ax
loc_B7521:
        mov ebx, dword [byte edx+018h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+01Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+06h], ax
loc_B7531:
        mov ebx, dword [byte edx+020h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+024h]
        mov ah, byte [ebx+esi]
        mov word [byte edi+08h], ax
loc_B7541:
        mov ebx, dword [byte edx+028h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+02Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+0Ah], ax
loc_B7551:
        mov ebx, dword [byte edx+030h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+034h]
        mov ah, byte [ebx+esi]
        mov word [byte edi+0Ch], ax
loc_B7561:
        mov ebx, dword [byte edx+038h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+03Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+0Eh], ax
loc_B7571:
        mov ebx, dword [byte edx+040h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+044h]
        mov ah, byte [ebx+esi]
        mov word [byte edi+010h], ax
loc_B7581:
        mov ebx, dword [byte edx+048h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+04Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+012h], ax
loc_B7591:
        mov ebx, dword [byte edx+050h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+054h]
        mov ah, byte [ebx+esi]
        mov word [byte edi+014h], ax
loc_B75A1:
        mov ebx, dword [byte edx+058h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+05Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+016h], ax
loc_B75B1:
        mov ebx, dword [byte edx+060h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+064h]
        mov ah, byte [ebx+esi]
        mov word [byte edi+018h], ax
loc_B75C1:
        mov ebx, dword [byte edx+068h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+06Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+01Ah], ax
loc_B75D1:
        mov ebx, dword [byte edx+070h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+074h]
        mov ah, byte [ebx+esi]
        mov word [byte edi+01Ch], ax
loc_B75E1:
        mov ebx, dword [byte edx+078h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+07Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+01Eh], ax
        sub ecx, byte 20h
        jns near loc_B74EA
        and ecx, byte 1
        jne short loc_B7603
        pop edi
        pop esi
        leave
        ret
loc_B7603:
        mov ebx, dword [dword edx+080h]
        mov al, byte [ebx+esi]
        mov byte [byte edi+020h], al
        pop edi
        pop esi
        leave
        ret
        db 00h
BlitBlockShadowHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE8h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short loc_B766D
BlitBlockShadow:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE8h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B766D
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE8h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B766D:
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        lea edx, [byte esi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short loc_B7693
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B76C0
        LD sub, ecx, eax
        jg short loc_B76C0
loc_B768F:
        pop edi
        pop esi
        leave
        ret
loc_B7693:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B768F
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-018h], edx
        movsx edx, word [byte esi+04h]
        imul edx
        mov edx, dword [byte ebp-018h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B76C0
        LD sub, ecx, eax
        jle short loc_B768F
loc_B76C0:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte esi+04h]
        LD xor, edx, edx
        mov eax, dword [byte ebp-04h]
        LD mov, ebx, eax
        cmp eax, dword [dword_D30BC]
        jl short loc_B76EE
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jl short loc_B7717
        LD sub, ecx, eax
        jle short loc_B768F
        LD mov, edx, eax
        jmp short loc_B7717
loc_B76EE:
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B768F
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-018h], esi
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        jle short loc_B768F
        LD cmp, eax, esi
        jl short loc_B7711
        LD mov, eax, esi
loc_B7711:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
loc_B7717:
        LD or, ecx, ecx
        jle short loc_B7771
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-04h]
        mov esi, dword [byte ebp-018h]
        mov edx, dword [DrawRowBytes]
        sub edx, dword [byte ebp-0Ch]
        LD xor, eax, eax
loc_B7748:
        mov ecx, dword [byte ebp-0Ch]
loc_B774B:
        lodsb
        cmp al, 0FEh
        ja short loc_B7764
        je short loc_B7757
        stosb
        loop loc_B774B
        jmp short loc_B7767
loc_B7757:
        mov al, byte [edi]
        mov al, byte [dword eax+byte_D89E4]
        stosb
        loop loc_B774B
        jmp short loc_B7767
loc_B7764:
        inc edi
        loop loc_B774B
loc_B7767:
        add esi, dword [byte ebp-010h]
        LD add, edi, edx
        dec dword [byte ebp-014h]
        jg short loc_B7748
loc_B7771:
        pop edi
        pop esi
        leave
        ret
        db 00h,00h,00h
SetRemapTable:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov ecx, 40h
        mov esi, dword [byte ebp+08h]
        mov edi, byte_D89E4
        rep movsd
        pop edi
        pop esi
        leave
        ret
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov edi, dword [byte ebp+08h]
        mov esi, byte_D89E4
        mov ecx, 40h
        rep movsd
        pop edi
        pop esi
        leave
        ret
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov ecx, dword [byte ebp+0Ch]
        mov esi, dword [byte ebp+010h]
        mov edi, byte_D89E4
        mov ebx, dword [byte ebp+08h]
        lea edi, [ebx+edi]
        shr ecx, 2
        rep movsd
        mov ecx, dword [byte ebp+0Ch]
        and ecx, byte 3
        rep movsb
        pop edi
        pop esi
        leave
        ret
        db 00h
BlitBlockRemapKeyedHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short loc_B7828
BlitBlockRemapKeyed:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B7828
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B7828:
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov edx, dword [DrawRowBytes]
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        LD sub, edx, eax
        movsx eax, word [byte esi+06h]
        mov dword [byte ebp-010h], eax
        cld
        add esi, byte 10h
        mov ah, 0FEh
        mov ebx, byte_D89E4
loc_B7860:
        mov ecx, dword [byte ebp-0Ch]
loc_B7863:
        lodsb
        LD cmp, al, ah
        ja short loc_B7877
        je short loc_B786F
        stosb
        loop loc_B7863
        jmp short loc_B787A
loc_B786F:
        mov al, byte [edi]
        xlatb
        stosb
        loop loc_B7863
        jmp short loc_B787A
loc_B7877:
        inc edi
        loop loc_B7863
loc_B787A:
        LD add, edi, edx
        dec dword [byte ebp-010h]
        jg short loc_B7860
        pop edi
        pop esi
        pop ds
        leave
        ret
