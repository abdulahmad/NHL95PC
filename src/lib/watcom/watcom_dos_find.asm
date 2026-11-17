; Watcom C runtime: DOS find first and next.
bits 32
%include "hockey.inc"
section s_90BB0 progbits alloc exec nowrite align=1
extern __doserror_, _Extender, CopyDtaIn
global _dos_findfirst_, _dos_findnext_, _dos_findclose_, CopyDtaOut
_dos_findfirst_:	;IDA: unknown_libname_1
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
        call CopyDtaOut
        pop ecx
        ret
_dos_findnext_:	;IDA: unknown_libname_2
        push edx
        mov edx, eax
        mov ah, 1Ah
        int 21h
        call CopyDtaIn
        mov ah, 4Fh
        int 21h
        call __doserror_
        call CopyDtaOut
        pop edx
        ret
;-----------------------------------------------------------------------------
; _dos_findclose_                              90BE9  95 PC, medium confidence
; Ends a DOS file search; always succeeds
;-----------------------------------------------------------------------------
_dos_findclose_:
        xor eax, eax
        ret
;-----------------------------------------------------------------------------
; CopyDtaOut                                   90BEC  95 PC, medium confidence
; Copies the DOS transfer area to the caller's find record under the DOS/4GW
; extender
;-----------------------------------------------------------------------------
CopyDtaOut:
        cmp byte [_Extender], 9
        jne short .1
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
.1:
        ret
