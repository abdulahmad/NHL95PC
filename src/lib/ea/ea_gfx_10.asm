; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_92DE0 progbits alloc exec nowrite align=1
extern FreeMemBlock, FindCachedFileData, MemPtrSize, bcopy, DosOpenFile, DosCloseFile, DosReadFile
global GetFileSize, sub_92DF0, sub_92E00, ReadFileCachedInto, loc_92E7B, loc_92EC1, LoadFileInto, LoadFileToBlockShared
GetFileSize:
        push byte 1
        mov edx, dword [byte esp+08h]
        push edx
        call sub_92E00
        add esp, byte 8
        ret
sub_92DF0:
        push byte 0
        mov edx, dword [byte esp+08h]
        push edx
        call sub_92E00
        add esp, byte 8
        ret
sub_92E00:
        sub esp, byte 0Ch
        mov edx, dword [byte esp+014h]
        push edx
        lea eax, [byte esp+04h]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        lea eax, [byte esp+014h]
        push eax
        mov ebx, dword [byte esp+020h]
        push ebx
        call DosOpenFile
        add esp, byte 14h
        mov ecx, dword [byte esp+08h]
        push ecx
        call DosCloseFile
        add esp, byte 4
        mov eax, dword [esp]
        add esp, byte 0Ch
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h
ReadFileCachedInto:
        push esi
        push edi
        sub esp, byte 0Ch
        mov edi, dword [byte esp+01Ch]
        mov edx, dword [byte esp+018h]
        push edx
        call FindCachedFileData
        mov esi, eax
        add esp, byte 4
        test eax, eax
        je short loc_92E7B
        push eax
        call MemPtrSize
        add esp, byte 4
        push eax
        push edi
        push esi
        call bcopy
        add esp, byte 0Ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        jmp short loc_92EC1
loc_92E7B:
        mov ebx, dword [byte esp+020h]
        push ebx
        lea eax, [byte esp+0Ch]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        mov ecx, dword [byte esp+028h]
        push ecx
        call DosOpenFile
        add esp, byte 14h
        mov esi, dword [byte esp+08h]
        test esi, esi
        je short loc_92EC1
        push esi
        push edi
        mov eax, dword [byte esp+08h]
        push eax
        call DosReadFile
        add esp, byte 0Ch
        mov edx, dword [esp]
        push edx
        call DosCloseFile
        add esp, byte 4
        mov esi, edi
loc_92EC1:
        mov eax, esi
        add esp, byte 0Ch
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
LoadFileInto:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call ReadFileCachedInto
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
LoadFileToBlockShared:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call ReadFileCachedInto
        add esp, byte 0Ch
        ret
