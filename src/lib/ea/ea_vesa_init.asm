; Bringing up a VESA graphics mode.
bits 32
%include "hockey.inc"
section s_8DF70 progbits alloc exec nowrite align=1
extern __STOSB, str_EavesaCom, str_CUtilEavesaCom, str_InitgraphicsEAVESACOM, str_CEavesaDat, str_InitgraphicsNEWVERSIONOF, str_VESA, str_InitgraphicsINITMEMMAN
extern str_InitgraphicsINVALIDSCREEN, str_VESAVideoBiosDriver, byte_EDABB, vesamodeok, byte_EDCC1, byte_EDCC3, byte_EDCC5, byte_EDCC7
extern dword_D2F80, dword_D2F88, dword_D2F8C, dword_D2F90, GraphicsReady, dword_D3044, dword_D3048, dword_D304C
extern dword_D3050, dword_D3054, dword_D3058, ScreenWidth, BackBufferWidth, dword_D30D8, dword_D30DC, dword_D30E0
extern dword_D30E4, dword_D30E8, dword_D30EC, dword_D30F0, dword_D30F4, dword_D30F8, ScreenRowTable, dword_D4108
extern dword_D4F4C, dword_D4F50, dword_EDABA, vesapresent, dword_EDCBC, FatalError, FreeMemBlock, spawnl_
extern strncmp_, MemPtrSize, OpenArtArchiveErr, DosFileInfo, bcopy, SaveTextMode, ZeroMem, SetScreenTarget
extern VesaSetBankArg, VesaSetMode, VgaSetModeTwice, vesamodeinfo, vesainfo, unlink_, word_EDBCA
global ProbeVesa, loc_8DF8B, loc_8DFB0, loc_8DFEA, loc_8E011, loc_8E06C, initgraphics, loc_8E0A0
global loc_8E0AE, loc_8E0C6, loc_8E0D5, loc_8E0DE, loc_8E0FA, loc_8E113, loc_8E12F, loc_8E148
global loc_8E161, loc_8E17A, loc_8E18E, loc_8E1A1, loc_8E1BF, loc_8E1D4, loc_8E1E3, loc_8E1FD
global loc_8E237, loc_8E24F, loc_8E254, loc_8E25F, loc_8E271, loc_8E27F, loc_8E28B, loc_8E295
global loc_8E29F, loc_8E2A9, loc_8E2BC, loc_8E2E0, loc_8E2F8, loc_8E376, loc_8E385, loc_8E38C
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
        jne short loc_8DF8B
        mov esi, str_CUtilEavesaCom
loc_8DF8B:
        push byte 0
        push esi
        push esi
        push byte 0
        call spawnl_
        add esp, byte 10h
        mov dword [vesapresent], eax
        cmp eax, byte 0FFFFFFFFh
        jne short loc_8DFB0
        push str_InitgraphicsEAVESACOM
        call FatalError
        add esp, byte 4
loc_8DFB0:
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
        je short loc_8DFEA
        push str_InitgraphicsNEWVERSIONOF
        call FatalError
        add esp, byte 4
loc_8DFEA:
        xor edx, edx
        mov dword [vesapresent], edx
        mov ebx, 4
        mov edx, str_VESA
        mov eax, esi
        call strncmp_
        test eax, eax
        jne short loc_8E011
        mov dword [vesapresent], 1
loc_8E011:
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
        jg short loc_8E06C
        push byte 1Ah
        push byte_EDCC1
        call ZeroMem
        add esp, byte 8
loc_8E06C:
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
        cmp dword [dword_D2F80], byte 0
        jne short loc_8E0A0
        push str_InitgraphicsINITMEMMAN
        call FatalError
        add esp, byte 4
loc_8E0A0:
        cmp dword [GraphicsReady], byte 0
        jne short loc_8E0AE
        call SaveTextMode
loc_8E0AE:
        cmp dword [dword_D2F88], byte 0
        jne short loc_8E0C6
        call ProbeVesa
        mov dword [dword_D2F88], 1
loc_8E0C6:
        cmp dword [byte esp+018h], byte 0
        jne short loc_8E0D5
        mov dword [byte esp+018h], 280h
loc_8E0D5:
        test ebp, ebp
        jne short loc_8E0DE
        mov ebp, 1E0h
loc_8E0DE:
        cmp dword [byte esp+018h], 140h
        jne short loc_8E0FA
        cmp ebp, 0C8h
        jne short loc_8E0FA
        mov esi, 0FFFFFFFFh
        jmp near loc_8E1A1
loc_8E0FA:
        cmp dword [byte esp+018h], 280h
        jne short loc_8E113
        cmp ebp, 190h
        jne short loc_8E113
        xor esi, esi
        jmp near loc_8E1A1
loc_8E113:
        cmp dword [byte esp+018h], 280h
        jne short loc_8E12F
        cmp ebp, 1E0h
        jne short loc_8E12F
        mov esi, 1
        jmp near loc_8E1A1
loc_8E12F:
        cmp dword [byte esp+018h], 320h
        jne short loc_8E148
        cmp ebp, 258h
        jne short loc_8E148
        mov esi, 3
        jmp short loc_8E1A1
loc_8E148:
        cmp dword [byte esp+018h], 400h
        jne short loc_8E161
        cmp ebp, 300h
        jne short loc_8E161
        mov esi, 5
        jmp short loc_8E1A1
loc_8E161:
        cmp dword [byte esp+018h], 500h
        jne short loc_8E17A
        cmp ebp, 400h
        jne short loc_8E17A
        mov esi, 7
        jmp short loc_8E1A1
loc_8E17A:
        mov edx, dword [byte esp+018h]
        cmp edx, byte 0FFFFFFFFh
        jne short loc_8E18E
        cmp ebp, edx
        jne short loc_8E18E
        mov esi, 5
        jmp short loc_8E1A1
loc_8E18E:
        push ebp
        mov ebx, dword [byte esp+01Ch]
        push ebx
        push str_InitgraphicsINVALIDSCREEN
        call FatalError
        add esp, byte 0Ch
loc_8E1A1:
        test esi, esi
        jl near loc_8E29F
        cmp dword [vesapresent], byte 0
        jne short loc_8E1BF
        push str_VESAVideoBiosDriver
        call FatalError
        add esp, byte 4
loc_8E1BF:
        xor edi, edi
        mov dword [dword_D4F50], edi
        mov ebx, dword [dword_EDABA]
        sar ebx, 10h
        test ebx, ebx
        je short loc_8E1E3
loc_8E1D4:
        cmp ebx, byte 40h
        jge short loc_8E1E3
        add ebx, ebx
        inc dword [dword_D4F50]
        jmp short loc_8E1D4
loc_8E1E3:
        xor eax, eax
        mov dword [dword_D4F4C], eax
        test byte [byte_EDABB], 1
        je short loc_8E1FD
        mov dword [dword_D4F4C], 1
loc_8E1FD:
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
loc_8E237:
        xor edi, edi
        cmp byte [esp+esi], 0
        je short loc_8E25F
        cmp dword [GraphicsReady], byte 0
        je short loc_8E24F
        mov eax, esi
        or ah, 81h
        jmp short loc_8E254
loc_8E24F:
        mov eax, esi
        or ah, 1
loc_8E254:
        push eax
        call VesaSetMode
        mov edi, eax
        add esp, byte 4
loc_8E25F:
        cmp di, byte 4Fh
        je short loc_8E295
        xor dh, dh
        mov byte [esp+esi], dh
        cmp esi, byte 1
        jne short loc_8E271
        xor esi, esi
loc_8E271:
        cmp esi, byte 8
        jge short loc_8E27F
        cmp byte [esp+esi], 0
        jne short loc_8E27F
        inc esi
        jmp short loc_8E271
loc_8E27F:
        cmp esi, byte 8
        jl short loc_8E295
        mov esi, 7
        xor eax, eax
loc_8E28B:
        cmp al, byte [esp+esi]
        jne short loc_8E295
        dec esi
        test esi, esi
        jge short loc_8E28B
loc_8E295:
        test esi, esi
        jl short loc_8E29F
        cmp di, byte 4Fh
        jne short loc_8E237
loc_8E29F:
        test esi, esi
        jl short loc_8E2A9
        cmp di, byte 4Fh
        je short loc_8E2E0
loc_8E2A9:
        cmp dword [GraphicsReady], byte 8
        jne short loc_8E2BC
        push byte 0
        call VesaSetBankArg
        add esp, byte 4
loc_8E2BC:
        mov esi, 13h
        push esi
        call VgaSetModeTwice
        add esp, byte 4
        mov ecx, 140h
        mov eax, 0C8h
        mov dword [GraphicsReady], 5
        jmp short loc_8E2F8
loc_8E2E0:
        mov ecx, dword [nosplit esi*8+dword_D2F8C]
        mov eax, dword [nosplit esi*8+dword_D2F90]
        mov dword [GraphicsReady], 8
loc_8E2F8:
        mov dword [dword_D3044], ecx
        mov dword [dword_D3048], eax
        mov ebx, dword [dword_D304C]
        mov ebp, ecx
        sub ebp, ebx
        mov dword [dword_D3054], ebp
        mov ebx, dword [dword_D3050]
        mov ebp, eax
        sub ebp, ebx
        mov dword [dword_D3058], ebp
        mov dword [BackBufferWidth], ecx
        mov dword [dword_D30D8], eax
        xor ebx, ebx
        mov dword [dword_D30DC], ebx
        mov dword [dword_D30E0], ebx
        mov dword [dword_D30E4], ecx
        mov dword [dword_D30E8], eax
        mov dword [dword_D30EC], ebx
        mov dword [dword_D30F0], ecx
        mov dword [dword_D30F4], ecx
        cmp esi, byte 13h
        setne bl
        and ebx, 0FFh
        mov dword [dword_D30F8], ebx
        xor ebx, ebx
        test eax, eax
        jle short loc_8E385
        xor esi, esi
        shl eax, 2
loc_8E376:
        mov dword [dword esi+ScreenRowTable], ebx
        add ebx, ecx
        add esi, byte 4
        cmp esi, eax
        jl short loc_8E376
loc_8E385:
        xor ebx, ebx
        mov esi, 10000h
loc_8E38C:
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ecx
        mov dword [dword ebx+dword_D4108], eax
        add ebx, byte 4
        add esi, 10000h
        cmp ebx, byte 50h
        jne short loc_8E38C
        call SetScreenTarget
        mov dword [dword_EDCBC], ScreenWidth
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret
        db 00h
