; Watcom C runtime: modf and big integer helpers.
bits 32
%include "hockey.inc"
section s_B27A0 progbits alloc exec nowrite align=1
extern __CHP, BigIntCallHook
global modf_, __CmpBigInt, __Rnd2Int, __Bin2String
;-----------------------------------------------------------------------------
; modf_                                                         B27A0  library
; Run-time library modf: splits a double into integer and fraction
;-----------------------------------------------------------------------------
modf_:
        push eax
        fld qword [byte esp+08h]
        fld st0
        call __CHP
        fsub to st1
        mov eax, dword [byte esp+010h]
        fstp qword [eax]
        pop eax
        wait
        ret 0Ch
        db 00h
;-----------------------------------------------------------------------------
; __CmpBigInt                                                   B27BA  library
; Run-time library: compares two big integers (float conversion)
;-----------------------------------------------------------------------------
__CmpBigInt:
        push edi
        push ecx
        call BigIntCallHook
        inc eax
        lea edi, [edi+eax*8]
        mov ecx, dword [edx]
        mov edx, dword [byte edx+04h]
        sub eax, eax
.1:
        cmp edx, dword [cs:edi]
        jne short .2
        cmp ecx, dword [byte cs:edi+04h]
.2:
        jb short .3
        add edi, byte 8
        inc eax
        jmp short .1
.3:
        sub edi, byte 8
.4:
        cmp edx, dword [cs:edi]
        jne short .5
        cmp ecx, dword [byte cs:edi+04h]
.5:
        jae short .6
        sub edi, byte 8
        dec eax
        jmp short .4
.6:
        pop ecx
        pop edi
        ret
;-----------------------------------------------------------------------------
; __Rnd2Int                                                     B27F4  library
; Run-time library: rounds a double to an integer
;-----------------------------------------------------------------------------
__Rnd2Int:
        push ebx
        push ecx
        push edx
        push ebp
        push esi
        push edx
        mov ebp, eax
        mov ecx, dword [byte ebp+00h]
        mov ebx, dword [byte ebp+04h]
        mov ebp, ebx
        and ebp, 0FFF00000h
        xor ebx, ebp
        xor ebx, 100000h
        shr ebp, 14h
        sub ebp, 433h
        je short .5
        jbe short .2
.1:
        shl ecx, 1
        rcl ebx, 1
        dec ebp
        jne short .1
        jmp short .5
.2:
        sub eax, eax
        sub esi, esi
.3:
        shr ebx, 1
        rcr ecx, 1
        rcr eax, 1
        adc esi, esi
        inc ebp
        jne short .3
        cmp eax, 80000000h
        jb short .5
        jne short .4
        or esi, esi
        jne short .4
        test ecx, 1
        je short .5
.4:
        add ecx, byte 1
        adc ebx, byte 0
.5:
        pop ebp
        mov dword [byte ebp+00h], ecx
        mov dword [byte ebp+04h], ebx
        pop esi
        pop ebp
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __Bin2String                                                  B285F  library
; Run-time library: a binary value to decimal digits
;-----------------------------------------------------------------------------
__Bin2String:
        push ebp
        push edi
        push ecx
        push ebx
        mov ebp, eax
        mov ecx, dword [byte ebp+00h]
        mov eax, dword [byte ebp+04h]
        mov ebp, edx
        add ebp, ebx
        mov byte [byte ebp+00h], 0
        push eax
.1:
        pop eax
        mov edi, 2710h
        sub edx, edx
        or eax, eax
        jne short .2
        or ecx, ecx
        jne short .3
        push eax
        jmp short .4
.2:
        div edi
.3:
        xchg ecx, eax
        div edi
        xchg ecx, eax
        push eax
        mov eax, edx
        mov dl, 64h
        div dl
        mov dl, ah
        mov ah, 0
        aam
        xchg edx, eax
        mov ah, 0
        aam
.4:
        add ax, 3030h
        add dx, 3030h
        sub ebp, byte 4
        mov byte [byte ebp+03h], al
        dec ebx
        je short .5
        mov byte [byte ebp+02h], ah
        dec ebx
        je short .5
        mov byte [byte ebp+01h], dl
        dec ebx
        je short .5
        mov byte [byte ebp+00h], dh
        dec ebx
        jne short .1
.5:
        pop eax
        pop ebx
        pop ecx
        pop edi
        pop ebp
        ret
