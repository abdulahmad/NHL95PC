; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_92DE0 progbits alloc exec nowrite align=1
extern FreeMemBlock, sub_8D714, sub_8DBC0, sub_B3ABC, sub_B3B19, sub_B3C60, sub_B3C74
global GetFileSize, sub_92DF0, sub_92E00, sub_92E40, loc_92E7B, loc_92EC1, sub_92ECC, sub_92EE4
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
        call sub_B3B19
        add esp, byte 14h
        mov ecx, dword [byte esp+08h]
        push ecx
        call sub_B3C60
        add esp, byte 4
        mov eax, dword [esp]
        add esp, byte 0Ch
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h
sub_92E40:
        push esi
        push edi
        sub esp, byte 0Ch
        mov edi, dword [byte esp+01Ch]
        mov edx, dword [byte esp+018h]
        push edx
        call sub_8D714
        mov esi, eax
        add esp, byte 4
        test eax, eax
        je short loc_92E7B
        push eax
        call sub_8DBC0
        add esp, byte 4
        push eax
        push edi
        push esi
        call sub_B3ABC
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
        call sub_B3B19
        add esp, byte 14h
        mov esi, dword [byte esp+08h]
        test esi, esi
        je short loc_92EC1
        push esi
        push edi
        mov eax, dword [byte esp+08h]
        push eax
        call sub_B3C74
        add esp, byte 0Ch
        mov edx, dword [esp]
        push edx
        call sub_B3C60
        add esp, byte 4
        mov esi, edi
loc_92EC1:
        mov eax, esi
        add esp, byte 0Ch
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
sub_92ECC:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call sub_92E40
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
sub_92EE4:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call sub_92E40
        add esp, byte 0Ch
        ret
