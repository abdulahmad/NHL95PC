; EA file helpers: file size and loading a file into a block.
bits 32
%include "hockey.inc"
section s_92DE0 progbits alloc exec nowrite align=1
extern bcopy, DosCloseFile, DosOpenFile, DosReadFile, FindCachedFileData, FreeMemBlock, MemPtrSize
global GetFileSize, GetFileSizeQuiet, GetFileSizeFlag, ReadFileCachedInto, LoadFileInto, LoadFileToBlockShared
;-----------------------------------------------------------------------------
; GetFileSize                                  92DE0  95 PC, medium confidence
; File library: size of the file at path (the roster editor remembers each
; database's size)
;-----------------------------------------------------------------------------
GetFileSize:
        push byte 1
        mov edx, dword [byte esp+08h]
        push edx
        call GetFileSizeFlag
        add esp, byte 8
        ret
;-----------------------------------------------------------------------------
; GetFileSizeQuiet                             92DF0  95 PC, medium confidence
; Returns a file's size without the error message
;-----------------------------------------------------------------------------
GetFileSizeQuiet:
        push byte 0
        mov edx, dword [byte esp+08h]
        push edx
        call GetFileSizeFlag
        add esp, byte 8
        ret
;-----------------------------------------------------------------------------
; GetFileSizeFlag                              92E00  95 PC, medium confidence
; Opens a file to read its size, with the caller's error flag
;-----------------------------------------------------------------------------
GetFileSizeFlag:
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
;-----------------------------------------------------------------------------
; ReadFileCachedInto                           92E40  95 PC, medium confidence
; Copies a cached file into a buffer, or reads it from disk
;-----------------------------------------------------------------------------
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
        je short .1
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
        jmp short .2
.1:
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
        je short .2
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
.2:
        mov eax, esi
        add esp, byte 0Ch
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; LoadFileInto                                                    92ECC  95 PC
; Loads a file into a buffer
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; LoadFileToBlockShared                        92EE4  95 PC, medium confidence
; Loads a file into a memory block in shared mode
;-----------------------------------------------------------------------------
LoadFileToBlockShared:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call ReadFileCachedInto
        add esp, byte 0Ch
        ret
