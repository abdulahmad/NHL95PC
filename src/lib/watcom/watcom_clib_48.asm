; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_B028E progbits alloc exec nowrite align=1
extern __CHP, __cvt_, __Nan_Inf_, __set_ERANGE_, _Scale10V_, HugeValLo, HugeValHi, floor_
extern memset_, DecimalToInt64
global DoEFormat_, DoEFormat_, DoFFormat_, AdjField_, _FtoS_, strtod_
;-----------------------------------------------------------------------------
; DoEFormat_                                                    B028E  library
; Run-time library: formats a float in %e style
;-----------------------------------------------------------------------------
DoEFormat_:
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov esi, edx
        mov eax, ebx
        test edx, edx
        jge short .1
        mov dh, 2Dh
        neg esi
        mov byte [esp], dh
        jmp short .2
.1:
        mov byte [esp], 2Bh
.2:
        mov ebx, 64h
        mov edx, 3
        cmp esi, ebx
        jge short .3
        mov ebx, 0Ah
        mov edx, 2
        cmp esi, ebx
        jge short .3
        mov edx, 1
        mov ebx, edx
.3:
        test eax, eax
        jne short .4
        mov eax, 2
        cmp edx, byte 3
        jne short .4
        mov eax, edx
.4:
        lea ebp, [byte eax+01h]
        cmp ebp, ecx
        jg short .8
        cmp edx, eax
        jg short .7
        mov cl, byte [esp]
        mov byte [edi], cl
.5:
        inc edi
        cmp eax, edx
        jle short .6
        dec eax
        mov byte [edi], 30h
        jmp short .5
.6:
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
        jne short .6
        jmp short .8
.7:
        lea ebp, [byte edx+01h]
.8:
        mov eax, ebp
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
;-----------------------------------------------------------------------------
; DoFFormat_                                                    B0335  library
; Run-time library: formats a float in %f style
;-----------------------------------------------------------------------------
DoFFormat_:
        push esi
        mov esi, ebx
        test ecx, ecx
        jne short .1
        test ebx, ebx
        jg short .1
        mov byte [eax], 30h
        inc eax
        mov byte [eax], 2Eh
        inc eax
        pop esi
        ret
.1:
        test esi, esi
        jle short .2
        mov bl, byte [edx]
        test bl, bl
        je short .2
        inc edx
        dec esi
        mov byte [eax], bl
        inc eax
        jmp short .1
.2:
        test esi, esi
        jle short .4
.3:
        dec esi
        mov byte [eax], 30h
        inc eax
        test esi, esi
        jg short .3
.4:
        mov byte [eax], 2Eh
        inc eax
        test ecx, ecx
        jle short .6
.5:
        test esi, esi
        je short .6
        inc esi
        mov byte [eax], 30h
        inc eax
        dec ecx
        jne short .5
.6:
        test ecx, ecx
        jle short DoEFormat_+0A5h
.7:
        mov bh, byte [edx]
        test bh, bh
        je short .8
        inc edx
        mov byte [eax], bh
        inc eax
        dec ecx
        jne short .7
.8:
        test ecx, ecx
        je short DoEFormat_+0A5h
        dec ecx
        mov byte [eax], 30h
        inc eax
        jmp short .8
;-----------------------------------------------------------------------------
; AdjField_                                                     B0398  library
; Run-time library: pads a formatted number to its field width
;-----------------------------------------------------------------------------
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
        je short .5
        mov dword [byte ebp-014h], edi
        mov al, byte [byte eax+01h]
        lea edx, [ebx+edi]
        mov byte [byte ebp-010h], al
        lea eax, [esi+edi]
.1:
        dec eax
        dec edx
        mov cl, byte [eax]
        dec esi
        mov byte [edx], cl
        mov ecx, dword [byte ebp-014h]
        dec ebx
        cmp eax, ecx
        jne short .1
        mov ah, byte [edi]
        cmp ah, 2Eh
        jne short .2
        dec ebx
        mov byte [edi+ebx], 30h
        jmp short .4
.2:
        cmp ah, 2Bh
        je short .3
        cmp ah, 2Dh
        jne short .4
.3:
        cmp byte [byte ebp-010h], 2Eh
        jne short .4
        mov byte [edi+ebx], 30h
        dec ebx
        mov dl, byte [edi]
        mov byte [edi+ebx], dl
.4:
        mov edx, 20h
        mov eax, edi
        call memset_
.5:
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
;-----------------------------------------------------------------------------
; _FtoS_                                                        B0403  library
; Run-time library: a float to a string
;-----------------------------------------------------------------------------
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
        je short .4
        mov eax, dword [byte ebp-014h]
        xor esi, esi
        jmp short .3
.1:
        cmp esi, edi
        jge short .2
        mov byte [eax], ch
.2:
        inc eax
        inc esi
.3:
        mov ch, byte [byte esi+ebp-044h]
        test ch, ch
        jne short .1
        jmp near .25
.4:
        mov al, byte [byte ebp+018h]
        mov byte [byte ebp-0Ch], al
        cmp al, 47h
        jne near .10
        fld qword [edx]
        fabs
        fstp qword [byte ebp-030h]
        mov eax, dword [byte ebp-02Ch]
        mov ecx, dword [byte ebp-030h]
        test eax, 7FFFFFFFh
        jne short .5
        test ecx, ecx
        je short .9
.5:
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
        jl short .6
        cmp ebx, esi
        jg short .7
.6:
        mov byte [byte ebp-0Ch], 45h
        jmp short .10
.7:
        fldz
        fcomp qword [byte ebp-030h]
        fnstsw ax
        sahf
        ja short .8
        lea ecx, [byte esi+01h]
        mov dword [byte ebp-018h], ecx
.8:
        mov esi, dword [byte ebp-018h]
        xor eax, eax
        mov ch, 46h
        mov dword [byte ebp+0Ch], eax
        mov byte [byte ebp-0Ch], ch
        sub ebx, esi
        jmp short .10
.9:
        xor esi, esi
        mov cl, 46h
        mov dword [byte ebp+0Ch], esi
        mov byte [byte ebp-0Ch], cl
.10:
        cmp byte [byte ebp-0Ch], 45h
        jne short .12
        mov eax, ebx
        mov ecx, dword [byte ebp+0Ch]
        neg eax
        cmp eax, ecx
        jge short .11
        lea eax, [byte ebx+02h]
        cmp eax, ecx
        jg short .12
.11:
        mov eax, dword [byte ebp-014h]
        mov edx, 2Ah
        mov ebx, edi
        call memset_
        jmp near .26
.12:
        mov al, byte [byte ebp+018h]
        mov ecx, ebx
        cmp al, 45h
        jne short .14
        mov eax, dword [byte ebp+0Ch]
        test eax, eax
        jle short .13
        lea ecx, [byte ebx+01h]
        jmp short .14
.13:
        jge short .14
        lea ecx, [eax+ebx]
.14:
        mov eax, dword [edx]
        mov dword [byte ebp-028h], eax
        mov eax, dword [byte edx+04h]
        mov edx, dword [byte ebp-028h]
        mov dword [byte ebp-024h], eax
        test eax, 7FFFFFFFh
        jne short .15
        test edx, edx
        je short .16
.15:
        cmp byte [byte ebp-0Ch], 45h
        je short .16
        mov ebx, dword [byte ebp+0Ch]
        test ebx, ebx
        je short .16
        push ebx
        mov eax, dword [byte ebp-024h]
        push eax
        mov edx, dword [byte ebp-028h]
        push edx
        call _Scale10V_
        fstp qword [byte ebp-028h]
.16:
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
        je short .17
        mov byte [edx], 2Dh
        jmp short .18
.17:
        cmp byte [byte ebp-010h], 0
        je short .19
        mov byte [edx], 2Bh
.18:
        mov edx, eax
.19:
        cmp byte [byte ebp-0Ch], 45h
        jne short .23
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
        je short .20
        cmp esi, edi
        jge short .20
        lea edx, [byte eax+01h]
        inc esi
        mov byte [eax], cl
.20:
        mov eax, dword [byte ebp-024h]
        mov ebx, dword [byte ebp-028h]
        test eax, 7FFFFFFFh
        jne short .21
        test ebx, ebx
        je short .22
.21:
        mov eax, dword [byte ebp+0Ch]
        sub dword [byte ebp-01Ch], eax
.22:
        mov ebx, dword [byte ebp+010h]
        mov ecx, edi
        mov eax, edx
        mov edx, dword [byte ebp-01Ch]
        sub ecx, esi
        call DoEFormat_
        add esi, eax
        jmp short .25
.23:
        mov esi, dword [byte ebp-014h]
        mov eax, dword [byte ebp-01Ch]
        mov ebx, edx
        inc eax
        sub ebx, esi
        add eax, ecx
        add eax, ebx
        cmp edi, eax
        jge short .24
        lea esi, [byte edi+01h]
        jmp short .25
.24:
        mov ebx, dword [byte ebp-01Ch]
        mov eax, edx
        lea edx, [byte ebp-044h]
        call DoFFormat_
        mov edx, esi
        mov esi, eax
        sub esi, edx
.25:
        cmp esi, edi
        jg near .11
        mov eax, dword [byte ebp-014h]
        mov edx, esi
        mov ebx, edi
        call AdjField_
.26:
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 14h
;-----------------------------------------------------------------------------
; strtod_                                                       B0627  library
; Run-time library strtod: a string to a double
;-----------------------------------------------------------------------------
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
.1:
        mov dl, byte [eax]
        cmp dl, 20h
        je short .2
        cmp dl, 9
        jb short .3
        cmp dl, 0Dh
        ja short .3
.2:
        inc eax
        jmp short .1
.3:
        lea ebx, [byte eax+01h]
        xor cl, cl
        cmp dl, 2Bh
        je short .4
        cmp dl, 2Dh
        jne short .5
        mov cl, 1
.4:
        mov eax, ebx
.5:
        mov bl, 30h
        xor edx, edx
        xor esi, esi
.6:
        mov ch, byte [eax]
        inc eax
        cmp ch, 2Eh
        jne short .7
        test cl, 8
        jne short .11
        or cl, 8
        jmp short .6
.7:
        cmp ch, 30h
        jb short .11
        cmp ch, 39h
        ja short .11
        test cl, 8
        je short .8
        inc esi
.8:
        or bl, ch
        cmp bl, 30h
        je short .10
        cmp edx, byte 11h
        jge short .9
        mov byte [byte edx+ebp-034h], ch
.9:
        inc edx
.10:
        or cl, 4
        jmp short .6
.11:
        xor ebx, ebx
        test cl, 4
        je near .21
        cmp ch, 65h
        je short .12
        cmp ch, 45h
        je short .12
        cmp ch, 64h
        je short .12
        cmp ch, 44h
        jne short .19
.12:
        lea edi, [byte eax-01h]
        mov dword [byte ebp-018h], edi
        lea edi, [byte eax+01h]
        mov ch, byte [eax]
        cmp ch, 2Bh
        je short .13
        cmp ch, 2Dh
        jne short .14
        or cl, 2
.13:
        mov eax, edi
.14:
        and cl, 0FBh
.15:
        mov ch, byte [eax]
        cmp ch, 30h
        jb short .17
        cmp ch, 39h
        ja short .17
        cmp ebx, 3E8h
        jge short .16
        imul ebx, byte 0Ah
        movzx edi, ch
        add ebx, edi
        sub ebx, byte 30h
.16:
        or cl, 4
        inc eax
        jmp short .15
.17:
        test cl, 2
        je short .18
        neg ebx
.18:
        test cl, 4
        jne short .20
        mov eax, dword [byte ebp-018h]
        jmp short .20
.19:
        dec eax
.20:
        mov dword [byte ebp-014h], eax
.21:
        sub ebx, esi
        cmp edx, byte 11h
        jle short .22
        sub edx, byte 11h
        add ebx, edx
        mov edx, 11h
.22:
        test edx, edx
        jle short .23
        cmp byte [byte edx+ebp-035h], 30h
        jne short .23
        inc ebx
        dec edx
        jmp short .22
.23:
        test edx, edx
        jne short .24
        mov dword [byte ebp-020h], edx
        mov dword [byte ebp-01Ch], edx
        jmp near .29
.24:
        xor ah, ah
        mov byte [byte edx+ebp-034h], ah
        lea eax, [byte ebp-034h]
        lea edx, [byte ebp-020h]
        call DecimalToInt64
        cmp ebx, 134h
        jle short .26
        call __set_ERANGE_
        test cl, 1
        je short .25
        fld qword [HugeValLo]
        fchs
        fstp qword [byte ebp-020h]
        jmp short .29
.25:
        mov eax, dword [HugeValLo]
        mov dword [byte ebp-020h], eax
        mov eax, dword [HugeValHi]
        mov dword [byte ebp-01Ch], eax
        jmp short .29
.26:
        cmp ebx, 0FFFFFEBBh
        jge short .27
        xor ebx, ebx
        call __set_ERANGE_
        mov dword [byte ebp-020h], ebx
        mov dword [byte ebp-01Ch], ebx
        jmp short .29
.27:
        test ebx, ebx
        je short .28
        push ebx
        mov eax, dword [byte ebp-01Ch]
        push eax
        mov edx, dword [byte ebp-020h]
        push edx
        call _Scale10V_
        fstp qword [byte ebp-020h]
.28:
        test cl, 1
        je short .29
        xor byte [byte ebp-019h], 80h
.29:
        cmp dword [byte ebp-038h], byte 0
        je short .30
        mov edx, dword [byte ebp-038h]
        mov eax, dword [byte ebp-014h]
        mov dword [edx], eax
.30:
        fld qword [byte ebp-020h]
        lea esp, [byte ebp-010h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
