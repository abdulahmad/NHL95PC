; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_91CE7 progbits alloc exec nowrite align=1
extern __doopen_, close_file_
global sub_91CE7, loc_91D08
sub_91CE7:
        push ecx
        push esi
        mov esi, eax
        mov eax, ebx
        call close_file_
        mov ecx, eax
        test eax, eax
        je short loc_91D08
        and dword [byte eax+0Ch], 4000h
        mov eax, esi
        xor ebx, ebx
        call __doopen_
loc_91D08:
        pop esi
        pop ecx
        ret
