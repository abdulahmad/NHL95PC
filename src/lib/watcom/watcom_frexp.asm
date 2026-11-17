; Watcom C runtime: frexp.
bits 32
%include "hockey.inc"
section s_B297E progbits alloc exec nowrite align=1
global BigIntNullHook, frexp_
;-----------------------------------------------------------------------------
; BigIntNullHook                                                  B297E  95 PC
; Empty big-integer compare hook
;-----------------------------------------------------------------------------
BigIntNullHook:
        pop edi
        ret
;-----------------------------------------------------------------------------
; frexp_                                                        B2980  library
; Run-time library frexp: splits a double into mantissa and exponent
;-----------------------------------------------------------------------------
frexp_:
        push eax
        push ebx
        push ecx
        push edx
        sub esp, byte 8
        mov eax, dword [byte esp+01Ch]
        mov ecx, dword [byte esp+01Ch]
        mov dword [esp], eax
        mov eax, dword [byte esp+020h]
        xor edx, edx
        mov dword [byte esp+04h], eax
        test eax, 7FFFFFFFh
        jne short .1
        test ecx, ecx
        je short .2
.1:
        mov edx, dword [byte esp+06h]
        and edx, 7FF0h
        mov ebx, dword [byte esp+06h]
        and edx, 0FFFFh
        and ebx, 800Fh
        sar edx, 4
        mov ecx, ebx
        mov word [byte esp+06h], bx
        or ecx, 3FE0h
        sub edx, 3FEh
        mov word [byte esp+06h], cx
.2:
        mov eax, dword [byte esp+024h]
        fld qword [esp]
        mov dword [eax], edx
        add esp, byte 8
        pop edx
        pop ecx
        pop ebx
        pop eax
        ret 0Ch
        db 00h
