; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_B27A0 progbits alloc exec nowrite align=1
extern __CHP, sub_B28C9
global modf_, __CmpBigInt, loc_B27CC, loc_B27D5, loc_B27DD, loc_B27E0, loc_B27E9, loc_B27F1
global __Rnd2Int, loc_B281F, loc_B2828, loc_B282C, loc_B284C, loc_B2852, __Bin2String, loc_B2874
global loc_B2887, loc_B2889, loc_B289F, loc_B28C3
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
__CmpBigInt:
        push edi
        push ecx
        call sub_B28C9
        inc eax
        lea edi, [edi+eax*8]
        mov ecx, dword [edx]
        mov edx, dword [byte edx+04h]
        sub eax, eax
loc_B27CC:
        cmp edx, dword [cs:edi]
        jne short loc_B27D5
        cmp ecx, dword [byte cs:edi+04h]
loc_B27D5:
        jb short loc_B27DD
        add edi, byte 8
        inc eax
        jmp short loc_B27CC
loc_B27DD:
        sub edi, byte 8
loc_B27E0:
        cmp edx, dword [cs:edi]
        jne short loc_B27E9
        cmp ecx, dword [byte cs:edi+04h]
loc_B27E9:
        jae short loc_B27F1
        sub edi, byte 8
        dec eax
        jmp short loc_B27E0
loc_B27F1:
        pop ecx
        pop edi
        ret
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
        je short loc_B2852
        jbe short loc_B2828
loc_B281F:
        shl ecx, 1
        rcl ebx, 1
        dec ebp
        jne short loc_B281F
        jmp short loc_B2852
loc_B2828:
        sub eax, eax
        sub esi, esi
loc_B282C:
        shr ebx, 1
        rcr ecx, 1
        rcr eax, 1
        adc esi, esi
        inc ebp
        jne short loc_B282C
        cmp eax, 80000000h
        jb short loc_B2852
        jne short loc_B284C
        or esi, esi
        jne short loc_B284C
        test ecx, 1
        je short loc_B2852
loc_B284C:
        add ecx, byte 1
        adc ebx, byte 0
loc_B2852:
        pop ebp
        mov dword [byte ebp+00h], ecx
        mov dword [byte ebp+04h], ebx
        pop esi
        pop ebp
        pop edx
        pop ecx
        pop ebx
        ret
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
loc_B2874:
        pop eax
        mov edi, 2710h
        sub edx, edx
        or eax, eax
        jne short loc_B2887
        or ecx, ecx
        jne short loc_B2889
        push eax
        jmp short loc_B289F
loc_B2887:
        div edi
loc_B2889:
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
loc_B289F:
        add ax, 3030h
        add dx, 3030h
        sub ebp, byte 4
        mov byte [byte ebp+03h], al
        dec ebx
        je short loc_B28C3
        mov byte [byte ebp+02h], ah
        dec ebx
        je short loc_B28C3
        mov byte [byte ebp+01h], dl
        dec ebx
        je short loc_B28C3
        mov byte [byte ebp+00h], dh
        dec ebx
        jne short loc_B2874
loc_B28C3:
        pop eax
        pop ebx
        pop ecx
        pop edi
        pop ebp
        ret
