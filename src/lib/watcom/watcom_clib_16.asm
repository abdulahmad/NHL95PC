; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_92068 progbits alloc exec nowrite align=1
extern __close_, __IOMode_, __set_errno_, __set_errno_dos_, __SetIOMode_, dword_D4F21, dword_D5008, isatty_
extern lseek_
global open_, sopen_, loc_92098, loc_920A0, loc_920D3, loc_92115, loc_9213C, loc_9214D
global loc_92178, loc_92189, loc_921DB, loc_921F4, loc_92201, loc_9220A, loc_92213, loc_9221D
global loc_92231, loc_9223D, loc_9223F, loc_92248, __set_binary_, loc_92284, loc_92291, loc_922AC
global loc_922AE, read_, loc_922D6, loc_922E5, loc_922F0, loc_92314, loc_9231E, loc_92328
global loc_9234C, loc_92365, loc_92386, loc_92394, loc_92396, loc_923BD, loc_923C1, j___close_
global byteswap_, loc_923D9, loc_923E4, loc_923E9, loc_923F2, med3_, loc_92423, loc_92427
global loc_9242B, loc_92441, loc_92443, qsort_, loc_9246A, loc_92473, loc_92492, loc_924CC
global loc_924DA, loc_924DE, loc_924F3, loc_924FB, loc_924FE, loc_92516, loc_9251C, loc_9252A
global loc_92530, loc_9255F, loc_92612, loc_92623, loc_92643, loc_92653, loc_9265E, loc_9267E
global loc_926A9, loc_926B7, loc_926C0, loc_926C8, loc_926F5, loc_92709, loc_92712, loc_9271D
global loc_9273A, loc_92748, loc_9275C, loc_92788, loc_927A1, loc_927AC, loc_927B1, loc_927BA
global loc_927BB, loc_927D3, loc_927E9, loc_927F4, loc_927F9, loc_92802, loc_92803, loc_92841
global loc_9287B
open_:
        push ebx
        push edx
        lea eax, [byte esp+014h]
        add eax, byte 4
        mov eax, dword [byte eax-04h]
        push eax
        push byte 0
        mov edx, dword [byte esp+018h]
        push edx
        mov ebx, dword [byte esp+018h]
        push ebx
        call sopen_
        add esp, byte 10h
        pop edx
        pop ebx
        ret
sopen_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 0Ch
        mov esi, dword [byte esp+024h]
loc_92098:
        cmp byte [esi], 20h
        jne short loc_920A0
        inc esi
        jmp short loc_92098
loc_920A0:
        mov eax, dword [byte esp+028h]
        and eax, 83h
        mov dword [esp], eax
        mov dl, byte [byte esp+02Ch]
        mov al, byte [esp]
        or al, dl
        mov edx, esi
        mov edi, 0FFFFFFFFh
        mov ah, 3Dh
        int 21h
        rcl eax, 1
        ror eax, 1
        mov dword [byte esp+04h], eax
        test eax, eax
        jl short loc_920D3
        xor edi, edi
        mov di, word [byte esp+04h]
loc_920D3:
        mov dh, byte [byte esp+028h]
        test dh, 3
        je near loc_9214D
        cmp edi, byte 0FFFFFFFFh
        je short loc_9214D
        mov eax, edi
        call isatty_
        test eax, eax
        jne short loc_9214D
        test byte [byte esp+029h], 4
        je short loc_92115
        mov ebx, edi
        mov ah, 3Eh
        int 21h
        rcl eax, 1
        ror eax, 1
        mov eax, 7
        call __set_errno_
        mov eax, 0FFFFFFFFh
        jmp near loc_92248
loc_92115:
        test dh, 40h
        je short loc_9214D
        lea edx, [byte esp+08h]
        mov ebx, edi
        xor ecx, ecx
        mov ah, 40h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov dword [byte esp+04h], eax
        test eax, eax
        jge short loc_9214D
        mov ebx, edi
        mov ah, 3Eh
        int 21h
        rcl eax, 1
        ror eax, 1
loc_9213C:
        xor eax, eax
        mov ax, word [byte esp+04h]
        call __set_errno_dos_
        jmp near loc_92248
loc_9214D:
        cmp edi, byte 0FFFFFFFFh
        jne near loc_921DB
        test byte [byte esp+028h], 20h
        je short loc_9213C
        cmp word [byte esp+04h], byte 2
        jne short loc_9213C
        lea eax, [byte esp+030h]
        add eax, byte 4
        mov eax, dword [byte eax-04h]
        test eax, eax
        jne short loc_92178
        mov eax, 180h
loc_92178:
        xor eax, dword [dword_D5008]
        xor ecx, ecx
        test al, 80h
        jne short loc_92189
        mov ecx, 1
loc_92189:
        mov edx, esi
        and ecx, 0FFh
        mov ah, 3Ch
        int 21h
        rcl eax, 1
        ror eax, 1
        mov dword [byte esp+04h], eax
        test eax, eax
        jl short loc_9213C
        mov ebx, dword [byte esp+04h]
        mov ah, 3Eh
        int 21h
        rcl eax, 1
        ror eax, 1
        mov dword [byte esp+04h], eax
        test eax, eax
        jl short loc_9213C
        mov al, byte [esp]
        mov ch, byte [byte esp+02Ch]
        mov edx, esi
        or al, ch
        mov ah, 3Dh
        int 21h
        rcl eax, 1
        ror eax, 1
        mov dword [byte esp+04h], eax
        test eax, eax
        jl near loc_9213C
        xor edi, edi
        mov di, word [byte esp+04h]
loc_921DB:
        mov eax, edi
        call __IOMode_
        and al, 3Ch
        mov edx, eax
        mov eax, edi
        call isatty_
        test eax, eax
        je short loc_921F4
        or dh, 20h
loc_921F4:
        and byte [esp], 7Fh
        cmp dword [esp], byte 2
        jne short loc_92201
        or dl, 3
loc_92201:
        cmp dword [esp], byte 0
        jne short loc_9220A
        or dl, 1
loc_9220A:
        cmp dword [esp], byte 1
        jne short loc_92213
        or dl, 2
loc_92213:
        test byte [byte esp+028h], 10h
        je short loc_9221D
        or dl, 80h
loc_9221D:
        mov eax, edx
        mov bl, byte [byte esp+029h]
        or al, 40h
        test bl, 3
        je short loc_92231
        test bl, 2
        je short loc_9223F
        jmp short loc_9223D
loc_92231:
        cmp dword [dword_D4F21], 200h
        jne short loc_9223F
loc_9223D:
        mov edx, eax
loc_9223F:
        mov eax, edi
        call __SetIOMode_
        mov eax, edi
loc_92248:
        add esp, byte 0Ch
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
__set_binary_:
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 4
        mov esi, eax
        call __IOMode_
        or al, 40h
        mov ebx, eax
        mov eax, esi
        mov edx, ebx
        call __SetIOMode_
        test bh, 20h
        je short loc_922AC
        mov ebx, esi
        mov al, 0
        mov ah, 44h
        int 21h
        rcl edx, 1
        ror edx, 1
        mov dword [esp], edx
        test edx, edx
        jge short loc_92291
loc_92284:
        xor eax, eax
        mov ax, word [esp]
        call __set_errno_dos_
        jmp short loc_922AE
loc_92291:
        mov dl, byte [esp]
        mov ebx, esi
        or dl, 20h
        mov dh, 0
        mov al, 1
        mov ah, 44h
        int 21h
        rcl edx, 1
        ror edx, 1
        mov dword [esp], edx
        test edx, edx
        jl short loc_92284
loc_922AC:
        xor eax, eax
loc_922AE:
        add esp, byte 4
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
read_:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        push eax
        mov ebp, edx
        mov ecx, ebx
        call __IOMode_
        mov edx, eax
        mov dword [byte esp+0Ch], eax
        test eax, eax
        jne short loc_922E5
        mov eax, 4
loc_922D6:
        call __set_errno_
        mov eax, 0FFFFFFFFh
        jmp near loc_923C1
loc_922E5:
        test al, 1
        jne short loc_922F0
        mov eax, 6
        jmp short loc_922D6
loc_922F0:
        test al, 40h
        je short loc_9231E
        mov ebx, dword [esp]
        mov edx, ebp
        mov ah, 3Fh
        int 21h
        rcl eax, 1
        ror eax, 1
        mov esi, eax
        mov dword [byte esp+08h], eax
        test eax, eax
        jge near loc_923BD
        xor eax, eax
        mov ax, si
loc_92314:
        call __set_errno_dos_
        jmp near loc_923C1
loc_9231E:
        xor edx, eax
        mov dword [byte esp+04h], ebx
        mov dword [byte esp+08h], edx
loc_92328:
        mov ebx, dword [esp]
        mov ecx, dword [byte esp+04h]
        mov edx, ebp
        mov ah, 3Fh
        int 21h
        rcl eax, 1
        ror eax, 1
        mov ebx, eax
        mov esi, eax
        mov dword [byte esp+010h], eax
        test eax, eax
        jge short loc_9234C
        xor eax, eax
        mov ax, bx
        jmp short loc_92314
loc_9234C:
        je near loc_923BD
        mov esi, dword [byte esp+08h]
        mov eax, ebp
        xor edi, edi
        lea ecx, [ebx+ebp]
        xor edx, edx
        mov dword [byte esp+014h], ecx
        jmp short loc_92396
loc_92365:
        mov bl, byte [eax]
        cmp bl, 1Ah
        jne short loc_92386
        mov ebp, dword [byte esp+010h]
        mov edx, edi
        mov eax, dword [esp]
        sub edx, ebp
        mov ebx, 1
        inc edx
        call lseek_
        mov eax, esi
        jmp short loc_923C1
loc_92386:
        cmp bl, 0Dh
        je short loc_92394
        mov ebx, edx
        inc esi
        mov cl, byte [eax]
        inc edx
        mov byte [ebx+ebp], cl
loc_92394:
        inc eax
        inc edi
loc_92396:
        cmp eax, dword [byte esp+014h]
        jb short loc_92365
        mov ecx, dword [byte esp+04h]
        mov ah, byte [byte esp+0Dh]
        mov dword [byte esp+08h], esi
        sub ecx, edx
        add ebp, edx
        mov dword [byte esp+04h], ecx
        test ah, 20h
        jne short loc_923BD
        test ecx, ecx
        jne near loc_92328
loc_923BD:
        mov eax, dword [byte esp+08h]
loc_923C1:
        add esp, byte 18h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
j___close_:
        jmp near __close_
byteswap_:
        push es
        push ds
        pop es
        movzx edx, cl
        shr ecx, 2
        je short loc_923E4
loc_923D9:
        mov eax, dword [edi]
        xchg eax, dword [esi]
        stosd
        add esi, byte 4
        dec ecx
        jne short loc_923D9
loc_923E4:
        and dl, 3
        je short loc_923F2
loc_923E9:
        mov al, byte [edi]
        xchg al, byte [esi]
        stosb
        inc esi
        dec edx
        jne short loc_923E9
loc_923F2:
        pop es
        ret
med3_:
        push esi
        push edi
        push es
        push fs
        push gs
        enter 4, 0
        mov edi, eax
        mov esi, edx
        mov dword [byte ebp-04h], ecx
        call dword [byte ebp-04h]
        test eax, eax
        jle short loc_9242B
        mov eax, edi
        mov edx, ebx
        call dword [byte ebp-04h]
        test eax, eax
        jle short loc_92427
        mov eax, esi
        mov edx, ebx
        call dword [byte ebp-04h]
        test eax, eax
        jg short loc_92441
loc_92423:
        mov eax, ebx
        jmp short loc_92443
loc_92427:
        mov eax, edi
        jmp short loc_92443
loc_9242B:
        mov eax, edi
        mov edx, ebx
        call dword [byte ebp-04h]
        test eax, eax
        jge short loc_92427
        mov eax, esi
        mov edx, ebx
        call dword [byte ebp-04h]
        test eax, eax
        jg short loc_92423
loc_92441:
        mov eax, esi
loc_92443:
        leave
        pop gs
        pop fs
        pop es
        pop edi
        pop esi
        ret
qsort_:
        push esi
        push edi
        push es
        push fs
        push gs
        enter 144h, 0
        push eax
        push edx
        push ebx
        or eax, ebx
        mov dword [byte ebp-014h], ecx
        test al, 3
        je short loc_9246A
        mov eax, 2
        jmp short loc_92473
loc_9246A:
        cmp ebx, byte 4
        seta al
        movzx eax, al
loc_92473:
        mov dword [byte ebp-01Ch], eax
        imul eax, dword [dword ebp-0150h], byte 3
        mov dword [byte ebp-038h], eax
        mov eax, dword [dword ebp-0150h]
        add eax, eax
        mov dword [byte ebp-010h], 0
        mov dword [byte ebp-034h], eax
loc_92492:
        cmp dword [dword ebp-014Ch], byte 1
        jbe near loc_92530
        cmp dword [dword ebp-014Ch], byte 10h
        jae near loc_9255F
        mov eax, dword [byte ebp-038h]
        mov dword [byte ebp-018h], eax
        mov eax, dword [dword ebp-014Ch]
        imul eax, dword [dword ebp-0150h]
        mov edx, dword [dword ebp-0148h]
        add edx, eax
        mov dword [byte ebp-03Ch], edx
        jmp short loc_9252A
loc_924CC:
        mov eax, dword [dword ebp-0148h]
        add eax, dword [byte ebp-018h]
        mov dword [byte ebp-024h], eax
        jmp short loc_9251C
loc_924DA:
        mov ebx, eax
        jmp short loc_924FE
loc_924DE:
        cmp dword [byte ebp-01Ch], byte 0
        je short loc_924F3
        mov ecx, dword [dword ebp-0150h]
        mov esi, ebx
        call byteswap_
        jmp short loc_924FB
loc_924F3:
        mov eax, dword [edi]
        mov edx, dword [ebx]
        mov dword [ebx], eax
        mov dword [edi], edx
loc_924FB:
        sub ebx, dword [byte ebp-018h]
loc_924FE:
        cmp ebx, dword [dword ebp-0148h]
        jbe short loc_92516
        mov edi, ebx
        sub edi, dword [byte ebp-018h]
        mov edx, ebx
        mov eax, edi
        call dword [byte ebp-014h]
        test eax, eax
        jg short loc_924DE
loc_92516:
        mov eax, dword [byte ebp-018h]
        add dword [byte ebp-024h], eax
loc_9251C:
        mov eax, dword [byte ebp-024h]
        cmp eax, dword [byte ebp-03Ch]
        jb short loc_924DA
        mov eax, dword [byte ebp-034h]
        sub dword [byte ebp-018h], eax
loc_9252A:
        cmp dword [byte ebp-018h], byte 0
        jg short loc_924CC
loc_92530:
        cmp dword [byte ebp-010h], byte 0
        je near loc_92443
        dec dword [byte ebp-010h]
        mov eax, dword [byte ebp-010h]
        mov edx, dword [dword ebp+eax*4-0144h]
        mov eax, dword [dword ebp+eax*4-0C4h]
        mov dword [dword ebp-0148h], edx
        mov dword [dword ebp-014Ch], eax
        jmp near loc_92492
loc_9255F:
        mov edi, dword [dword ebp-014Ch]
        shr edi, 1
        imul edi, dword [dword ebp-0150h]
        add edi, dword [dword ebp-0148h]
        cmp dword [dword ebp-014Ch], byte 1Dh
        jbe near loc_92623
        mov eax, dword [dword ebp-0148h]
        mov dword [byte ebp-030h], eax
        mov eax, dword [dword ebp-014Ch]
        dec eax
        imul eax, dword [dword ebp-0150h]
        mov esi, dword [dword ebp-0148h]
        add esi, eax
        cmp dword [dword ebp-014Ch], byte 2Ah
        jbe short loc_92612
        mov eax, dword [dword ebp-014Ch]
        mov edx, dword [dword ebp-0150h]
        shr eax, 3
        imul edx, eax
        mov ebx, dword [dword ebp-0148h]
        mov ecx, dword [byte ebp-014h]
        mov dword [byte ebp-020h], edx
        lea eax, [edx+edx]
        mov edx, dword [dword ebp-0148h]
        mov dword [byte ebp-040h], eax
        add ebx, eax
        mov eax, dword [dword ebp-0148h]
        add edx, dword [byte ebp-020h]
        call med3_
        mov ebx, dword [byte ebp-020h]
        mov ecx, dword [byte ebp-014h]
        mov dword [byte ebp-030h], eax
        mov edx, edi
        mov eax, edi
        add ebx, edi
        sub eax, dword [byte ebp-020h]
        call med3_
        mov ecx, dword [byte ebp-014h]
        mov edi, eax
        mov edx, esi
        mov ebx, esi
        mov eax, esi
        sub edx, dword [byte ebp-020h]
        sub eax, dword [byte ebp-040h]
        call med3_
        mov esi, eax
loc_92612:
        mov eax, dword [byte ebp-030h]
        mov ecx, dword [byte ebp-014h]
        mov edx, edi
        mov ebx, esi
        call med3_
        mov edi, eax
loc_92623:
        cmp dword [byte ebp-01Ch], byte 0
        je short loc_92653
        mov eax, dword [dword ebp-0148h]
        mov dword [byte ebp-02Ch], eax
        je short loc_92643
        mov ecx, dword [dword ebp-0150h]
        mov esi, eax
        call byteswap_
        jmp short loc_9265E
loc_92643:
        mov ebx, dword [dword ebp-0148h]
        mov edx, dword [eax]
        mov eax, dword [edi]
        mov dword [ebx], eax
        mov dword [edi], edx
        jmp short loc_9265E
loc_92653:
        lea eax, [byte ebp-044h]
        mov dword [byte ebp-02Ch], eax
        mov eax, dword [edi]
        mov dword [byte ebp-044h], eax
loc_9265E:
        mov eax, dword [dword ebp-014Ch]
        dec eax
        imul eax, dword [dword ebp-0150h]
        mov ebx, dword [dword ebp-0148h]
        lea edx, [ebx+eax]
        mov dword [byte ebp-0Ch], ebx
        mov dword [byte ebp-08h], edx
        mov dword [byte ebp-04h], edx
loc_9267E:
        cmp ebx, dword [byte ebp-04h]
        ja short loc_926C8
        mov edx, dword [byte ebp-02Ch]
        mov eax, ebx
        call dword [byte ebp-014h]
        test eax, eax
        jg short loc_926C8
        jne short loc_926C0
        cmp dword [byte ebp-01Ch], byte 0
        je short loc_926A9
        mov esi, dword [byte ebp-0Ch]
        mov ecx, dword [dword ebp-0150h]
        mov edi, ebx
        call byteswap_
        jmp short loc_926B7
loc_926A9:
        mov edx, dword [byte ebp-0Ch]
        mov ecx, dword [byte ebp-0Ch]
        mov eax, dword [ebx]
        mov edx, dword [edx]
        mov dword [ecx], eax
        mov dword [ebx], edx
loc_926B7:
        mov eax, dword [dword ebp-0150h]
        add dword [byte ebp-0Ch], eax
loc_926C0:
        add ebx, dword [dword ebp-0150h]
        jmp short loc_9267E
loc_926C8:
        cmp ebx, dword [byte ebp-04h]
        ja short loc_9271D
        mov eax, dword [byte ebp-04h]
        mov edx, dword [byte ebp-02Ch]
        call dword [byte ebp-014h]
        test eax, eax
        jl short loc_9271D
        jne short loc_92712
        cmp dword [byte ebp-01Ch], byte 0
        je short loc_926F5
        mov esi, dword [byte ebp-04h]
        mov edi, dword [byte ebp-08h]
        mov ecx, dword [dword ebp-0150h]
        call byteswap_
        jmp short loc_92709
loc_926F5:
        mov edx, dword [byte ebp-08h]
        mov eax, dword [byte ebp-04h]
        mov ecx, dword [byte ebp-04h]
        mov edx, dword [edx]
        mov eax, dword [eax]
        mov dword [ecx], edx
        mov edx, dword [byte ebp-08h]
        mov dword [edx], eax
loc_92709:
        mov eax, dword [dword ebp-0150h]
        sub dword [byte ebp-08h], eax
loc_92712:
        mov eax, dword [dword ebp-0150h]
        sub dword [byte ebp-04h], eax
        jmp short loc_926C8
loc_9271D:
        cmp ebx, dword [byte ebp-04h]
        ja short loc_9275C
        cmp dword [byte ebp-01Ch], byte 0
        je short loc_9273A
        mov edi, dword [byte ebp-04h]
        mov ecx, dword [dword ebp-0150h]
        mov esi, ebx
        call byteswap_
        jmp short loc_92748
loc_9273A:
        mov eax, dword [byte ebp-04h]
        mov eax, dword [eax]
        mov edx, dword [ebx]
        mov dword [ebx], eax
        mov eax, dword [byte ebp-04h]
        mov dword [eax], edx
loc_92748:
        mov eax, dword [dword ebp-0150h]
        add ebx, dword [dword ebp-0150h]
        sub dword [byte ebp-04h], eax
        jmp near loc_9267E
loc_9275C:
        mov eax, dword [dword ebp-014Ch]
        imul eax, dword [dword ebp-0150h]
        mov edx, dword [dword ebp-0148h]
        mov ecx, ebx
        add edx, eax
        mov eax, dword [byte ebp-0Ch]
        sub ecx, dword [byte ebp-0Ch]
        sub eax, dword [dword ebp-0148h]
        mov dword [byte ebp-028h], edx
        cmp eax, ecx
        jge short loc_92788
        mov ecx, eax
loc_92788:
        test ecx, ecx
        jbe short loc_927BB
        mov edi, ebx
        mov esi, dword [dword ebp-0148h]
        sub edi, ecx
        push es
        push ds
        pop es
        movzx edx, cl
        shr ecx, 2
        je short loc_927AC
loc_927A1:
        mov eax, dword [edi]
        xchg eax, dword [esi]
        stosd
        add esi, byte 4
        dec ecx
        jne short loc_927A1
loc_927AC:
        and dl, 3
        je short loc_927BA
loc_927B1:
        mov al, byte [edi]
        xchg al, byte [esi]
        stosb
        inc esi
        dec edx
        jne short loc_927B1
loc_927BA:
        pop es
loc_927BB:
        mov eax, dword [byte ebp-028h]
        mov ecx, dword [byte ebp-08h]
        sub eax, dword [byte ebp-08h]
        sub ecx, dword [byte ebp-04h]
        sub eax, dword [dword ebp-0150h]
        cmp ecx, eax
        jb short loc_927D3
        mov ecx, eax
loc_927D3:
        test ecx, ecx
        jbe short loc_92803
        mov edi, dword [byte ebp-028h]
        mov esi, ebx
        sub edi, ecx
        push es
        push ds
        pop es
        movzx edx, cl
        shr ecx, 2
        je short loc_927F4
loc_927E9:
        mov eax, dword [edi]
        xchg eax, dword [esi]
        stosd
        add esi, byte 4
        dec ecx
        jne short loc_927E9
loc_927F4:
        and dl, 3
        je short loc_92802
loc_927F9:
        mov al, byte [edi]
        xchg al, byte [esi]
        stosb
        inc esi
        dec edx
        jne short loc_927F9
loc_92802:
        pop es
loc_92803:
        mov esi, dword [byte ebp-08h]
        mov ecx, dword [byte ebp-028h]
        mov edi, ebx
        mov ebx, dword [byte ebp-010h]
        sub edi, dword [byte ebp-0Ch]
        sub esi, dword [byte ebp-04h]
        shl ebx, 2
        sub ecx, esi
        cmp esi, edi
        jb short loc_92841
        mov eax, esi
        xor edx, edx
        div dword [dword ebp-0150h]
        xor edx, edx
        mov dword [dword ebx+ebp-0C4h], eax
        mov eax, edi
        div dword [dword ebp-0150h]
        mov dword [dword ebx+ebp-0144h], ecx
        jmp short loc_9287B
loc_92841:
        cmp edi, dword [dword ebp-0150h]
        jbe near loc_92530
        mov eax, dword [dword ebp-0148h]
        xor edx, edx
        mov dword [dword ebx+ebp-0144h], eax
        mov eax, edi
        div dword [dword ebp-0150h]
        xor edx, edx
        mov dword [dword ebx+ebp-0C4h], eax
        mov eax, esi
        div dword [dword ebp-0150h]
        mov dword [dword ebp-0148h], ecx
loc_9287B:
        mov dword [dword ebp-014Ch], eax
        inc dword [byte ebp-010h]
        jmp near loc_92492
        db 00h,00h,00h,00h,00h,00h,00h
