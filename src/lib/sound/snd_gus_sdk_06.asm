; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_B12A0 progbits alloc exec nowrite align=1
extern __GETDS, byte_F79A7, byte_F79A8, byte_F79D8, dword_D87A0, dword_D87A8, dword_D87AC, dword_D87B0
extern dword_D87B4, dword_D87B8, dword_D87BC, dword_D87C0, dword_D87C4, dword_D87C8, dword_D87CC, dword_D87D0
extern dword_D87D4, inp_, outp_, sub_B0BE4, word_D8760, word_D8762, word_D876C, word_D876E
extern word_D8772, word_D8776, word_D8778, word_F799E, word_F79A2
global sub_B12A0, loc_B12DD, loc_B12EC, loc_B1311, sub_B131C, loc_B1358, loc_B1365, loc_B1392
global sub_B13A1, loc_B13AF, sub_B13B5, loc_B13E7, loc_B13EF, loc_B13F6, loc_B13FB, sub_B1400
global sub_B145C, loc_B146B, loc_B1476, loc_B147B, sub_B1484, loc_B1493, loc_B149E, loc_B14A3
global sub_B14AC, loc_B14DA, loc_B14DC, sub_B14E4, loc_B1512, loc_B1514, sub_B151C, loc_B154A
global loc_B154C, sub_B1554, loc_B1573, loc_B158F, loc_B1594, sub_B1598, loc_B15B1, sub_B15B8
global loc_B15D1, sub_B15D8, loc_B15F1, sub_B15F8, loc_B1646, loc_B166D, sub_B1680, loc_B16A9
global loc_B16B3, sub_B16BC, loc_B16D8, loc_B16F3, loc_B1706, loc_B1735, loc_B1772, loc_B17B9
global loc_B1813, loc_B186E, loc_B1877, loc_B18C7, loc_B18DC, loc_B18F1, loc_B18F3, loc_B1902
global loc_B1917, loc_B192C, loc_B192E, loc_B1938
sub_B12A0:
        pusha
        push ds
        push es
        push fs
        push gs
        mov ebp, esp
        cld
        call __GETDS
        xor ah, ah
        mov al, byte [byte_F79A8]
        and eax, 0FFFFh
        call sub_B0BE4
        cmp word [word_F79A2], byte 0
        je short loc_B12DD
        mov bx, word [word_F799E]
        or bl, 2
        mov word [word_F799E], bx
        jmp short loc_B1311
loc_B12DD:
        mov ax, word [word_F79A2]
        inc word [word_F79A2]
        push ds
        pop es
loc_B12EC:
        and word [word_F799E], byte 0FFFDh
        call sub_B16BC
        test word [word_F799E], 2
        jne short loc_B12EC
        mov ax, word [word_F79A2]
        dec word [word_F79A2]
loc_B1311:
        pop gs
        pop fs
        pop es
        pop ds
        popa
        iret
        db 08Dh,040h,00h
sub_B131C:
        pusha
        push ds
        push es
        push fs
        push gs
        mov ebp, esp
        cld
        call __GETDS
        xor ah, ah
        mov al, byte [byte_F79A7]
        and eax, 0FFFFh
        call sub_B0BE4
        cmp dword [dword_D87A0], byte 0
        je short loc_B1358
        mov dx, word [word_F799E]
        or dl, 8
        mov word [word_F799E], dx
        jmp short loc_B1392
loc_B1358:
        mov eax, dword [dword_D87A0]
        inc dword [dword_D87A0]
        push ds
        pop es
loc_B1365:
        mov bx, word [word_F799E]
        and bl, 0F7h
        mov word [word_F799E], bx
        call sub_B15F8
        mov cx, word [word_F799E]
        test cl, 8
        jne short loc_B1365
        mov eax, dword [dword_D87A0]
        dec dword [dword_D87A0]
loc_B1392:
        pop gs
        pop fs
        pop es
        pop ds
        popa
        iret
        db 00h,00h,00h,00h,00h,00h,00h
sub_B13A1:
        push ecx
        push edx
        mov ecx, 0Ah
        mov dx, word [word_D8778]
loc_B13AF:
        in al, dx
        loopne loc_B13AF
        pop edx
        pop ecx
        ret
sub_B13B5:
        push ebx
        push ecx
        push esi
        cmp eax, 210h
        jb short loc_B13F6
        nop
        nop
        nop
        nop
        cmp eax, 260h
        ja short loc_B13F6
        nop
        nop
        nop
        nop
        movzx ebx, word [word_D8760]
        LD sub, eax, ebx
        je short loc_B13EF
        nop
        nop
        nop
        nop
        mov esi, word_D8760
        mov ecx, 0Dh
loc_B13E7:
        add word [esi], ax
        add esi, byte 2
        loop loc_B13E7
loc_B13EF:
        LD xor, eax, eax
        jmp short loc_B13FB
        db 090h,090h,090h
loc_B13F6:
        mov eax, 1
loc_B13FB:
        pop esi
        pop ecx
        pop ebx
        ret
        db 00h
sub_B1400:
        push ebp
        mov ebp, esp
        push edx
        xor edx, edx
        mov dword [dword_D87AC], edx
        mov dword [dword_D87B0], edx
        mov dword [dword_D87B4], edx
        mov dword [dword_D87B8], edx
        mov dword [dword_D87BC], edx
        mov dword [dword_D87C0], edx
        mov dword [dword_D87C4], edx
        mov dword [dword_D87C8], edx
        mov dword [dword_D87CC], edx
        mov dword [dword_D87D0], edx
        mov dword [dword_D87D4], edx
        mov dword [byte_F79D8], edx
        mov dword [dword_D87A8], edx
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 08Bh,0C0h
sub_B145C:
        push ebp
        mov ebp, esp
        push ebx
        mov ebx, eax
        cmp dword [eax], byte 0
        je short loc_B146B
        test edx, edx
        jne short loc_B1476
loc_B146B:
        pushfw
        cli
        mov dword [ebx], edx
        popfw
        xor eax, eax
        jmp short loc_B147B
loc_B1476:
        mov eax, 1
loc_B147B:
        lea esp, [byte ebp-04h]
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
sub_B1484:
        push ebp
        mov ebp, esp
        push ebx
        mov ebx, eax
        cmp dword [eax], byte 0
        je short loc_B1493
        test edx, edx
        jne short loc_B149E
loc_B1493:
        pushfw
        cli
        mov dword [ebx], edx
        popfw
        xor eax, eax
        jmp short loc_B14A3
loc_B149E:
        mov eax, 1
loc_B14A3:
        lea esp, [byte ebp-04h]
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
sub_B14AC:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov ebx, eax
        mov eax, dword_D87B0
        mov edx, ebx
        call sub_B145C
        test eax, eax
        je short loc_B14DA
        mov eax, dword_D87B4
        mov edx, ebx
        call sub_B145C
        test eax, eax
        je short loc_B14DA
        mov eax, 8
        jmp short loc_B14DC
loc_B14DA:
        xor eax, eax
loc_B14DC:
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 090h
sub_B14E4:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov ebx, eax
        mov eax, dword_D87B8
        mov edx, ebx
        call sub_B145C
        test eax, eax
        je short loc_B1512
        mov eax, dword_D87BC
        mov edx, ebx
        call sub_B145C
        test eax, eax
        je short loc_B1512
        mov eax, 8
        jmp short loc_B1514
loc_B1512:
        xor eax, eax
loc_B1514:
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 090h
sub_B151C:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov ebx, eax
        mov eax, dword_D87C0
        mov edx, ebx
        call sub_B145C
        test eax, eax
        je short loc_B154A
        mov eax, dword_D87C4
        mov edx, ebx
        call sub_B145C
        test eax, eax
        je short loc_B154A
        mov eax, 8
        jmp short loc_B154C
loc_B154A:
        xor eax, eax
loc_B154C:
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 090h
sub_B1554:
        push ebp
        mov ebp, esp
        cmp eax, byte 1
        jne short loc_B1573
        mov eax, dword_D87C8
        call sub_B1484
        test eax, eax
        je short loc_B1594
        mov eax, 8
        mov esp, ebp
        pop ebp
        ret
loc_B1573:
        cmp eax, byte 2
        jne short loc_B158F
        mov eax, dword_D87CC
        call sub_B1484
        test eax, eax
        je short loc_B1594
        mov eax, 8
        mov esp, ebp
        pop ebp
        ret
loc_B158F:
        mov eax, 0Dh
loc_B1594:
        mov esp, ebp
        pop ebp
        ret
sub_B1598:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        mov eax, dword_D87D4
        call sub_B1484
        test eax, eax
        je short loc_B15B1
        mov eax, 8
loc_B15B1:
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 090h
sub_B15B8:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        mov eax, dword_D87D0
        call sub_B1484
        test eax, eax
        je short loc_B15D1
        mov eax, 8
loc_B15D1:
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 090h
sub_B15D8:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        mov eax, dword_D87AC
        call sub_B1484
        test eax, eax
        je short loc_B15F1
        mov eax, 8
loc_B15F1:
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 090h
sub_B15F8:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push edi
        sub esp, byte 4
        pushfw
        cli
        inc dword [dword_D87A8]
        xor eax, eax
        mov ax, word [word_D8762]
        call inp_
        mov edx, eax
        mov dword [byte ebp-014h], eax
        test al, 3
        je short loc_B166D
        xor eax, eax
        mov ax, word [word_D876C]
        call inp_
        mov ebx, eax
        mov ecx, eax
        test dl, 1
        je short loc_B1646
        cmp dword [dword_D87D0], byte 0
        je short loc_B1646
        call dword [dword_D87D0]
loc_B1646:
        test byte [byte ebp-014h], 2
        je short loc_B166D
        xor eax, eax
        mov ax, word [word_D876E]
        call inp_
        mov edi, dword [dword_D87D4]
        mov edx, eax
        test edi, edi
        je short loc_B166D
        mov eax, ecx
        call dword [dword_D87D4]
loc_B166D:
        dec dword [dword_D87A8]
        popfw
        lea esp, [byte ebp-010h]
        pop edi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
sub_B1680:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        xor eax, eax
        cli
        mov ax, word [word_D8762]
        call inp_
        mov ebx, eax
        mov edx, eax
        mov al, byte [byte_F79A7]
        cmp al, byte [byte_F79A8]
        je short loc_B16A9
        and bl, 0FCh
        mov edx, ebx
loc_B16A9:
        test dl, 3
        je short loc_B16B3
        call sub_B15F8
loc_B16B3:
        mov eax, edx
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
sub_B16BC:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        pushfw
        cli
        mov ax, word [word_F79A2]
        inc word [word_F79A2]
        xor edi, edi
        xor esi, esi
loc_B16D8:
        call sub_B1680
        mov ebx, eax
        test eax, eax
        jne short loc_B16F3
        mov cx, word [word_F799E]
        test cl, 4
        je near loc_B1938
loc_B16F3:
        test bl, 80h
        jne short loc_B1706
        mov ax, word [word_F799E]
        test al, 4
        je near loc_B17B9
loc_B1706:
        xor eax, eax
        mov edx, 41h
        mov ax, word [word_D8772]
        call outp_
        xor eax, eax
        mov ax, word [word_D8776]
        call inp_
        test al, 40h
        jne short loc_B1735
        mov dx, word [word_F799E]
        test dl, 4
        je short loc_B1772
loc_B1735:
        mov cx, word [word_F799E]
        and cl, 0FBh
        mov word [word_F799E], cx
        cmp dword [dword_D87B0], byte 0
        je short loc_B1772
        mov eax, 1
        call dword [dword_D87B0]
        test eax, eax
        jne short loc_B1772
        cmp dword [dword_D87B4], byte 0
        je short loc_B1772
        mov eax, 1
        call dword [dword_D87B4]
loc_B1772:
        xor eax, eax
        mov edx, 49h
        mov ax, word [word_D8772]
        call outp_
        xor eax, eax
        mov ax, word [word_D8776]
        call inp_
        test al, 40h
        je short loc_B17B9
        cmp dword [dword_D87B0], byte 0
        je short loc_B17B9
        xor eax, eax
        call dword [dword_D87B0]
        test eax, eax
        jne short loc_B17B9
        cmp dword [dword_D87B4], byte 0
        je short loc_B17B9
        call dword [dword_D87B4]
loc_B17B9:
        test bl, 4
        je short loc_B1813
        xor eax, eax
        mov edx, 45h
        mov ax, word [word_D8772]
        call outp_
        xor eax, eax
        mov edx, dword [byte_F79D8]
        mov ax, word [word_D8776]
        and dl, 0FBh
        call outp_
        xor eax, eax
        mov edx, dword [byte_F79D8]
        mov ax, word [word_D8776]
        call outp_
        cmp dword [dword_D87C8], byte 0
        je short loc_B1813
        call dword [dword_D87C8]
        test eax, eax
        je short loc_B1813
        xor eax, eax
        mov dword [dword_D87C8], eax
loc_B1813:
        test bl, 8
        je short loc_B186E
        xor eax, eax
        mov edx, 45h
        mov ax, word [word_D8772]
        call outp_
        xor eax, eax
        mov edx, dword [byte_F79D8]
        mov ax, word [word_D8776]
        and dl, 0F7h
        call outp_
        xor eax, eax
        mov edx, dword [byte_F79D8]
        mov ax, word [word_D8776]
        call outp_
        cmp dword [dword_D87CC], byte 0
        je short loc_B186E
        call dword [dword_D87CC]
        test eax, eax
        je short loc_B186E
        xor ecx, ecx
        mov dword [dword_D87CC], ecx
loc_B186E:
        test bl, 60h
        je near loc_B16D8
loc_B1877:
        cli
        xor eax, eax
        mov edx, 8Fh
        mov ax, word [word_D8772]
        call outp_
        xor eax, eax
        mov ax, word [word_D8776]
        call inp_
        mov ch, al
        mov al, ch
        and al, 0C0h
        cmp al, 0C0h
        je near loc_B16D8
        mov al, ch
        mov ebx, 1
        and al, 1Fh
        xor edx, edx
        mov cl, al
        mov dl, al
        shl ebx, cl
        test ch, 80h
        jne short loc_B18F3
        test edi, ebx
        je short loc_B18C7
        mov eax, ebx
        not eax
        and edi, eax
        jmp short loc_B18F3
loc_B18C7:
        cmp dword [dword_D87B8], byte 0
        je short loc_B18DC
        mov eax, edx
        call dword [dword_D87B8]
        test eax, eax
        jne short loc_B18F1
loc_B18DC:
        cmp dword [dword_D87BC], byte 0
        je short loc_B18F3
        mov eax, edx
        call dword [dword_D87BC]
        test eax, eax
        je short loc_B18F3
loc_B18F1:
        or edi, ebx
loc_B18F3:
        test ch, 40h
        jne short loc_B192E
        test esi, ebx
        je short loc_B1902
        not ebx
        and esi, ebx
        jmp short loc_B192E
loc_B1902:
        cmp dword [dword_D87C0], byte 0
        je short loc_B1917
        mov eax, edx
        call dword [dword_D87C0]
        test eax, eax
        jne short loc_B192C
loc_B1917:
        cmp dword [dword_D87C4], byte 0
        je short loc_B192E
        mov eax, edx
        call dword [dword_D87C4]
        test eax, eax
        je short loc_B192E
loc_B192C:
        or esi, ebx
loc_B192E:
        call sub_B1680
        jmp near loc_B1877
loc_B1938:
        mov ax, word [word_F79A2]
        dec word [word_F79A2]
        popfw
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
