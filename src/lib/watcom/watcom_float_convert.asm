; Watcom C runtime: floor, scaling and double conversion.
bits 32
%include "hockey.inc"
section s_B2220 progbits alloc exec nowrite align=1
extern __Bin2String, __CmpBigInt, __Rnd2Int, DblMaxHigh, DblMaxLow, DblMinusMaxHigh, DblMinusMaxLow, F64_neg1_floor_
extern F64_Scale10Max, F64_Scale10Min, frexp_, modf_, Pow10Table, Scale10Count, str_Inf, str_Nan
global __Nan_Inf_, floor_, _Scale_, _Scale10V_, __cvt_, ModfCore, DecimalToInt64, NormalizeDouble
;-----------------------------------------------------------------------------
; __Nan_Inf_                                                    B2220  library
; Run-time library: formats NaN and infinity
;-----------------------------------------------------------------------------
__Nan_Inf_:
        push ebx
        push edx
        sub esp, byte 8
        mov edx, dword [byte esp+01Ch]
        mov eax, dword [byte esp+014h]
        mov dword [esp], eax
        mov eax, dword [byte esp+018h]
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esp+06h]
        and eax, 7FF0h
        cmp ax, 7FF0h
        jne short .4
        mov bl, byte [byte esp+07h]
        mov eax, edx
        test bl, 80h
        je short .1
        lea eax, [byte edx+01h]
        mov byte [edx], 2Dh
.1:
        xor ebx, ebx
        xor edx, edx
        mov bx, word [byte esp+02h]
        mov dx, word [esp]
        or edx, ebx
        xor ebx, ebx
        mov bx, word [byte esp+04h]
        or edx, ebx
        mov ebx, dword [byte esp+06h]
        and bl, 0Fh
        xor bh, bh
        and ebx, 0FFFFh
        or edx, ebx
        jne short .2
        mov edx, dword [str_Inf]
        jmp short .3
.2:
        mov edx, dword [str_Nan]
.3:
        mov dword [eax], edx
        mov eax, 1
        jmp short .5
.4:
        xor eax, eax
.5:
        add esp, byte 8
        pop edx
        pop ebx
        ret 0Ch
;-----------------------------------------------------------------------------
; floor_                                                        B22A4  library
; Run-time library floor
;-----------------------------------------------------------------------------
floor_:
        push ebp
        mov ebp, esp
        push eax
        push ebx
        push edx
        sub esp, byte 8
        lea eax, [byte ebp-014h]
        push eax
        mov edx, dword [byte ebp+0Ch]
        push edx
        mov ebx, dword [byte ebp+08h]
        push ebx
        call modf_
        fldz
        fcompp
        fnstsw ax
        sahf
        jbe short .1
        fld qword [byte ebp-014h]
        fadd qword [F64_neg1_floor_]
        fstp qword [byte ebp-014h]
.1:
        fld qword [byte ebp-014h]
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ebx
        pop eax
        pop ebp
        ret 8
;-----------------------------------------------------------------------------
; _Scale_                                                       B22E0  library
; Run-time library: scales a double by a power of two
;-----------------------------------------------------------------------------
_Scale_:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, dword [byte ebp+010h]
        mov ebx, dword [byte ebp+014h]
        cmp eax, ecx
        je short .1
        mov edx, ecx
        sub edx, eax
        push edx
        mov edx, dword [byte ebp+0Ch]
        push edx
        mov esi, dword [byte ebp+08h]
        push esi
        call _Scale10V_
        fstp qword [byte ebp+08h]
.1:
        lea eax, [byte ebp+08h]
        mov edx, ebx
        call __Rnd2Int
        mov eax, ecx
        mov edx, ebx
        call __CmpBigInt
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret 10h
;-----------------------------------------------------------------------------
; _Scale10V_                                                    B2321  library
; Run-time library: scales a double by a power of ten
;-----------------------------------------------------------------------------
_Scale10V_:
        push eax
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 8
        mov ecx, dword [byte esp+028h]
        fld qword [byte esp+020h]
        fcomp qword [F64_Scale10Max]
        fnstsw ax
        sahf
        jne short .1
        mov eax, dword [DblMaxLow]
        mov dword [byte esp+020h], eax
        mov eax, dword [DblMaxHigh]
        jmp short .2
.1:
        fld qword [byte esp+020h]
        fcomp qword [F64_Scale10Min]
        fnstsw ax
        sahf
        jne short .3
        mov eax, dword [DblMinusMaxLow]
        mov dword [byte esp+020h], eax
        mov eax, dword [DblMinusMaxHigh]
.2:
        mov dword [byte esp+024h], eax
.3:
        mov eax, Scale10Count
        test ecx, ecx
        jge short .4
        mov edx, ecx
        neg edx
        cmp edx, 134h
        jle short .6
        fld qword [byte esp+020h]
        fdiv qword [Pow10Table]
        sub edx, 0D8h
        jmp short .5
.4:
        mov edx, ecx
        cmp ecx, 134h
        jle short .6
        fld qword [byte esp+020h]
        fmul qword [Pow10Table]
        lea edx, [dword ecx-0D8h]
.5:
        fstp qword [byte esp+020h]
.6:
        xor ebx, ebx
        mov esi, 3FF00000h
        mov dword [esp], ebx
        mov dword [byte esp+04h], esi
.7:
        movsx ebx, word [eax]
        cmp edx, ebx
        jl short .8
        fld qword [esp]
        fmul qword [byte eax+02h]
        sub edx, ebx
        fstp qword [esp]
.8:
        test edx, edx
        je short .9
        cmp word [eax], byte 1
        je short .7
        add eax, byte 0Ah
        jmp short .7
.9:
        test ecx, ecx
        jge short .10
        fld qword [byte esp+020h]
        fdiv qword [esp]
        jmp short .11
.10:
        fld qword [byte esp+020h]
        fmul qword [esp]
.11:
        fstp qword [byte esp+020h]
        fld qword [byte esp+020h]
        add esp, byte 8
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop eax
        ret 0Ch
;-----------------------------------------------------------------------------
; __cvt_                                                        B2408  library
; Run-time library: a double to its decimal digits
;-----------------------------------------------------------------------------
__cvt_:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 2Ch
        mov ebx, dword [byte ebp+010h]
        mov ecx, dword [byte ebp+014h]
        mov edi, dword [byte ebp+018h]
        mov edx, dword [byte ebp+020h]
        push edx
        mov esi, dword [byte ebp+0Ch]
        push esi
        mov eax, dword [byte ebp+08h]
        mov dword [edi], 0
        push eax
        mov dword [ecx], 0
        call __Nan_Inf_
        test eax, eax
        je short .1
        mov eax, edx
        jmp near .19
.1:
        xor edx, edx
        xor esi, esi
        mov word [byte ebp-02Ch], dx
        mov word [byte ebp-02Ah], si
        mov word [byte ebp-028h], dx
        mov word [byte ebp-026h], dx
        mov edx, dword [byte ebp+0Ch]
        mov esi, dword [byte ebp+08h]
        test edx, 7FFFFFFFh
        jne short .2
        test esi, esi
        je near .14
.2:
        fldz
        fcomp qword [byte ebp+08h]
        fnstsw ax
        sahf
        jbe short .3
        mov ah, byte [byte ebp+0Fh]
        xor ah, 80h
        mov dword [edi], 0FFFFFFFFh
        mov byte [byte ebp+0Fh], ah
.3:
        push ecx
        mov eax, dword [byte ebp+0Ch]
        push eax
        mov edx, dword [byte ebp+08h]
        push edx
        call frexp_
        mov edx, dword [ecx]
        fstp st0
        test edx, edx
        jge short .4
        neg edx
.4:
        mov eax, edx
        shl edx, 2
        sub edx, eax
        add edx, byte 5
        mov esi, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        mov esi, dword [ecx]
        mov edx, eax
        test esi, esi
        jge short .5
        neg edx
.5:
        mov eax, dword [byte ebp+01Ch]
        mov dword [ecx], edx
        cmp eax, byte 46h
        jne short .6
        add ebx, edx
.6:
        test ebx, ebx
        jl near .13
        cmp ebx, byte 10h
        jle short .7
        mov ebx, 10h
.7:
        xor al, al
        mov byte [byte ebp-018h], al
        lea eax, [byte ebp-024h]
        push eax
        mov esi, dword [byte ebp+0Ch]
        push esi
        mov eax, dword [byte ebp+08h]
        push eax
        call modf_
        fldz
        fcompp
        fnstsw ax
        sahf
        jne short .8
        cmp ebx, edx
        jle short .8
        mov ah, 1
        mov ebx, edx
        mov byte [byte ebp-018h], ah
.8:
        lea eax, [byte ebp-02Ch]
        push eax
        push ebx
        mov esi, dword [byte ebp+0Ch]
        push esi
        mov eax, dword [byte ebp+08h]
        push eax
        mov eax, dword [ecx]
        call _Scale_
        mov esi, eax
        test eax, eax
        je short .13
        mov esi, dword [byte ebp+01Ch]
        add dword [ecx], eax
        cmp esi, byte 46h
        je short .9
        cmp byte [byte ebp-018h], 0
        je short .10
.9:
        add ebx, eax
.10:
        cmp ebx, byte 1
        jge short .11
        mov ebx, 1
        jmp short .12
.11:
        cmp ebx, byte 10h
        jle short .12
        mov ebx, 10h
.12:
        lea eax, [byte ebp-02Ch]
        push eax
        push ebx
        mov eax, dword [byte ebp+0Ch]
        push eax
        mov esi, dword [byte ebp+08h]
        push esi
        mov eax, dword [ecx]
        call _Scale_
        test eax, eax
        jle short .13
        mov eax, dword [ecx]
        inc eax
        inc ebx
        mov dword [ecx], eax
.13:
        mov eax, dword [byte ebp-02Ch]
        sar eax, 10h
        mov dword [byte ebp-01Ch], eax
        mov eax, dword [byte ebp-02Eh]
        mov esi, dword [byte ebp-01Ch]
        sar eax, 10h
        or eax, esi
        mov esi, dword [byte ebp-02Ah]
        sar esi, 10h
        or eax, esi
        mov esi, dword [byte ebp-028h]
        sar esi, 10h
        or eax, esi
        jne short .14
        mov dword [edi], eax
        mov edi, dword [byte ebp+01Ch]
        mov dword [ecx], eax
        cmp edi, byte 46h
        jne short .14
        sub ebx, edx
.14:
        cmp ebx, byte 1
        jge short .15
        mov ebx, 1
        jmp short .16
.15:
        cmp ebx, byte 11h
        jle short .16
        mov ebx, 11h
.16:
        lea eax, [byte ebp-02Ch]
        lea edx, [byte ebp-040h]
        mov edi, dword [byte ebp+020h]
        lea esi, [byte ebp-040h]
        call __Bin2String
        push edi
.17:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je near .18
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short .17
.18:
        pop edi
        mov eax, edi
.19:
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret 1Ch
ModfCore:	;IDA: unknown_libname_5
        push ebp
        push esi
        push edi
        push ecx
        push ebx
        mov esi, edx
        mov ebp, eax
        mov eax, dword [byte ebp+00h]
        mov edx, dword [byte ebp+04h]
        db 087h,0EEh                            ; insn: xchg ebp,esi
        mov dword [byte ebp+00h], eax
        mov dword [byte ebp+04h], edx
        mov ecx, edx
        and ecx, 7FF00000h
        je short .1
        cmp ecx, 43300000h
        jb short .2
        db 087h,0F5h                            ; insn: xchg esi,ebp
.1:
        sub eax, eax
        mov dword [byte ebp+04h], eax
        mov dword [byte ebp+00h], eax
        pop ebx
        pop ecx
        pop edi
        pop esi
        pop ebp
        ret
.2:
        mov edi, ecx
        shr ecx, 14h
        sub cx, 3FFh
        jb short .1
        push edx
        sub eax, eax
        mov edx, 0FFF00000h
        cmp cl, 14h
        jbe short .3
        sar edx, 15h
        rcr eax, 1
        sub cl, 15h
        sar eax, cl
        jmp short .4
.3:
        sar edx, cl
.4:
        and dword [byte ebp+04h], edx
        and dword [byte ebp+00h], eax
        not edx
        not eax
        mov ebp, esi
        and edx, dword [byte ebp+04h]
        and eax, dword [byte ebp+00h]
        call NormalizeDouble
        pop esi
        or edx, edx
        je short .5
        and esi, 80000000h
        or edx, esi
.5:
        mov dword [byte ebp+04h], edx
        mov dword [byte ebp+00h], eax
        pop ebx
        pop ecx
        pop edi
        pop esi
        pop ebp
        ret
DecimalToInt64:	;IDA: unknown_libname_6
        push ebp
        push esi
        push edi
        push ecx
        push ebx
        push edx
        mov esi, eax
        sub edx, edx
        sub ecx, ecx
        sub eax, eax
.1:
        mov al, byte [esi]
        cmp al, 0
        je short .2
        mov edi, edx
        mov ebx, ecx
        add ecx, ecx
        adc edx, edx
        add ecx, ecx
        adc edx, edx
        add ecx, ebx
        adc edx, edi
        add ecx, ecx
        adc edx, edx
        and al, 0Fh
        add ecx, eax
        adc edx, byte 0
        inc esi
        jmp short .1
.2:
        mov eax, ecx
        mov edi, 43300000h
        call NormalizeDouble
        pop ebp
        mov dword [byte ebp+04h], edx
        mov dword [byte ebp+00h], eax
        pop ebx
        pop ecx
        pop edi
        pop esi
        pop ebp
        ret
;-----------------------------------------------------------------------------
; NormalizeDouble                              B26C9  95 PC, medium confidence
; Normalises a 64-bit mantissa and exponent into a double
;-----------------------------------------------------------------------------
NormalizeDouble:
        sub esi, esi
        or esi, eax
        or esi, edx
        je short .5
        test edx, 0FFF00000h
        jne short .2
.1:
        sub edi, 100000h
        add eax, eax
        adc edx, edx
        test edx, 0FFF00000h
        je short .1
        jmp short .4
.2:
        test edx, 0FFE00000h
        je short .4
.3:
        add edi, 100000h
        shr edx, 1
        rcr eax, 1
        rcr esi, 1
        test edx, 0FFE00000h
        jne short .3
        adc esi, esi
        adc eax, byte 0
        adc edx, byte 0
.4:
        and edx, 0FFFFFh
        or edx, edi
.5:
        ret
        db 00h,00h,00h,00h,00h,00h
