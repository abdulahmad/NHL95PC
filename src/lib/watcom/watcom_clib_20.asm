; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_93284 progbits alloc exec nowrite align=1
extern __setbits_, CLibBitMasks
global strcspn_
;-----------------------------------------------------------------------------
; strcspn_                                                      93284  library
; C run-time: length of the leading part of a string without any of the given
; characters
;-----------------------------------------------------------------------------
strcspn_:
        push ebx
        push ecx
        sub esp, byte 20h
        mov ebx, eax
        mov eax, esp
        call __setbits_
        xor ecx, ecx
        jmp short .2
.1:
        mov edx, eax
        shr edx, 3
        mov dl, byte [esp+edx]
        and eax, byte 7
        and edx, 0FFh
        mov al, byte [dword eax+CLibBitMasks]
        and eax, 0FFh
        test edx, eax
        jne short .3
        inc ecx
        inc ebx
.2:
        xor eax, eax
        mov al, byte [ebx]
        test eax, eax
        jne short .1
.3:
        mov eax, ecx
        add esp, byte 20h
        pop ecx
        pop ebx
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h
