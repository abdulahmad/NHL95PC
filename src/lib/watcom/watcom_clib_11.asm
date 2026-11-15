; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_90BB0 progbits alloc exec nowrite align=1
extern __doserror_, _Extender, sub_90C0F
global unknown_libname_1, unknown_libname_2, sub_90BE9, sub_90BEC, loc_90C0E
unknown_libname_1:
        push ecx
        push eax
        push edx
        mov edx, ebx
        mov ah, 1Ah
        int 21h
        pop ecx
        pop edx
        mov ah, 4Eh
        int 21h
        call __doserror_
        mov edx, ebx
        call sub_90BEC
        pop ecx
        ret
unknown_libname_2:
        push edx
        mov edx, eax
        mov ah, 1Ah
        int 21h
        call sub_90C0F
        mov ah, 4Fh
        int 21h
        call __doserror_
        call sub_90BEC
        pop edx
        ret
sub_90BE9:
        xor eax, eax
        ret
sub_90BEC:
        cmp byte [_Extender], 9
        jne short loc_90C0E
        push eax
        push ebx
        push ecx
        push esi
        push edi
        mov ah, 2Fh
        int 21h
        mov esi, ebx
        mov edi, edx
        mov ecx, 2Bh
        rep movsb
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop eax
loc_90C0E:
        ret
