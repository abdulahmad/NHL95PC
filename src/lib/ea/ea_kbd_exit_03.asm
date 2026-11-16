; Keyboard handlers run on the way out of the program.
bits 32
%include "hockey.inc"
section s_98A40 progbits alloc exec nowrite align=1
extern DosOpenReadOnly, DosCloseFile
global DosFileInfo, loc_98A79
DosFileInfo:
        sub esp, byte 0Ch
        mov eax, esp
        push eax
        lea eax, [byte esp+08h]
        push eax
        lea eax, [byte esp+010h]
        push eax
        mov edx, dword [byte esp+01Ch]
        push edx
        call DosOpenReadOnly
        add esp, byte 10h
        mov ebx, dword [byte esp+08h]
        push ebx
        call DosCloseFile
        add esp, byte 4
        cmp dword [byte esp+08h], byte 0
        je short loc_98A79
        mov dword [byte esp+08h], 1
loc_98A79:
        mov eax, dword [byte esp+08h]
        add esp, byte 0Ch
        ret
