; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_B2720 progbits alloc exec nowrite align=1
global GusConvertAddr16, GusRegsToAddr, loc_B278E
GusConvertAddr16:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        and eax, 3FFFFh
        and edx, 0FFFC0000h
        sar eax, 1
        or eax, edx
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 090h
GusRegsToAddr:
        push ebp
        mov ebp, esp
        push ecx
        push esi
        mov ecx, eax
        xor eax, eax
        mov ax, dx
        sar eax, 9
        and dh, 1
        mov esi, eax
        xor eax, eax
        mov ax, dx
        xor edx, edx
        mov dx, cx
        sar edx, 9
        shl eax, 7
        and edx, byte 7Fh
        or eax, edx
        mov ecx, eax
        xor eax, eax
        mov ax, si
        mov edx, eax
        xor eax, eax
        shl edx, 10h
        mov ax, cx
        add eax, edx
        test bl, 1
        je short loc_B278E
        mov edx, eax
        add eax, eax
        and edx, 0C0000h
        and eax, 3FFFFh
        or eax, edx
loc_B278E:
        lea esp, [byte ebp-08h]
        pop esi
        pop ecx
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
