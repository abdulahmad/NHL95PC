; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_92068 progbits alloc exec nowrite align=1
extern __close_, __IOMode_, __set_errno_, __set_errno_dos_, __SetIOMode_, _fmode, SopenMask, isatty_
extern lseek_
global open_, sopen_, __set_binary_, read_, j___close_, byteswap_, med3_, med3_
global qsort_
;-----------------------------------------------------------------------------
; open_                                                         92068  library
; Run-time library open: opens a file
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; sopen_                                                        9208C  library
; Run-time library sopen: opens a file with a share mode
;-----------------------------------------------------------------------------
sopen_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 0Ch
        mov esi, dword [byte esp+024h]
.1:
        cmp byte [esi], 20h
        jne short .2
        inc esi
        jmp short .1
.2:
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
        jl short .3
        xor edi, edi
        mov di, word [byte esp+04h]
.3:
        mov dh, byte [byte esp+028h]
        test dh, 3
        je near .6
        cmp edi, byte 0FFFFFFFFh
        je short .6
        mov eax, edi
        call isatty_
        test eax, eax
        jne short .6
        test byte [byte esp+029h], 4
        je short .4
        mov ebx, edi
        mov ah, 3Eh
        int 21h
        rcl eax, 1
        ror eax, 1
        mov eax, 7
        call __set_errno_
        mov eax, 0FFFFFFFFh
        jmp near .18
.4:
        test dh, 40h
        je short .6
        lea edx, [byte esp+08h]
        mov ebx, edi
        xor ecx, ecx
        mov ah, 40h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov dword [byte esp+04h], eax
        test eax, eax
        jge short .6
        mov ebx, edi
        mov ah, 3Eh
        int 21h
        rcl eax, 1
        ror eax, 1
.5:
        xor eax, eax
        mov ax, word [byte esp+04h]
        call __set_errno_dos_
        jmp near .18
.6:
        cmp edi, byte 0FFFFFFFFh
        jne near .9
        test byte [byte esp+028h], 20h
        je short .5
        cmp word [byte esp+04h], byte 2
        jne short .5
        lea eax, [byte esp+030h]
        add eax, byte 4
        mov eax, dword [byte eax-04h]
        test eax, eax
        jne short .7
        mov eax, 180h
.7:
        xor eax, dword [SopenMask]
        xor ecx, ecx
        test al, 80h
        jne short .8
        mov ecx, 1
.8:
        mov edx, esi
        and ecx, 0FFh
        mov ah, 3Ch
        int 21h
        rcl eax, 1
        ror eax, 1
        mov dword [byte esp+04h], eax
        test eax, eax
        jl short .5
        mov ebx, dword [byte esp+04h]
        mov ah, 3Eh
        int 21h
        rcl eax, 1
        ror eax, 1
        mov dword [byte esp+04h], eax
        test eax, eax
        jl short .5
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
        jl near .5
        xor edi, edi
        mov di, word [byte esp+04h]
.9:
        mov eax, edi
        call __IOMode_
        and al, 3Ch
        mov edx, eax
        mov eax, edi
        call isatty_
        test eax, eax
        je short .10
        or dh, 20h
.10:
        and byte [esp], 7Fh
        cmp dword [esp], byte 2
        jne short .11
        or dl, 3
.11:
        cmp dword [esp], byte 0
        jne short .12
        or dl, 1
.12:
        cmp dword [esp], byte 1
        jne short .13
        or dl, 2
.13:
        test byte [byte esp+028h], 10h
        je short .14
        or dl, 80h
.14:
        mov eax, edx
        mov bl, byte [byte esp+029h]
        or al, 40h
        test bl, 3
        je short .15
        test bl, 2
        je short .17
        jmp short .16
.15:
        cmp dword [_fmode], 200h
        jne short .17
.16:
        mov edx, eax
.17:
        mov eax, edi
        call __SetIOMode_
        mov eax, edi
.18:
        add esp, byte 0Ch
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __set_binary_                                                 92251  library
; Run-time library: puts a file handle in binary mode
;-----------------------------------------------------------------------------
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
        je short .3
        mov ebx, esi
        mov al, 0
        mov ah, 44h
        int 21h
        rcl edx, 1
        ror edx, 1
        mov dword [esp], edx
        test edx, edx
        jge short .2
.1:
        xor eax, eax
        mov ax, word [esp]
        call __set_errno_dos_
        jmp short .4
.2:
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
        jl short .1
.3:
        xor eax, eax
.4:
        add esp, byte 4
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; read_                                                         922B6  library
; Run-time library read: reads from a file handle, converting line ends in
; text mode
;-----------------------------------------------------------------------------
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
        jne short .2
        mov eax, 4
.1:
        call __set_errno_
        mov eax, 0FFFFFFFFh
        jmp near .13
.2:
        test al, 1
        jne short .3
        mov eax, 6
        jmp short .1
.3:
        test al, 40h
        je short .5
        mov ebx, dword [esp]
        mov edx, ebp
        mov ah, 3Fh
        int 21h
        rcl eax, 1
        ror eax, 1
        mov esi, eax
        mov dword [byte esp+08h], eax
        test eax, eax
        jge near .12
        xor eax, eax
        mov ax, si
.4:
        call __set_errno_dos_
        jmp near .13
.5:
        xor edx, eax
        mov dword [byte esp+04h], ebx
        mov dword [byte esp+08h], edx
.6:
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
        jge short .7
        xor eax, eax
        mov ax, bx
        jmp short .4
.7:
        je near .12
        mov esi, dword [byte esp+08h]
        mov eax, ebp
        xor edi, edi
        lea ecx, [ebx+ebp]
        xor edx, edx
        mov dword [byte esp+014h], ecx
        jmp short .11
.8:
        mov bl, byte [eax]
        cmp bl, 1Ah
        jne short .9
        mov ebp, dword [byte esp+010h]
        mov edx, edi
        mov eax, dword [esp]
        sub edx, ebp
        mov ebx, 1
        inc edx
        call lseek_
        mov eax, esi
        jmp short .13
.9:
        cmp bl, 0Dh
        je short .10
        mov ebx, edx
        inc esi
        mov cl, byte [eax]
        inc edx
        mov byte [ebx+ebp], cl
.10:
        inc eax
        inc edi
.11:
        cmp eax, dword [byte esp+014h]
        jb short .8
        mov ecx, dword [byte esp+04h]
        mov ah, byte [byte esp+0Dh]
        mov dword [byte esp+08h], esi
        sub ecx, edx
        add ebp, edx
        mov dword [byte esp+04h], ecx
        test ah, 20h
        jne short .12
        test ecx, ecx
        jne near .6
.12:
        mov eax, dword [byte esp+08h]
.13:
        add esp, byte 18h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; j___close_                                                    923C9  library
; Jump to the run-time close of a file handle
;-----------------------------------------------------------------------------
j___close_:
        jmp near __close_
;-----------------------------------------------------------------------------
; byteswap_                                                     923CE  library
; Run-time library: swaps two memory blocks (qsort helper)
;-----------------------------------------------------------------------------
byteswap_:
        push es
        push ds
        pop es
        movzx edx, cl
        shr ecx, 2
        je short .2
.1:
        mov eax, dword [edi]
        xchg eax, dword [esi]
        stosd
        add esi, byte 4
        dec ecx
        jne short .1
.2:
        and dl, 3
        je short .4
.3:
        mov al, byte [edi]
        xchg al, byte [esi]
        stosb
        inc esi
        dec edx
        jne short .3
.4:
        pop es
        ret
;-----------------------------------------------------------------------------
; med3_                                                         923F4  library
; Run-time library: the median of three elements (qsort helper)
;-----------------------------------------------------------------------------
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
        jle short .3
        mov eax, edi
        mov edx, ebx
        call dword [byte ebp-04h]
        test eax, eax
        jle short .2
        mov eax, esi
        mov edx, ebx
        call dword [byte ebp-04h]
        test eax, eax
        jg short .4
.1:
        mov eax, ebx
        jmp short med3_+04Fh
.2:
        mov eax, edi
        jmp short med3_+04Fh
.3:
        mov eax, edi
        mov edx, ebx
        call dword [byte ebp-04h]
        test eax, eax
        jge short .2
        mov eax, esi
        mov edx, ebx
        call dword [byte ebp-04h]
        test eax, eax
        jg short .1
.4:
        mov eax, esi
        leave
        pop gs
        pop fs
        pop es
        pop edi
        pop esi
        ret
;-----------------------------------------------------------------------------
; qsort_                                                        9244C  library
; Run-time library qsort: sorts an array
;-----------------------------------------------------------------------------
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
        je short .1
        mov eax, 2
        jmp short .2
.1:
        cmp ebx, byte 4
        seta al
        movzx eax, al
.2:
        mov dword [byte ebp-01Ch], eax
        imul eax, dword [dword ebp-0150h], byte 3
        mov dword [byte ebp-038h], eax
        mov eax, dword [dword ebp-0150h]
        add eax, eax
        mov dword [byte ebp-010h], 0
        mov dword [byte ebp-034h], eax
.3:
        cmp dword [dword ebp-014Ch], byte 1
        jbe near .13
        cmp dword [dword ebp-014Ch], byte 10h
        jae near .14
        mov eax, dword [byte ebp-038h]
        mov dword [byte ebp-018h], eax
        mov eax, dword [dword ebp-014Ch]
        imul eax, dword [dword ebp-0150h]
        mov edx, dword [dword ebp-0148h]
        add edx, eax
        mov dword [byte ebp-03Ch], edx
        jmp short .12
.4:
        mov eax, dword [dword ebp-0148h]
        add eax, dword [byte ebp-018h]
        mov dword [byte ebp-024h], eax
        jmp short .11
.5:
        mov ebx, eax
        jmp short .9
.6:
        cmp dword [byte ebp-01Ch], byte 0
        je short .7
        mov ecx, dword [dword ebp-0150h]
        mov esi, ebx
        call byteswap_
        jmp short .8
.7:
        mov eax, dword [edi]
        mov edx, dword [ebx]
        mov dword [ebx], eax
        mov dword [edi], edx
.8:
        sub ebx, dword [byte ebp-018h]
.9:
        cmp ebx, dword [dword ebp-0148h]
        jbe short .10
        mov edi, ebx
        sub edi, dword [byte ebp-018h]
        mov edx, ebx
        mov eax, edi
        call dword [byte ebp-014h]
        test eax, eax
        jg short .6
.10:
        mov eax, dword [byte ebp-018h]
        add dword [byte ebp-024h], eax
.11:
        mov eax, dword [byte ebp-024h]
        cmp eax, dword [byte ebp-03Ch]
        jb short .5
        mov eax, dword [byte ebp-034h]
        sub dword [byte ebp-018h], eax
.12:
        cmp dword [byte ebp-018h], byte 0
        jg short .4
.13:
        cmp dword [byte ebp-010h], byte 0
        je near med3_+04Fh
        dec dword [byte ebp-010h]
        mov eax, dword [byte ebp-010h]
        mov edx, dword [dword ebp+eax*4-0144h]
        mov eax, dword [dword ebp+eax*4-0C4h]
        mov dword [dword ebp-0148h], edx
        mov dword [dword ebp-014Ch], eax
        jmp near .3
.14:
        mov edi, dword [dword ebp-014Ch]
        shr edi, 1
        imul edi, dword [dword ebp-0150h]
        add edi, dword [dword ebp-0148h]
        cmp dword [dword ebp-014Ch], byte 1Dh
        jbe near .16
        mov eax, dword [dword ebp-0148h]
        mov dword [byte ebp-030h], eax
        mov eax, dword [dword ebp-014Ch]
        dec eax
        imul eax, dword [dword ebp-0150h]
        mov esi, dword [dword ebp-0148h]
        add esi, eax
        cmp dword [dword ebp-014Ch], byte 2Ah
        jbe short .15
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
.15:
        mov eax, dword [byte ebp-030h]
        mov ecx, dword [byte ebp-014h]
        mov edx, edi
        mov ebx, esi
        call med3_
        mov edi, eax
.16:
        cmp dword [byte ebp-01Ch], byte 0
        je short .18
        mov eax, dword [dword ebp-0148h]
        mov dword [byte ebp-02Ch], eax
        je short .17
        mov ecx, dword [dword ebp-0150h]
        mov esi, eax
        call byteswap_
        jmp short .19
.17:
        mov ebx, dword [dword ebp-0148h]
        mov edx, dword [eax]
        mov eax, dword [edi]
        mov dword [ebx], eax
        mov dword [edi], edx
        jmp short .19
.18:
        lea eax, [byte ebp-044h]
        mov dword [byte ebp-02Ch], eax
        mov eax, dword [edi]
        mov dword [byte ebp-044h], eax
.19:
        mov eax, dword [dword ebp-014Ch]
        dec eax
        imul eax, dword [dword ebp-0150h]
        mov ebx, dword [dword ebp-0148h]
        lea edx, [ebx+eax]
        mov dword [byte ebp-0Ch], ebx
        mov dword [byte ebp-08h], edx
        mov dword [byte ebp-04h], edx
.20:
        cmp ebx, dword [byte ebp-04h]
        ja short .24
        mov edx, dword [byte ebp-02Ch]
        mov eax, ebx
        call dword [byte ebp-014h]
        test eax, eax
        jg short .24
        jne short .23
        cmp dword [byte ebp-01Ch], byte 0
        je short .21
        mov esi, dword [byte ebp-0Ch]
        mov ecx, dword [dword ebp-0150h]
        mov edi, ebx
        call byteswap_
        jmp short .22
.21:
        mov edx, dword [byte ebp-0Ch]
        mov ecx, dword [byte ebp-0Ch]
        mov eax, dword [ebx]
        mov edx, dword [edx]
        mov dword [ecx], eax
        mov dword [ebx], edx
.22:
        mov eax, dword [dword ebp-0150h]
        add dword [byte ebp-0Ch], eax
.23:
        add ebx, dword [dword ebp-0150h]
        jmp short .20
.24:
        cmp ebx, dword [byte ebp-04h]
        ja short .28
        mov eax, dword [byte ebp-04h]
        mov edx, dword [byte ebp-02Ch]
        call dword [byte ebp-014h]
        test eax, eax
        jl short .28
        jne short .27
        cmp dword [byte ebp-01Ch], byte 0
        je short .25
        mov esi, dword [byte ebp-04h]
        mov edi, dword [byte ebp-08h]
        mov ecx, dword [dword ebp-0150h]
        call byteswap_
        jmp short .26
.25:
        mov edx, dword [byte ebp-08h]
        mov eax, dword [byte ebp-04h]
        mov ecx, dword [byte ebp-04h]
        mov edx, dword [edx]
        mov eax, dword [eax]
        mov dword [ecx], edx
        mov edx, dword [byte ebp-08h]
        mov dword [edx], eax
.26:
        mov eax, dword [dword ebp-0150h]
        sub dword [byte ebp-08h], eax
.27:
        mov eax, dword [dword ebp-0150h]
        sub dword [byte ebp-04h], eax
        jmp short .24
.28:
        cmp ebx, dword [byte ebp-04h]
        ja short .31
        cmp dword [byte ebp-01Ch], byte 0
        je short .29
        mov edi, dword [byte ebp-04h]
        mov ecx, dword [dword ebp-0150h]
        mov esi, ebx
        call byteswap_
        jmp short .30
.29:
        mov eax, dword [byte ebp-04h]
        mov eax, dword [eax]
        mov edx, dword [ebx]
        mov dword [ebx], eax
        mov eax, dword [byte ebp-04h]
        mov dword [eax], edx
.30:
        mov eax, dword [dword ebp-0150h]
        add ebx, dword [dword ebp-0150h]
        sub dword [byte ebp-04h], eax
        jmp near .20
.31:
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
        jge short .32
        mov ecx, eax
.32:
        test ecx, ecx
        jbe short .37
        mov edi, ebx
        mov esi, dword [dword ebp-0148h]
        sub edi, ecx
        push es
        push ds
        pop es
        movzx edx, cl
        shr ecx, 2
        je short .34
.33:
        mov eax, dword [edi]
        xchg eax, dword [esi]
        stosd
        add esi, byte 4
        dec ecx
        jne short .33
.34:
        and dl, 3
        je short .36
.35:
        mov al, byte [edi]
        xchg al, byte [esi]
        stosb
        inc esi
        dec edx
        jne short .35
.36:
        pop es
.37:
        mov eax, dword [byte ebp-028h]
        mov ecx, dword [byte ebp-08h]
        sub eax, dword [byte ebp-08h]
        sub ecx, dword [byte ebp-04h]
        sub eax, dword [dword ebp-0150h]
        cmp ecx, eax
        jb short .38
        mov ecx, eax
.38:
        test ecx, ecx
        jbe short .43
        mov edi, dword [byte ebp-028h]
        mov esi, ebx
        sub edi, ecx
        push es
        push ds
        pop es
        movzx edx, cl
        shr ecx, 2
        je short .40
.39:
        mov eax, dword [edi]
        xchg eax, dword [esi]
        stosd
        add esi, byte 4
        dec ecx
        jne short .39
.40:
        and dl, 3
        je short .42
.41:
        mov al, byte [edi]
        xchg al, byte [esi]
        stosb
        inc esi
        dec edx
        jne short .41
.42:
        pop es
.43:
        mov esi, dword [byte ebp-08h]
        mov ecx, dword [byte ebp-028h]
        mov edi, ebx
        mov ebx, dword [byte ebp-010h]
        sub edi, dword [byte ebp-0Ch]
        sub esi, dword [byte ebp-04h]
        shl ebx, 2
        sub ecx, esi
        cmp esi, edi
        jb short .44
        mov eax, esi
        xor edx, edx
        div dword [dword ebp-0150h]
        xor edx, edx
        mov dword [dword ebx+ebp-0C4h], eax
        mov eax, edi
        div dword [dword ebp-0150h]
        mov dword [dword ebx+ebp-0144h], ecx
        jmp short .45
.44:
        cmp edi, dword [dword ebp-0150h]
        jbe near .13
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
.45:
        mov dword [dword ebp-014Ch], eax
        inc dword [byte ebp-010h]
        jmp near .3
        db 00h,00h,00h,00h,00h,00h,00h
