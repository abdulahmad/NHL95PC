; Bringing up a VESA graphics mode.
bits 32
%include "hockey.inc"
section s_8DF70 progbits alloc exec nowrite align=1
extern __STOSB, str_EavesaCom, str_CUtilEavesaCom, str_InitgraphicsEAVESACOM, str_CEavesaDat, str_InitgraphicsNEWVERSIONOF, str_VESA, str_InitgraphicsINITMEMMAN
extern str_InitgraphicsINVALIDSCREEN, str_VESAVideoBiosDriver, byte_EDABB, vesamodeok, byte_EDCC1, byte_EDCC3, byte_EDCC5, byte_EDCC7
extern MemDescriptors, VesaProbed, ModeWidthTable, ModeHeightTable, GraphicsReady, ViewScreenWidth, ViewScreenHeight, ViewMarginX
extern ViewMarginY, ViewMaxX, ViewMaxY, ScreenWidth, BackBufferWidth, ScreenBmHeight, ScreenBmClipX0, ScreenBmClipY0
extern ScreenBmClipX1, ScreenBmClipY1, ScreenBmOffset, ScreenBmRowBytes, ScreenBmPitch, ScreenBmBanked, ScreenRowTable, PutBlockScaleSteps
extern VesaBank, VesaWindowGranularity, dword_EDABA, vesapresent, ScreenWidthPtr, FatalError, FreeMemBlock, spawnl_
extern strncmp_, MemPtrSize, OpenArtArchiveErr, DosFileInfo, bcopy, SaveTextMode, ZeroMem, SetScreenTarget
extern VesaSetBankArg, VesaSetMode, VgaSetModeTwice, vesamodeinfo, vesainfo, unlink_, word_EDBCA
global ProbeVesa, initgraphics
ProbeVesa:
        push ebx
        push ecx
        push edx
        push esi
        mov esi, str_EavesaCom
        push esi
        call DosFileInfo
        add esp, byte 4
        test eax, eax
        jne short .1
        mov esi, str_CUtilEavesaCom
.1:
        push byte 0
        push esi
        push esi
        push byte 0
        call spawnl_
        add esp, byte 10h
        mov dword [vesapresent], eax
        cmp eax, byte 0FFFFFFFFh
        jne short .2
        push str_InitgraphicsEAVESACOM
        call FatalError
        add esp, byte 4
.2:
        push byte 0
        push str_CEavesaDat
        call OpenArtArchiveErr
        mov edx, eax
        add esp, byte 8
        mov esi, eax
        mov eax, str_CEavesaDat
        call unlink_
        push edx
        call MemPtrSize
        add esp, byte 4
        cmp eax, 41Ch
        je short .3
        push str_InitgraphicsNEWVERSIONOF
        call FatalError
        add esp, byte 4
.3:
        xor edx, edx
        mov dword [vesapresent], edx
        mov ebx, 4
        mov edx, str_VESA
        mov eax, esi
        call strncmp_
        test eax, eax
        jne short .4
        mov dword [vesapresent], 1
.4:
        push dword 100h
        push vesainfo
        push esi
        call bcopy
        add esp, byte 0Ch
        push dword 100h
        push vesamodeinfo
        lea eax, [dword esi+0100h]
        push eax
        call bcopy
        add esp, byte 0Ch
        push byte 1Bh
        push vesamodeok
        lea eax, [dword esi+0400h]
        push eax
        call bcopy
        add esp, byte 0Ch
        cmp word [word_EDBCA], byte 4
        jg short .5
        push byte 1Ah
        push byte_EDCC1
        call ZeroMem
        add esp, byte 8
.5:
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [vesapresent]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
initgraphics:
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov ebp, dword [byte esp+01Ch]
        cmp dword [MemDescriptors], byte 0
        jne short .1
        push str_InitgraphicsINITMEMMAN
        call FatalError
        add esp, byte 4
.1:
        cmp dword [GraphicsReady], byte 0
        jne short .2
        call SaveTextMode
.2:
        cmp dword [VesaProbed], byte 0
        jne short .3
        call ProbeVesa
        mov dword [VesaProbed], 1
.3:
        cmp dword [byte esp+018h], byte 0
        jne short .4
        mov dword [byte esp+018h], 280h
.4:
        test ebp, ebp
        jne short .5
        mov ebp, 1E0h
.5:
        cmp dword [byte esp+018h], 140h
        jne short .6
        cmp ebp, 0C8h
        jne short .6
        mov esi, 0FFFFFFFFh
        jmp near .13
.6:
        cmp dword [byte esp+018h], 280h
        jne short .7
        cmp ebp, 190h
        jne short .7
        xor esi, esi
        jmp near .13
.7:
        cmp dword [byte esp+018h], 280h
        jne short .8
        cmp ebp, 1E0h
        jne short .8
        mov esi, 1
        jmp near .13
.8:
        cmp dword [byte esp+018h], 320h
        jne short .9
        cmp ebp, 258h
        jne short .9
        mov esi, 3
        jmp short .13
.9:
        cmp dword [byte esp+018h], 400h
        jne short .10
        cmp ebp, 300h
        jne short .10
        mov esi, 5
        jmp short .13
.10:
        cmp dword [byte esp+018h], 500h
        jne short .11
        cmp ebp, 400h
        jne short .11
        mov esi, 7
        jmp short .13
.11:
        mov edx, dword [byte esp+018h]
        cmp edx, byte 0FFFFFFFFh
        jne short .12
        cmp ebp, edx
        jne short .12
        mov esi, 5
        jmp short .13
.12:
        push ebp
        mov ebx, dword [byte esp+01Ch]
        push ebx
        push str_InitgraphicsINVALIDSCREEN
        call FatalError
        add esp, byte 0Ch
.13:
        test esi, esi
        jl near .26
        cmp dword [vesapresent], byte 0
        jne short .14
        push str_VESAVideoBiosDriver
        call FatalError
        add esp, byte 4
.14:
        xor edi, edi
        mov dword [VesaWindowGranularity], edi
        mov ebx, dword [dword_EDABA]
        sar ebx, 10h
        test ebx, ebx
        je short .16
.15:
        cmp ebx, byte 40h
        jge short .16
        add ebx, ebx
        inc dword [VesaWindowGranularity]
        jmp short .15
.16:
        xor eax, eax
        mov dword [VesaBank], eax
        test byte [byte_EDABB], 1
        je short .17
        mov dword [VesaBank], 1
.17:
        mov ecx, 8
        xor edx, edx
        mov eax, esp
        call __STOSB
        mov al, byte [vesamodeok]
        mov byte [esp], al
        mov al, byte [byte_EDCC1]
        mov byte [byte esp+01h], al
        mov al, byte [byte_EDCC3]
        mov byte [byte esp+03h], al
        mov al, byte [byte_EDCC5]
        mov byte [byte esp+05h], al
        mov al, byte [byte_EDCC7]
        mov byte [byte esp+07h], al
.18:
        xor edi, edi
        cmp byte [esp+esi], 0
        je short .21
        cmp dword [GraphicsReady], byte 0
        je short .19
        mov eax, esi
        or ah, 81h
        jmp short .20
.19:
        mov eax, esi
        or ah, 1
.20:
        push eax
        call VesaSetMode
        mov edi, eax
        add esp, byte 4
.21:
        cmp di, byte 4Fh
        je short .25
        xor dh, dh
        mov byte [esp+esi], dh
        cmp esi, byte 1
        jne short .22
        xor esi, esi
.22:
        cmp esi, byte 8
        jge short .23
        cmp byte [esp+esi], 0
        jne short .23
        inc esi
        jmp short .22
.23:
        cmp esi, byte 8
        jl short .25
        mov esi, 7
        xor eax, eax
.24:
        cmp al, byte [esp+esi]
        jne short .25
        dec esi
        test esi, esi
        jge short .24
.25:
        test esi, esi
        jl short .26
        cmp di, byte 4Fh
        jne short .18
.26:
        test esi, esi
        jl short .27
        cmp di, byte 4Fh
        je short .29
.27:
        cmp dword [GraphicsReady], byte 8
        jne short .28
        push byte 0
        call VesaSetBankArg
        add esp, byte 4
.28:
        mov esi, 13h
        push esi
        call VgaSetModeTwice
        add esp, byte 4
        mov ecx, 140h
        mov eax, 0C8h
        mov dword [GraphicsReady], 5
        jmp short .30
.29:
        mov ecx, dword [nosplit esi*8+ModeWidthTable]
        mov eax, dword [nosplit esi*8+ModeHeightTable]
        mov dword [GraphicsReady], 8
.30:
        mov dword [ViewScreenWidth], ecx
        mov dword [ViewScreenHeight], eax
        mov ebx, dword [ViewMarginX]
        mov ebp, ecx
        sub ebp, ebx
        mov dword [ViewMaxX], ebp
        mov ebx, dword [ViewMarginY]
        mov ebp, eax
        sub ebp, ebx
        mov dword [ViewMaxY], ebp
        mov dword [BackBufferWidth], ecx
        mov dword [ScreenBmHeight], eax
        xor ebx, ebx
        mov dword [ScreenBmClipX0], ebx
        mov dword [ScreenBmClipY0], ebx
        mov dword [ScreenBmClipX1], ecx
        mov dword [ScreenBmClipY1], eax
        mov dword [ScreenBmOffset], ebx
        mov dword [ScreenBmRowBytes], ecx
        mov dword [ScreenBmPitch], ecx
        cmp esi, byte 13h
        setne bl
        and ebx, 0FFh
        mov dword [ScreenBmBanked], ebx
        xor ebx, ebx
        test eax, eax
        jle short .32
        xor esi, esi
        shl eax, 2
.31:
        mov dword [dword esi+ScreenRowTable], ebx
        add ebx, ecx
        add esi, byte 4
        cmp esi, eax
        jl short .31
.32:
        xor ebx, ebx
        mov esi, 10000h
.33:
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ecx
        mov dword [dword ebx+PutBlockScaleSteps], eax
        add ebx, byte 4
        add esi, 10000h
        cmp ebx, byte 50h
        jne short .33
        call SetScreenTarget
        mov dword [ScreenWidthPtr], ScreenWidth
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret
        db 00h
