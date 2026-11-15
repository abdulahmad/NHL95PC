; DOS/4GW glue. DPMI memory blocks and interrupt calls.
bits 32
%include "hockey.inc"
section s_98AC8 progbits alloc exec nowrite align=1
extern _Extender
global _dos_setvect_, loc_98AE9, _dos_getvect_, loc_98B10, loc_98B1C
_dos_setvect_:
        push edx
        mov edx, ebx
        mov bl, byte [_Extender]
        cmp bl, 2
        jb short loc_98AE9
        cmp bl, 8
        ja short loc_98AE9
        push ds
        mov ds, ecx
        mov cl, al
        mov al, 4
        mov ah, 25h
        int 21h
        pop ds
        pop edx
        ret
loc_98AE9:
        push ds
        mov ds, ecx
        mov ah, 25h
        int 21h
        pop ds
        pop edx
        ret
_dos_getvect_:
        push ebx
        push ecx
        mov ebx, eax
        mov ah, byte [_Extender]
        cmp ah, 2
        jb short loc_98B10
        cmp ah, 8
        ja short loc_98B10
        mov eax, 2502h
        mov cl, bl
        jmp short loc_98B1C
loc_98B10:
        mov eax, ebx
        and eax, 0FFh
        xor cl, cl
        or ah, 35h
loc_98B1C:
        push es
        int 21h
        mov edx, es
        pop es
        mov eax, ebx
        pop ecx
        pop ebx
        ret
