; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_8EAEC progbits alloc exec nowrite align=1
extern randseed
global _dos_getdate_, _dos_gettime_, sub_8EB21, rand_, loc_8EB49, srand_, loc_8EB59
_dos_getdate_:
        push edx
        push ecx
        push ebx
        mov ebx, eax
        mov ah, 2Ah
        int 21h
        mov word [byte ebx+02h], cx
        mov byte [byte ebx+01h], dh
        mov byte [ebx], dl
        mov byte [byte ebx+04h], al
        sub eax, eax
        pop ebx
        pop ecx
        pop edx
        ret
_dos_gettime_:
        push edx
        push ecx
        push ebx
        mov ebx, eax
        mov ah, 2Ch
        int 21h
        mov byte [ebx], ch
        mov byte [byte ebx+01h], cl
        mov byte [byte ebx+02h], dh
        mov byte [byte ebx+03h], dl
        sub eax, eax
        pop ebx
        pop ecx
        pop edx
        ret
sub_8EB21:
        mov eax, randseed
        ret
rand_:
        push edx
        call sub_8EB21
        test eax, eax
        je short loc_8EB49
        imul edx, dword [eax], dword 41C64E6Dh
        add edx, 3039h
        mov dword [eax], edx
        mov eax, edx
        shr eax, 10h
        and eax, 7FFFh
loc_8EB49:
        pop edx
        ret
srand_:
        push edx
        mov edx, eax
        call sub_8EB21
        test eax, eax
        je short loc_8EB59
        mov dword [eax], edx
loc_8EB59:
        pop edx
        ret
