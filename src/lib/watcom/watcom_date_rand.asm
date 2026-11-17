; Watcom C runtime: DOS date and time, rand and srand.
bits 32
%include "hockey.inc"
section s_8EAEC progbits alloc exec nowrite align=1
extern randseed
global _dos_getdate_, _dos_gettime_, GetRandState, rand_, srand_
;-----------------------------------------------------------------------------
; _dos_getdate_                                                 8EAEC  library
; Run-time library _dos_getdate: the DOS date
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; _dos_gettime_                                                 8EB07  library
; Run-time library _dos_gettime: the DOS time
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; GetRandState                                 8EB21  95 PC, medium confidence
; Returns the C library's rand state address
;-----------------------------------------------------------------------------
GetRandState:
        mov eax, randseed
        ret
;-----------------------------------------------------------------------------
; rand_                                                         8EB27  library
; Run-time library rand: the next random number
;-----------------------------------------------------------------------------
rand_:
        push edx
        call GetRandState
        test eax, eax
        je short .1
        imul edx, dword [eax], dword 41C64E6Dh
        add edx, 3039h
        mov dword [eax], edx
        mov eax, edx
        shr eax, 10h
        and eax, 7FFFh
.1:
        pop edx
        ret
;-----------------------------------------------------------------------------
; srand_                                                        8EB4B  library
; Run-time library srand: seeds the random numbers
;-----------------------------------------------------------------------------
srand_:
        push edx
        mov edx, eax
        call GetRandState
        test eax, eax
        je short .1
        mov dword [eax], edx
.1:
        pop edx
        ret
