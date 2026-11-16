; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_B2220 progbits alloc exec nowrite align=1
extern __Bin2String, __CmpBigInt, __Rnd2Int, str_Inf, str_Nan, DblMaxLow, DblMaxHigh, DblMinusMaxLow
extern DblMinusMaxHigh, frexp_, modf_, F64_neg1_floor_, F64_Scale10Max, F64_Scale10Min, Pow10Table, Scale10Count
global __Nan_Inf_, loc_B2258, loc_B228B, loc_B2291, loc_B229A, loc_B229C, floor_, loc_B22D3
global _Scale_, loc_B2306, _Scale10V_, loc_B234C, loc_B2369, loc_B236D, loc_B2394, loc_B23AE
global loc_B23B2, loc_B23C0, loc_B23D2, loc_B23E1, loc_B23EE, loc_B23F5, __cvt_, loc_B2444
global loc_B246E, loc_B2487, loc_B249F, loc_B24BF, loc_B24CB, loc_B24DD, loc_B2507, loc_B2531
global loc_B2533, loc_B253F, loc_B2549, loc_B2567, loc_B259B, loc_B25A7, loc_B25B1, loc_B25C3
global loc_B25DF, loc_B25E2, ModfCore, loc_B2619, loc_B2627, loc_B264C, loc_B264E, loc_B2672
global DecimalToInt64, loc_B268C, loc_B26B0, NormalizeDouble, loc_B26D9, loc_B26ED, loc_B26F5, loc_B2711
global loc_B2719
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
        jne short loc_B229A
        mov bl, byte [byte esp+07h]
        mov eax, edx
        test bl, 80h
        je short loc_B2258
        lea eax, [byte edx+01h]
        mov byte [edx], 2Dh
loc_B2258:
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
        jne short loc_B228B
        mov edx, dword [str_Inf]
        jmp short loc_B2291
loc_B228B:
        mov edx, dword [str_Nan]
loc_B2291:
        mov dword [eax], edx
        mov eax, 1
        jmp short loc_B229C
loc_B229A:
        xor eax, eax
loc_B229C:
        add esp, byte 8
        pop edx
        pop ebx
        ret 0Ch
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
        jbe short loc_B22D3
        fld qword [byte ebp-014h]
        fadd qword [F64_neg1_floor_]
        fstp qword [byte ebp-014h]
loc_B22D3:
        fld qword [byte ebp-014h]
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ebx
        pop eax
        pop ebp
        ret 8
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
        je short loc_B2306
        mov edx, ecx
        sub edx, eax
        push edx
        mov edx, dword [byte ebp+0Ch]
        push edx
        mov esi, dword [byte ebp+08h]
        push esi
        call _Scale10V_
        fstp qword [byte ebp+08h]
loc_B2306:
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
        jne short loc_B234C
        mov eax, dword [DblMaxLow]
        mov dword [byte esp+020h], eax
        mov eax, dword [DblMaxHigh]
        jmp short loc_B2369
loc_B234C:
        fld qword [byte esp+020h]
        fcomp qword [F64_Scale10Min]
        fnstsw ax
        sahf
        jne short loc_B236D
        mov eax, dword [DblMinusMaxLow]
        mov dword [byte esp+020h], eax
        mov eax, dword [DblMinusMaxHigh]
loc_B2369:
        mov dword [byte esp+024h], eax
loc_B236D:
        mov eax, Scale10Count
        test ecx, ecx
        jge short loc_B2394
        mov edx, ecx
        neg edx
        cmp edx, 134h
        jle short loc_B23B2
        fld qword [byte esp+020h]
        fdiv qword [Pow10Table]
        sub edx, 0D8h
        jmp short loc_B23AE
loc_B2394:
        mov edx, ecx
        cmp ecx, 134h
        jle short loc_B23B2
        fld qword [byte esp+020h]
        fmul qword [Pow10Table]
        lea edx, [dword ecx-0D8h]
loc_B23AE:
        fstp qword [byte esp+020h]
loc_B23B2:
        xor ebx, ebx
        mov esi, 3FF00000h
        mov dword [esp], ebx
        mov dword [byte esp+04h], esi
loc_B23C0:
        movsx ebx, word [eax]
        cmp edx, ebx
        jl short loc_B23D2
        fld qword [esp]
        fmul qword [byte eax+02h]
        sub edx, ebx
        fstp qword [esp]
loc_B23D2:
        test edx, edx
        je short loc_B23E1
        cmp word [eax], byte 1
        je short loc_B23C0
        add eax, byte 0Ah
        jmp short loc_B23C0
loc_B23E1:
        test ecx, ecx
        jge short loc_B23EE
        fld qword [byte esp+020h]
        fdiv qword [esp]
        jmp short loc_B23F5
loc_B23EE:
        fld qword [byte esp+020h]
        fmul qword [esp]
loc_B23F5:
        fstp qword [byte esp+020h]
        fld qword [byte esp+020h]
        add esp, byte 8
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop eax
        ret 0Ch
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
        je short loc_B2444
        mov eax, edx
        jmp near loc_B25E2
loc_B2444:
        xor edx, edx
        xor esi, esi
        mov word [byte ebp-02Ch], dx
        mov word [byte ebp-02Ah], si
        mov word [byte ebp-028h], dx
        mov word [byte ebp-026h], dx
        mov edx, dword [byte ebp+0Ch]
        mov esi, dword [byte ebp+08h]
        test edx, 7FFFFFFFh
        jne short loc_B246E
        test esi, esi
        je near loc_B259B
loc_B246E:
        fldz
        fcomp qword [byte ebp+08h]
        fnstsw ax
        sahf
        jbe short loc_B2487
        mov ah, byte [byte ebp+0Fh]
        xor ah, 80h
        mov dword [edi], 0FFFFFFFFh
        mov byte [byte ebp+0Fh], ah
loc_B2487:
        push ecx
        mov eax, dword [byte ebp+0Ch]
        push eax
        mov edx, dword [byte ebp+08h]
        push edx
        call frexp_
        mov edx, dword [ecx]
        fstp st0
        test edx, edx
        jge short loc_B249F
        neg edx
loc_B249F:
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
        jge short loc_B24BF
        neg edx
loc_B24BF:
        mov eax, dword [byte ebp+01Ch]
        mov dword [ecx], edx
        cmp eax, byte 46h
        jne short loc_B24CB
        add ebx, edx
loc_B24CB:
        test ebx, ebx
        jl near loc_B2567
        cmp ebx, byte 10h
        jle short loc_B24DD
        mov ebx, 10h
loc_B24DD:
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
        jne short loc_B2507
        cmp ebx, edx
        jle short loc_B2507
        mov ah, 1
        mov ebx, edx
        mov byte [byte ebp-018h], ah
loc_B2507:
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
        je short loc_B2567
        mov esi, dword [byte ebp+01Ch]
        add dword [ecx], eax
        cmp esi, byte 46h
        je short loc_B2531
        cmp byte [byte ebp-018h], 0
        je short loc_B2533
loc_B2531:
        add ebx, eax
loc_B2533:
        cmp ebx, byte 1
        jge short loc_B253F
        mov ebx, 1
        jmp short loc_B2549
loc_B253F:
        cmp ebx, byte 10h
        jle short loc_B2549
        mov ebx, 10h
loc_B2549:
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
        jle short loc_B2567
        mov eax, dword [ecx]
        inc eax
        inc ebx
        mov dword [ecx], eax
loc_B2567:
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
        jne short loc_B259B
        mov dword [edi], eax
        mov edi, dword [byte ebp+01Ch]
        mov dword [ecx], eax
        cmp edi, byte 46h
        jne short loc_B259B
        sub ebx, edx
loc_B259B:
        cmp ebx, byte 1
        jge short loc_B25A7
        mov ebx, 1
        jmp short loc_B25B1
loc_B25A7:
        cmp ebx, byte 11h
        jle short loc_B25B1
        mov ebx, 11h
loc_B25B1:
        lea eax, [byte ebp-02Ch]
        lea edx, [byte ebp-040h]
        mov edi, dword [byte ebp+020h]
        lea esi, [byte ebp-040h]
        call __Bin2String
        push edi
loc_B25C3:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je near loc_B25DF
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short loc_B25C3
loc_B25DF:
        pop edi
        mov eax, edi
loc_B25E2:
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
        je short loc_B2619
        cmp ecx, 43300000h
        jb short loc_B2627
        db 087h,0F5h                            ; insn: xchg esi,ebp
loc_B2619:
        sub eax, eax
        mov dword [byte ebp+04h], eax
        mov dword [byte ebp+00h], eax
        pop ebx
        pop ecx
        pop edi
        pop esi
        pop ebp
        ret
loc_B2627:
        mov edi, ecx
        shr ecx, 14h
        sub cx, 3FFh
        jb short loc_B2619
        push edx
        sub eax, eax
        mov edx, 0FFF00000h
        cmp cl, 14h
        jbe short loc_B264C
        sar edx, 15h
        rcr eax, 1
        sub cl, 15h
        sar eax, cl
        jmp short loc_B264E
loc_B264C:
        sar edx, cl
loc_B264E:
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
        je short loc_B2672
        and esi, 80000000h
        or edx, esi
loc_B2672:
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
loc_B268C:
        mov al, byte [esi]
        cmp al, 0
        je short loc_B26B0
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
        jmp short loc_B268C
loc_B26B0:
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
NormalizeDouble:
        sub esi, esi
        or esi, eax
        or esi, edx
        je short loc_B2719
        test edx, 0FFF00000h
        jne short loc_B26ED
loc_B26D9:
        sub edi, 100000h
        add eax, eax
        adc edx, edx
        test edx, 0FFF00000h
        je short loc_B26D9
        jmp short loc_B2711
loc_B26ED:
        test edx, 0FFE00000h
        je short loc_B2711
loc_B26F5:
        add edi, 100000h
        shr edx, 1
        rcr eax, 1
        rcr esi, 1
        test edx, 0FFE00000h
        jne short loc_B26F5
        adc esi, esi
        adc eax, byte 0
        adc edx, byte 0
loc_B2711:
        and edx, 0FFFFFh
        or edx, edi
loc_B2719:
        ret
        db 00h,00h,00h,00h,00h,00h
