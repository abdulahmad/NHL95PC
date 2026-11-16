; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_9B710 progbits alloc exec nowrite align=1
extern __flushall_, __ioalloc_, __qread_, __set_errno_, CLibBitMasks, __NHandles, __io_mode, getche_
extern memset_
global isatty_, __IOMode_, __SetIOMode_, __fsetbits_, __setbits_, fgetc_, __filbuf_, __fill_buffer_
global ungetc_
isatty_:
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov al, 0
        mov ah, 44h
        int 21h
        rcl edx, 1
        ror edx, 1
        test dl, 80h
        setne al
        and eax, 0FFh
        pop edx
        pop ecx
        pop ebx
        ret
__IOMode_:
        push ebx
        push ecx
        push edx
        mov edx, eax
        cmp eax, dword [__NHandles]
        jb short .1
        xor eax, eax
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        cmp eax, byte 5
        jg short .2
        mov ebx, eax
        mov eax, dword [__io_mode]
        shl ebx, 2
        add eax, ebx
        mov cl, byte [byte eax+01h]
        test cl, 40h
        jne short .2
        mov ch, cl
        or ch, 40h
        mov byte [byte eax+01h], ch
        mov eax, edx
        call isatty_
        test eax, eax
        je short .2
        mov eax, dword [__io_mode]
        or byte [byte ebx+eax+01h], 20h
.2:
        mov eax, dword [__io_mode]
        mov eax, dword [eax+edx*4]
        pop edx
        pop ecx
        pop ebx
        ret
__SetIOMode_:
        push ebx
        or dh, 40h
        mov ebx, edx
        mov edx, eax
        mov eax, dword [__io_mode]
        shl edx, 2
        mov dword [edx+eax], ebx
        pop ebx
        ret
__fsetbits_:
        push esi
        push edi
        push es
        push fs
        push gs
        mov gs, edx
        mov esi, eax
        mov es, ecx
        mov ecx, 20h
        mov edi, eax
        xor al, al
        push es
        push edi
        mov es, edx
        mov ah, al
        shr ecx, 1
        db 0F2h,066h,0ABh                       ; insn: repne stosw (nasm 3 emits 66h F2h)
        adc ecx, ecx
        repne stosb
        pop edi
        pop es
        jmp short .2
.1:
        xor eax, eax
        mov ecx, gs
        mov al, dl
        mov fs, ecx
        sar eax, 3
        and dl, 7
        and edx, 0FFh
        mov dl, byte [dword edx+CLibBitMasks]
        mov dh, byte [fs:esi+eax]
        or dh, dl
        inc ebx
        mov byte [fs:esi+eax], dh
.2:
        mov dl, byte [es:ebx]
        test dl, dl
        jne short .1
        pop gs
        pop fs
        pop es
        pop edi
        pop esi
        ret
__setbits_:
        push ebx
        push ecx
        push esi
        mov esi, eax
        mov ecx, edx
        mov ebx, 20h
        xor edx, edx
        call memset_
        jmp short .2
.1:
        xor eax, eax
        mov al, dl
        sar eax, 3
        and dl, 7
        and edx, 0FFh
        mov dl, byte [dword edx+CLibBitMasks]
        mov dh, byte [esi+eax]
        or dh, dl
        inc ecx
        mov byte [esi+eax], dh
.2:
        mov dl, byte [ecx]
        test dl, dl
        jne short .1
        pop esi
        pop ecx
        pop ebx
        ret
fgetc_:
        push ebx
        push ecx
        push edx
        push esi
        mov edx, eax
        test byte [byte eax+0Ch], 1
        jne short .1
        mov eax, 4
        call __set_errno_
        mov bl, byte [byte edx+0Ch]
        or bl, 20h
        mov eax, 0FFFFFFFFh
        mov byte [byte edx+0Ch], bl
        jmp short .3
.1:
        mov ebx, dword [byte edx+04h]
        dec ebx
        mov dword [byte edx+04h], ebx
        test ebx, ebx
        jge short .2
        mov eax, edx
        call __filbuf_
        jmp short .3
.2:
        mov ebx, dword [edx]
        mov al, byte [ebx]
        inc ebx
        and eax, 0FFh
        mov dword [edx], ebx
.3:
        test byte [byte edx+0Ch], 40h
        jne short .6
        cmp eax, byte 0Dh
        jne short .5
        mov esi, dword [byte edx+04h]
        dec esi
        mov dword [byte edx+04h], esi
        test esi, esi
        jge short .4
        mov eax, edx
        call __filbuf_
        jmp short .5
.4:
        mov ebx, dword [edx]
        mov al, byte [ebx]
        inc ebx
        and eax, 0FFh
        mov dword [edx], ebx
.5:
        cmp eax, byte 1Ah
        jne short .6
        mov cl, byte [byte edx+0Ch]
        or cl, 10h
        mov eax, 0FFFFFFFFh
        mov byte [byte edx+0Ch], cl
.6:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
__filbuf_:
        push ebx
        push ecx
        push edx
        mov edx, eax
        call __fill_buffer_
        test eax, eax
        jne short .1
        mov eax, 0FFFFFFFFh
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov ebx, dword [byte edx+04h]
        mov ecx, dword [edx]
        dec ebx
        inc ecx
        mov dword [byte edx+04h], ebx
        mov dword [edx], ecx
        mov al, byte [byte ecx-01h]
        and eax, 0FFh
        pop edx
        pop ecx
        pop ebx
        ret
__fill_buffer_:
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, eax
        cmp dword [byte eax+08h], byte 0
        jne short .1
        call __ioalloc_
.1:
        mov ah, byte [byte ecx+0Dh]
        test ah, 20h
        je short .2
        test ah, 6
        je short .2
        mov eax, 2000h
        call __flushall_
.2:
        mov edx, dword [byte ecx+0Ch]
        mov bl, byte [byte ecx+0Ch]
        mov eax, dword [byte ecx+08h]
        and bl, 0FBh
        mov dword [ecx], eax
        and edx, 2400h
        mov byte [byte ecx+0Ch], bl
        cmp edx, 2400h
        jne short .3
        mov ebx, dword [byte ecx+010h]
        test ebx, ebx
        jne short .3
        mov dword [byte ecx+04h], ebx
        call getche_
        cmp eax, byte 0FFFFFFFFh
        je short .6
        mov ebx, dword [ecx]
        mov byte [ebx], al
        mov dword [byte ecx+04h], 1
        jmp short .6
.3:
        test byte [byte ecx+0Dh], 4
        je short .4
        mov ebx, 1
        jmp short .5
.4:
        mov ebx, dword [byte ecx+014h]
.5:
        mov edx, dword [ecx]
        mov eax, dword [byte ecx+010h]
        call __qread_
        mov dword [byte ecx+04h], eax
.6:
        mov esi, dword [byte ecx+04h]
        test esi, esi
        jg short .8
        jne short .7
        or byte [byte ecx+0Ch], 10h
        jmp short .8
.7:
        mov al, byte [byte ecx+0Ch]
        mov dword [byte ecx+04h], 0
        or al, 20h
        mov byte [byte ecx+0Ch], al
.8:
        mov eax, dword [byte ecx+04h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
ungetc_:
        push ebx
        push esi
        push ebp
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je near .7
        test byte [byte edx+0Dh], 10h
        je short .2
.1:
        mov ebx, 0FFFFFFFFh
        jmp short .7
.2:
        test byte [byte edx+0Ch], 1
        je short .1
        cmp dword [byte edx+08h], byte 0
        jne short .3
        mov eax, edx
        call __ioalloc_
.3:
        mov esi, dword [byte edx+04h]
        test esi, esi
        jne short .4
        mov eax, dword [byte edx+08h]
        add eax, dword [byte edx+014h]
        dec eax
        mov dword [edx], eax
        or byte [byte edx+0Ch], 4
        mov eax, dword [edx]
        mov dword [byte edx+04h], 1
        jmp short .6
.4:
        mov eax, dword [edx]
        cmp eax, dword [byte edx+08h]
        je short .1
        mov eax, dword [edx]
        lea ebp, [byte esi+01h]
        dec eax
        mov dword [byte edx+04h], ebp
        mov dword [edx], eax
        mov al, byte [eax]
        and eax, 0FFh
        cmp eax, ebx
        je short .5
        or byte [byte edx+0Ch], 4
.5:
        mov eax, dword [edx]
.6:
        mov byte [eax], bl
        and byte [byte edx+0Ch], 0EFh
        and ebx, 0FFh
.7:
        mov eax, ebx
        pop ebp
        pop esi
        pop ebx
        ret
