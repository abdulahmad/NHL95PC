; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_B028E progbits alloc exec nowrite align=1
extern __CHP, __cvt_, __Nan_Inf_, __set_ERANGE_, _Scale10V_, dword_C4CA0, dword_C4CA4, floor_
extern memset_, unknown_libname_6
global DoEFormat_, loc_B02A7, loc_B02AB, loc_B02CE, loc_B02DE, loc_B02EE, loc_B02F9, loc_B0329
global loc_B032C, loc_B0333, DoFFormat_, loc_B034A, loc_B035B, loc_B035F, loc_B0368, loc_B0370
global loc_B037C, loc_B0380, loc_B038D, AdjField_, loc_B03B8, loc_B03D5, loc_B03DF, loc_B03EF
global loc_B03FB, _FtoS_, loc_B042F, loc_B0435, loc_B0437, loc_B0444, loc_B046A, loc_B0497
global loc_B049D, loc_B04AD, loc_B04BE, loc_B04C8, loc_B04E0, loc_B04F4, loc_B0509, loc_B050E
global loc_B0527, loc_B0545, loc_B0577, loc_B0580, loc_B0582, loc_B05B3, loc_B05C4, loc_B05CA
global loc_B05DF, loc_B05F7, loc_B060A, loc_B061E, strtod_, loc_B0635, loc_B0646, loc_B0649
global loc_B065A, loc_B065C, loc_B0662, loc_B0674, loc_B0684, loc_B0694, loc_B0695, loc_B069A
global loc_B06B9, loc_B06D1, loc_B06D3, loc_B06D6, loc_B06F5, loc_B06FB, loc_B0702, loc_B070C
global loc_B070D, loc_B0710, loc_B0721, loc_B0730, loc_B073F, loc_B076F, loc_B0781, loc_B0798
global loc_B07AD, loc_B07B6, loc_B07C4
DoEFormat_:
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov esi, edx
        mov eax, ebx
        test edx, edx
        jge short loc_B02A7
        mov dh, 2Dh
        neg esi
        mov byte [esp], dh
        jmp short loc_B02AB
loc_B02A7:
        mov byte [esp], 2Bh
loc_B02AB:
        mov ebx, 64h
        mov edx, 3
        cmp esi, ebx
        jge short loc_B02CE
        mov ebx, 0Ah
        mov edx, 2
        cmp esi, ebx
        jge short loc_B02CE
        mov edx, 1
        mov ebx, edx
loc_B02CE:
        test eax, eax
        jne short loc_B02DE
        mov eax, 2
        cmp edx, byte 3
        jne short loc_B02DE
        mov eax, edx
loc_B02DE:
        lea ebp, [byte eax+01h]
        cmp ebp, ecx
        jg short loc_B032C
        cmp edx, eax
        jg short loc_B0329
        mov cl, byte [esp]
        mov byte [edi], cl
loc_B02EE:
        inc edi
        cmp eax, edx
        jle short loc_B02F9
        dec eax
        mov byte [edi], 30h
        jmp short loc_B02EE
loc_B02F9:
        mov edx, esi
        mov eax, esi
        sar edx, 1Fh
        idiv ebx
        mov edx, esi
        add eax, byte 30h
        sar edx, 1Fh
        mov byte [edi], al
        mov eax, esi
        idiv ebx
        mov esi, edx
        mov eax, ebx
        mov edx, ebx
        mov ebx, 0Ah
        sar edx, 1Fh
        idiv ebx
        inc edi
        mov ebx, eax
        test eax, eax
        jne short loc_B02F9
        jmp short loc_B032C
loc_B0329:
        lea ebp, [byte edx+01h]
loc_B032C:
        mov eax, ebp
        add esp, byte 4
        pop ebp
        pop edi
loc_B0333:
        pop esi
        ret
DoFFormat_:
        push esi
        mov esi, ebx
        test ecx, ecx
        jne short loc_B034A
        test ebx, ebx
        jg short loc_B034A
        mov byte [eax], 30h
        inc eax
        mov byte [eax], 2Eh
        inc eax
        pop esi
        ret
loc_B034A:
        test esi, esi
        jle short loc_B035B
        mov bl, byte [edx]
        test bl, bl
        je short loc_B035B
        inc edx
        dec esi
        mov byte [eax], bl
        inc eax
        jmp short loc_B034A
loc_B035B:
        test esi, esi
        jle short loc_B0368
loc_B035F:
        dec esi
        mov byte [eax], 30h
        inc eax
        test esi, esi
        jg short loc_B035F
loc_B0368:
        mov byte [eax], 2Eh
        inc eax
        test ecx, ecx
        jle short loc_B037C
loc_B0370:
        test esi, esi
        je short loc_B037C
        inc esi
        mov byte [eax], 30h
        inc eax
        dec ecx
        jne short loc_B0370
loc_B037C:
        test ecx, ecx
        jle short loc_B0333
loc_B0380:
        mov bh, byte [edx]
        test bh, bh
        je short loc_B038D
        inc edx
        mov byte [eax], bh
        inc eax
        dec ecx
        jne short loc_B0380
loc_B038D:
        test ecx, ecx
        je short loc_B0333
        dec ecx
        mov byte [eax], 30h
        inc eax
        jmp short loc_B038D
AdjField_:
        push ebp
        mov ebp, esp
        push ecx
        push esi
        push edi
        sub esp, byte 8
        mov edi, eax
        mov esi, edx
        cmp edx, ebx
        je short loc_B03FB
        mov dword [byte ebp-014h], edi
        mov al, byte [byte eax+01h]
        lea edx, [ebx+edi]
        mov byte [byte ebp-010h], al
        lea eax, [esi+edi]
loc_B03B8:
        dec eax
        dec edx
        mov cl, byte [eax]
        dec esi
        mov byte [edx], cl
        mov ecx, dword [byte ebp-014h]
        dec ebx
        cmp eax, ecx
        jne short loc_B03B8
        mov ah, byte [edi]
        cmp ah, 2Eh
        jne short loc_B03D5
        dec ebx
        mov byte [edi+ebx], 30h
        jmp short loc_B03EF
loc_B03D5:
        cmp ah, 2Bh
        je short loc_B03DF
        cmp ah, 2Dh
        jne short loc_B03EF
loc_B03DF:
        cmp byte [byte ebp-010h], 2Eh
        jne short loc_B03EF
        mov byte [edi+ebx], 30h
        dec ebx
        mov dl, byte [edi]
        mov byte [edi+ebx], dl
loc_B03EF:
        mov edx, 20h
        mov eax, edi
        call memset_
loc_B03FB:
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
_FtoS_:
        push ebp
        mov ebp, esp
        push esi
        push edi
        sub esp, byte 3Ch
        mov edi, dword [byte ebp+08h]
        mov dword [byte ebp-014h], eax
        mov byte [byte ebp-010h], cl
        lea eax, [byte ebp-044h]
        push eax
        mov ecx, dword [byte edx+04h]
        push ecx
        mov esi, dword [edx]
        push esi
        call __Nan_Inf_
        test eax, eax
        je short loc_B0444
        mov eax, dword [byte ebp-014h]
        xor esi, esi
        jmp short loc_B0437
loc_B042F:
        cmp esi, edi
        jge short loc_B0435
        mov byte [eax], ch
loc_B0435:
        inc eax
        inc esi
loc_B0437:
        mov ch, byte [byte esi+ebp-044h]
        test ch, ch
        jne short loc_B042F
        jmp near loc_B060A
loc_B0444:
        mov al, byte [byte ebp+018h]
        mov byte [byte ebp-0Ch], al
        cmp al, 47h
        jne near loc_B04C8
        fld qword [edx]
        fabs
        fstp qword [byte ebp-030h]
        mov eax, dword [byte ebp-02Ch]
        mov ecx, dword [byte ebp-030h]
        test eax, 7FFFFFFFh
        jne short loc_B046A
        test ecx, ecx
        je short loc_B04BE
loc_B046A:
        fld qword [byte ebp-030h]
        fldlg2
        fxch
        fyl2x
        fstp qword [byte ebp-030h]
        mov eax, dword [byte ebp-02Ch]
        push eax
        mov ecx, dword [byte ebp-030h]
        push ecx
        call floor_
        call __CHP
        fistp dword [byte ebp-018h]
        mov esi, dword [byte ebp-018h]
        cmp esi, byte 0FFFFFFFCh
        jl short loc_B0497
        cmp ebx, esi
        jg short loc_B049D
loc_B0497:
        mov byte [byte ebp-0Ch], 45h
        jmp short loc_B04C8
loc_B049D:
        fldz
        fcomp qword [byte ebp-030h]
        fnstsw ax
        sahf
        ja short loc_B04AD
        lea ecx, [byte esi+01h]
        mov dword [byte ebp-018h], ecx
loc_B04AD:
        mov esi, dword [byte ebp-018h]
        xor eax, eax
        mov ch, 46h
        mov dword [byte ebp+0Ch], eax
        mov byte [byte ebp-0Ch], ch
        sub ebx, esi
        jmp short loc_B04C8
loc_B04BE:
        xor esi, esi
        mov cl, 46h
        mov dword [byte ebp+0Ch], esi
        mov byte [byte ebp-0Ch], cl
loc_B04C8:
        cmp byte [byte ebp-0Ch], 45h
        jne short loc_B04F4
        mov eax, ebx
        mov ecx, dword [byte ebp+0Ch]
        neg eax
        cmp eax, ecx
        jge short loc_B04E0
        lea eax, [byte ebx+02h]
        cmp eax, ecx
        jg short loc_B04F4
loc_B04E0:
        mov eax, dword [byte ebp-014h]
        mov edx, 2Ah
        mov ebx, edi
        call memset_
        jmp near loc_B061E
loc_B04F4:
        mov al, byte [byte ebp+018h]
        mov ecx, ebx
        cmp al, 45h
        jne short loc_B050E
        mov eax, dword [byte ebp+0Ch]
        test eax, eax
        jle short loc_B0509
        lea ecx, [byte ebx+01h]
        jmp short loc_B050E
loc_B0509:
        jge short loc_B050E
        lea ecx, [eax+ebx]
loc_B050E:
        mov eax, dword [edx]
        mov dword [byte ebp-028h], eax
        mov eax, dword [byte edx+04h]
        mov edx, dword [byte ebp-028h]
        mov dword [byte ebp-024h], eax
        test eax, 7FFFFFFFh
        jne short loc_B0527
        test edx, edx
        je short loc_B0545
loc_B0527:
        cmp byte [byte ebp-0Ch], 45h
        je short loc_B0545
        mov ebx, dword [byte ebp+0Ch]
        test ebx, ebx
        je short loc_B0545
        push ebx
        mov eax, dword [byte ebp-024h]
        push eax
        mov edx, dword [byte ebp-028h]
        push edx
        call _Scale10V_
        fstp qword [byte ebp-028h]
loc_B0545:
        lea eax, [byte ebp-044h]
        push eax
        xor eax, eax
        mov al, byte [byte ebp-0Ch]
        push eax
        lea eax, [byte ebp-020h]
        push eax
        lea eax, [byte ebp-01Ch]
        push eax
        push ecx
        mov ebx, dword [byte ebp-024h]
        push ebx
        mov esi, dword [byte ebp-028h]
        push esi
        mov edx, dword [byte ebp-014h]
        call __cvt_
        mov ebx, dword [byte ebp-020h]
        lea eax, [byte edx+01h]
        test ebx, ebx
        je short loc_B0577
        mov byte [edx], 2Dh
        jmp short loc_B0580
loc_B0577:
        cmp byte [byte ebp-010h], 0
        je short loc_B0582
        mov byte [edx], 2Bh
loc_B0580:
        mov edx, eax
loc_B0582:
        cmp byte [byte ebp-0Ch], 45h
        jne short loc_B05DF
        mov ebx, dword [byte ebp+0Ch]
        mov eax, edx
        lea edx, [byte ebp-044h]
        sub ecx, ebx
        call DoFFormat_
        mov ecx, dword [byte ebp-014h]
        mov esi, eax
        mov ebx, eax
        sub esi, ecx
        mov cl, byte [byte ebp+014h]
        mov edx, eax
        test cl, cl
        je short loc_B05B3
        cmp esi, edi
        jge short loc_B05B3
        lea edx, [byte eax+01h]
        inc esi
        mov byte [eax], cl
loc_B05B3:
        mov eax, dword [byte ebp-024h]
        mov ebx, dword [byte ebp-028h]
        test eax, 7FFFFFFFh
        jne short loc_B05C4
        test ebx, ebx
        je short loc_B05CA
loc_B05C4:
        mov eax, dword [byte ebp+0Ch]
        sub dword [byte ebp-01Ch], eax
loc_B05CA:
        mov ebx, dword [byte ebp+010h]
        mov ecx, edi
        mov eax, edx
        mov edx, dword [byte ebp-01Ch]
        sub ecx, esi
        call DoEFormat_
        add esi, eax
        jmp short loc_B060A
loc_B05DF:
        mov esi, dword [byte ebp-014h]
        mov eax, dword [byte ebp-01Ch]
        mov ebx, edx
        inc eax
        sub ebx, esi
        add eax, ecx
        add eax, ebx
        cmp edi, eax
        jge short loc_B05F7
        lea esi, [byte edi+01h]
        jmp short loc_B060A
loc_B05F7:
        mov ebx, dword [byte ebp-01Ch]
        mov eax, edx
        lea edx, [byte ebp-044h]
        call DoFFormat_
        mov edx, esi
        mov esi, eax
        sub esi, edx
loc_B060A:
        cmp esi, edi
        jg near loc_B04E0
        mov eax, dword [byte ebp-014h]
        mov edx, esi
        mov ebx, edi
        call AdjField_
loc_B061E:
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 14h
strtod_:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 24h
        push edx
        mov dword [byte ebp-014h], eax
loc_B0635:
        mov dl, byte [eax]
        cmp dl, 20h
        je short loc_B0646
        cmp dl, 9
        jb short loc_B0649
        cmp dl, 0Dh
        ja short loc_B0649
loc_B0646:
        inc eax
        jmp short loc_B0635
loc_B0649:
        lea ebx, [byte eax+01h]
        xor cl, cl
        cmp dl, 2Bh
        je short loc_B065A
        cmp dl, 2Dh
        jne short loc_B065C
        mov cl, 1
loc_B065A:
        mov eax, ebx
loc_B065C:
        mov bl, 30h
        xor edx, edx
        xor esi, esi
loc_B0662:
        mov ch, byte [eax]
        inc eax
        cmp ch, 2Eh
        jne short loc_B0674
        test cl, 8
        jne short loc_B069A
        or cl, 8
        jmp short loc_B0662
loc_B0674:
        cmp ch, 30h
        jb short loc_B069A
        cmp ch, 39h
        ja short loc_B069A
        test cl, 8
        je short loc_B0684
        inc esi
loc_B0684:
        or bl, ch
        cmp bl, 30h
        je short loc_B0695
        cmp edx, byte 11h
        jge short loc_B0694
        mov byte [byte edx+ebp-034h], ch
loc_B0694:
        inc edx
loc_B0695:
        or cl, 4
        jmp short loc_B0662
loc_B069A:
        xor ebx, ebx
        test cl, 4
        je near loc_B0710
        cmp ch, 65h
        je short loc_B06B9
        cmp ch, 45h
        je short loc_B06B9
        cmp ch, 64h
        je short loc_B06B9
        cmp ch, 44h
        jne short loc_B070C
loc_B06B9:
        lea edi, [byte eax-01h]
        mov dword [byte ebp-018h], edi
        lea edi, [byte eax+01h]
        mov ch, byte [eax]
        cmp ch, 2Bh
        je short loc_B06D1
        cmp ch, 2Dh
        jne short loc_B06D3
        or cl, 2
loc_B06D1:
        mov eax, edi
loc_B06D3:
        and cl, 0FBh
loc_B06D6:
        mov ch, byte [eax]
        cmp ch, 30h
        jb short loc_B06FB
        cmp ch, 39h
        ja short loc_B06FB
        cmp ebx, 3E8h
        jge short loc_B06F5
        imul ebx, byte 0Ah
        movzx edi, ch
        add ebx, edi
        sub ebx, byte 30h
loc_B06F5:
        or cl, 4
        inc eax
        jmp short loc_B06D6
loc_B06FB:
        test cl, 2
        je short loc_B0702
        neg ebx
loc_B0702:
        test cl, 4
        jne short loc_B070D
        mov eax, dword [byte ebp-018h]
        jmp short loc_B070D
loc_B070C:
        dec eax
loc_B070D:
        mov dword [byte ebp-014h], eax
loc_B0710:
        sub ebx, esi
        cmp edx, byte 11h
        jle short loc_B0721
        sub edx, byte 11h
        add ebx, edx
        mov edx, 11h
loc_B0721:
        test edx, edx
        jle short loc_B0730
        cmp byte [byte edx+ebp-035h], 30h
        jne short loc_B0730
        inc ebx
        dec edx
        jmp short loc_B0721
loc_B0730:
        test edx, edx
        jne short loc_B073F
        mov dword [byte ebp-020h], edx
        mov dword [byte ebp-01Ch], edx
        jmp near loc_B07B6
loc_B073F:
        xor ah, ah
        mov byte [byte edx+ebp-034h], ah
        lea eax, [byte ebp-034h]
        lea edx, [byte ebp-020h]
        call unknown_libname_6
        cmp ebx, 134h
        jle short loc_B0781
        call __set_ERANGE_
        test cl, 1
        je short loc_B076F
        fld qword [dword_C4CA0]
        fchs
        fstp qword [byte ebp-020h]
        jmp short loc_B07B6
loc_B076F:
        mov eax, dword [dword_C4CA0]
        mov dword [byte ebp-020h], eax
        mov eax, dword [dword_C4CA4]
        mov dword [byte ebp-01Ch], eax
        jmp short loc_B07B6
loc_B0781:
        cmp ebx, 0FFFFFEBBh
        jge short loc_B0798
        xor ebx, ebx
        call __set_ERANGE_
        mov dword [byte ebp-020h], ebx
        mov dword [byte ebp-01Ch], ebx
        jmp short loc_B07B6
loc_B0798:
        test ebx, ebx
        je short loc_B07AD
        push ebx
        mov eax, dword [byte ebp-01Ch]
        push eax
        mov edx, dword [byte ebp-020h]
        push edx
        call _Scale10V_
        fstp qword [byte ebp-020h]
loc_B07AD:
        test cl, 1
        je short loc_B07B6
        xor byte [byte ebp-019h], 80h
loc_B07B6:
        cmp dword [byte ebp-038h], byte 0
        je short loc_B07C4
        mov edx, dword [byte ebp-038h]
        mov eax, dword [byte ebp-014h]
        mov dword [edx], eax
loc_B07C4:
        fld qword [byte ebp-020h]
        lea esp, [byte ebp-010h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
