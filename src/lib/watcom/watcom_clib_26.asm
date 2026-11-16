; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_986EF progbits alloc exec nowrite align=1
extern __flush_, __ioalloc_, __prtf_, FpeHandler, fputc_, ErrnoPtr, __get_doserrno_ptr_
global file_putc_, __fprtf_, loc_98723, loc_98741, loc_9876B, loc_98776, __set_EDOM_, __set_errno_
global __set_ERANGE_, __set_EINVAL_, __set_doserrno_, CallFpeHandler
file_putc_:
        push ebx
        mov ebx, eax
        mov eax, edx
        mov edx, dword [ebx]
        call fputc_
        inc dword [byte ebx+010h]
        pop ebx
        ret
__fprtf_:
        push ecx
        push esi
        push edi
        push ebp
        mov esi, eax
        mov ebp, dword [byte eax+0Ch]
        mov ah, byte [byte eax+0Ch]
        mov ecx, dword [byte esi+08h]
        and ah, 0CFh
        and ebp, byte 30h
        mov byte [byte esi+0Ch], ah
        test ecx, ecx
        jne short loc_98723
        mov eax, esi
        call __ioalloc_
loc_98723:
        mov cl, byte [byte esi+0Dh]
        xor edi, edi
        test cl, 4
        je short loc_98741
        mov ch, cl
        and ch, 0FAh
        mov al, ch
        mov byte [byte esi+0Dh], ch
        or al, 1
        mov edi, 1
        mov byte [byte esi+0Dh], al
loc_98741:
        mov ecx, file_putc_
        mov eax, esi
        call __prtf_
        mov edx, eax
        test edi, edi
        je short loc_9876B
        mov ah, byte [byte esi+0Dh]
        and ah, 0FAh
        mov bl, ah
        mov byte [byte esi+0Dh], ah
        or bl, 4
        mov eax, esi
        mov byte [byte esi+0Dh], bl
        call __flush_
loc_9876B:
        test byte [byte esi+0Ch], 20h
        je short loc_98776
        mov edx, 0FFFFFFFFh
loc_98776:
        mov edi, dword [byte esi+0Ch]
        or edi, ebp
        mov eax, edx
        mov dword [byte esi+0Ch], edi
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
__set_EDOM_:
        mov eax, 0Dh
__set_errno_:
        push edx
        mov edx, eax
        call ErrnoPtr
        mov dword [eax], edx
        pop edx
        ret
__set_ERANGE_:
        mov eax, 0Eh
        jmp short __set_errno_
__set_EINVAL_:
        mov eax, 9
        call __set_errno_
        mov eax, 0FFFFFFFFh
        ret
__set_doserrno_:
        push edx
        mov edx, eax
        call __get_doserrno_ptr_
        mov dword [eax], edx
        pop edx
        ret
CallFpeHandler:
        call dword [FpeHandler]
        ret
