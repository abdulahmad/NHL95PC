; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_A2D16 progbits alloc exec nowrite align=1
extern __fatal_runtime_error_, __flush_, __IOMode_, __set_errno_, __set_errno_dos_, __shutdown_stream_, _nmalloc_, str_NotEnoughMemoryTo
extern __iob_flags, UngetChar, __OpenStreams, __ClosedStreams, __freefp_, lseek_, __iob, __iob_end
global tell_, __InitFiles_, __full_io_exit_, fcloseall_, docloseall_, __qwrite_, flushall_, __flushall_
global getche_, __qread_, __FDFS
;-----------------------------------------------------------------------------
; tell_                                                         A2D16  library
; Run-time library tell: a file handle's position
;-----------------------------------------------------------------------------
tell_:
        push ebx
        push edx
        mov ebx, 1
        xor edx, edx
        call lseek_
        pop edx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __InitFiles_                                                  A2D27  library
; Run-time library: sets up the standard streams
;-----------------------------------------------------------------------------
__InitFiles_:
        push ebx
        push ecx
        push edx
        mov ah, byte [__iob_flags]
        and ah, 0F8h
        mov dl, ah
        mov byte [__iob_flags], ah
        or dl, 4
        mov ecx, __iob
        mov byte [__iob_flags], dl
        jmp short .3
.1:
        mov eax, 8
        call _nmalloc_
        mov ebx, eax
        test eax, eax
        jne short .2
        mov eax, 8
        call _nmalloc_
        mov ebx, eax
        test eax, eax
        jne short .2
        mov eax, str_NotEnoughMemoryTo
        mov edx, 1
        call __fatal_runtime_error_
.2:
        mov edx, dword [__ClosedStreams]
        mov dword [byte ebx+04h], ecx
        mov dword [__ClosedStreams], ebx
        add ecx, byte 1Ah
        mov dword [ebx], edx
.3:
        mov edx, dword [byte ecx+0Ch]
        test edx, edx
        jne short .1
        mov dword [__OpenStreams], edx
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __full_io_exit_                                               A2D9F  library
; Run-time library: closes all streams at exit
;-----------------------------------------------------------------------------
__full_io_exit_:
        xor eax, eax
        call docloseall_
        jmp near __freefp_+039h
;-----------------------------------------------------------------------------
; fcloseall_                                                      A2DAB  95 PC
; Run-time library fcloseall: closes every stream but the standard ones
;-----------------------------------------------------------------------------
fcloseall_:
        mov eax, 5
;-----------------------------------------------------------------------------
; docloseall_                                                   A2DB0  library
;-----------------------------------------------------------------------------
docloseall_:
        push ebx
        push ecx
        push edx
        push esi
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        mov esi, __iob
        add eax, eax
        xor ebx, ebx
        add esi, eax
        mov eax, dword [__ClosedStreams]
        jmp short .4
.1:
        mov ecx, dword [eax]
        mov eax, dword [byte eax+04h]
        mov edx, 1
        test byte [byte eax+0Dh], 40h
        jne short .2
        cmp eax, esi
        jb short .3
        cmp eax, __iob_end
        jae short .2
        xor edx, edx
.2:
        call __shutdown_stream_
        inc ebx
.3:
        mov eax, ecx
.4:
        test eax, eax
        jne short .1
        mov eax, ebx
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __qwrite_                                                     A2E02  library
; Run-time library: writes to a file handle
;-----------------------------------------------------------------------------
__qwrite_:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov dword [esp], edx
        mov ebp, ebx
        call __IOMode_
        test al, 80h
        je short .2
        mov al, 2
        mov ebx, esi
        xor edx, edx
        mov ah, 42h
        mov ecx, edx
        shr ecx, 10h
        int 21h
        rcl dx, 1
        ror dx, 1
        shl edx, 10h
        mov dx, ax
        mov edi, edx
        test edx, edx
        jge short .2
        xor eax, eax
        mov ax, dx
.1:
        call __set_errno_dos_
        jmp short .5
.2:
        mov edx, dword [esp]
        mov ebx, esi
        mov ecx, ebp
        mov ah, 40h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov esi, eax
        mov edi, eax
        mov edx, eax
        test eax, eax
        jge short .3
        xor eax, eax
        mov ax, si
        jmp short .1
.3:
        cmp eax, ebp
        je short .4
        mov eax, 0Ch
        call __set_errno_
.4:
        mov eax, edx
.5:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 00h,00h
;-----------------------------------------------------------------------------
; flushall_                                    A2E80  95 PC, medium confidence
; Flushes every open stream
;-----------------------------------------------------------------------------
flushall_:
        mov eax, 0FFFFFFFFh
;-----------------------------------------------------------------------------
; __flushall_                                                   A2E85  library
;-----------------------------------------------------------------------------
__flushall_:
        push ebx
        push ecx
        push edx
        mov ecx, eax
        mov edx, dword [__ClosedStreams]
        xor ebx, ebx
        jmp short .3
.1:
        mov eax, dword [byte edx+04h]
        test dword [byte eax+0Ch], ecx
        je short .2
        inc ebx
        test byte [byte eax+0Dh], 10h
        je short .2
        call __flush_
.2:
        mov edx, dword [edx]
.3:
        test edx, edx
        jne short .1
        mov eax, ebx
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; getche_                                                       A2EB4  library
; Run-time library getche: reads a key and echoes it
;-----------------------------------------------------------------------------
getche_:
        push edx
        xor edx, edx
        mov eax, dword [UngetChar]
        mov dword [UngetChar], edx
        test eax, eax
        jne short .1
        mov ah, 1
        int 21h
        and eax, 0FFh
.1:
        pop edx
        ret
;-----------------------------------------------------------------------------
; __qread_                                                      A2ED1  library
; Run-time library: reads from a file handle
;-----------------------------------------------------------------------------
__qread_:
        push ecx
        mov ecx, ebx
        mov ebx, eax
        mov ah, 3Fh
        int 21h
        rcl eax, 1
        ror eax, 1
        mov edx, eax
        test eax, eax
        jge short .1
        and eax, 0FFFFh
        call __set_errno_dos_
.1:
        pop ecx
        ret
;-----------------------------------------------------------------------------
; __FDFS                                                        A2EF0  library
; Run-time library: converts a double to a float
;-----------------------------------------------------------------------------
__FDFS:
        push ebx
        test edx, 7FF00000h
        je short .2
        sub ebx, ebx
        add eax, eax
        adc edx, edx
        rcr ebx, 1
        add eax, 20000000h
        adc edx, byte 0
        je short .1
        cmp edx, 8FE00000h
        jae short .1
        cmp edx, 70200000h
        jb short .2
        sub edx, 70000000h
        add eax, eax
        adc edx, edx
        add eax, eax
        adc edx, edx
        or edx, ebx
        mov eax, edx
        pop ebx
        ret
.1:
        mov eax, 7F800000h
        or eax, ebx
        pop ebx
        ret
.2:
        sub eax, eax
        pop ebx
        ret
        db 00h,00h,00h,00h
