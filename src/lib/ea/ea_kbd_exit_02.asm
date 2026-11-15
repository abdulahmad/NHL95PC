; Keyboard handlers run on the way out of the program.
bits 32
%include "hockey.inc"
section s_986CC progbits alloc exec nowrite align=1
global sub_986CC, loc_986D8, sub_986E4
sub_986CC:
        mov eax, dword [byte esp+04h]
        cmp dword [eax], byte 0
        je short loc_986D8
        xor eax, eax
        ret
loc_986D8:
        mov dword [eax], 1
        mov eax, 1
        ret
sub_986E4:
        mov eax, dword [byte esp+04h]
        mov dword [eax], 0
        ret
