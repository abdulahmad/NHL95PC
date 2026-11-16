; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_9AFB0 progbits alloc exec nowrite align=1
extern __qwrite_, __set_errno_, __SetIOMode_, _nfree_, _nmalloc_, __OpenStreams, __ClosedStreams, isatty_
extern FillRectSpans, FillRectSpans, lseek_, memset_, tell_, __iob, __NFiles, _psp
global tolower_, __allocfp_, __freefp_, __update_buffer_, fseek_, __chktty_, GetPsp, __flush_
global ftell_, __close_, __ioalloc_, fputc_, FillRectSpansModeTable
;-----------------------------------------------------------------------------
; tolower_                                                      9AFB0  library
; Run-time library tolower: a character to lower case
;-----------------------------------------------------------------------------
tolower_:
        cmp eax, byte 41h
        jl short .1
        cmp eax, byte 5Ah
        jg short .1
        add eax, byte 20h
.1:
        ret
;-----------------------------------------------------------------------------
; __allocfp_                                                    9AFBE  library
; Run-time library: allocates a stream record
;-----------------------------------------------------------------------------
__allocfp_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov esi, dword [__OpenStreams]
        test esi, esi
        je short .1
        mov ecx, dword [byte esi+04h]
        mov edi, dword [byte ecx+0Ch]
        mov eax, dword [esi]
        and edi, 4003h
        mov dword [__OpenStreams], eax
        or di, byte 3
        jmp short .5
.1:
        mov ecx, __iob
        jmp short .4
.2:
        test byte [byte ecx+0Ch], 3
        jne short .3
        mov eax, 8
        call _nmalloc_
        mov esi, eax
        test eax, eax
        je short .6
        mov edi, 3
        jmp short .5
.3:
        add ecx, byte 1Ah
.4:
        cmp ecx, __NFiles
        jb short .2
        mov eax, 22h
        mov edi, 4003h
        call _nmalloc_
        mov ecx, eax
        mov esi, eax
        test eax, eax
        je short .6
        lea ecx, [byte eax+08h]
.5:
        mov ebx, 1Ah
        mov eax, ecx
        xor edx, edx
        call memset_
        mov dword [byte ecx+0Ch], edi
        mov eax, dword [__ClosedStreams]
        mov dword [byte esi+04h], ecx
        mov dword [__ClosedStreams], esi
        mov dword [esi], eax
        mov eax, ecx
        jmp short .7
.6:
        mov eax, 5
        call __set_errno_
        xor eax, eax
.7:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __freefp_                                                     9B066  library
; Run-time library: frees a stream record
;-----------------------------------------------------------------------------
__freefp_:
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov edx, __ClosedStreams
.1:
        mov eax, dword [edx]
        test eax, eax
        je short .3
        mov ecx, dword [byte eax+04h]
        cmp ebx, ecx
        je short .2
        mov edx, eax
        jmp short .1
.2:
        mov cl, byte [byte ecx+0Ch]
        or cl, 3
        mov byte [byte ebx+0Ch], cl
        mov ebx, dword [eax]
        mov dword [edx], ebx
        mov edx, dword [__OpenStreams]
        mov dword [__OpenStreams], eax
        mov dword [eax], edx
.3:
        pop edx
        pop ecx
        pop ebx
        ret
        push edx
.4:
        mov edx, dword [__OpenStreams]
        test edx, edx
        je short .5
        mov eax, edx
        mov edx, dword [edx]
        call _nfree_
        mov dword [__OpenStreams], edx
        jmp short .4
.5:
        pop edx
        ret
;-----------------------------------------------------------------------------
; __update_buffer_                                              9B0BD  library
; Run-time library: syncs a stream's buffer after a seek
;-----------------------------------------------------------------------------
__update_buffer_:
        push ebx
        push ecx
        push esi
        push edi
        and byte [byte edx+0Ch], 0EFh
        cmp eax, dword [byte edx+04h]
        jg short .1
        mov ebx, dword [byte edx+08h]
        mov ecx, dword [edx]
        sub ebx, ecx
        cmp eax, ebx
        jl short .1
        mov edi, dword [byte edx+04h]
        lea esi, [ecx+eax]
        sub edi, eax
        mov dword [edx], esi
        xor eax, eax
        mov dword [byte edx+04h], edi
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.1:
        mov eax, dword [byte edx+08h]
        mov dword [byte edx+04h], 0
        mov dword [edx], eax
        mov eax, 1
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; fseek_                                                        9B0FF  library
; Run-time library fseek: moves a stream's file position
;-----------------------------------------------------------------------------
fseek_:
        push ecx
        push esi
        push edi
        mov ecx, eax
        mov esi, edx
        test byte [byte eax+0Ch], 6
        je short .6
        test byte [byte ecx+0Dh], 10h
        je short .3
        mov eax, ecx
        call __flush_
        test eax, eax
        je short .5
        test ebx, ebx
        jne short .2
        test esi, esi
        jge short .2
.1:
        mov eax, 9
        call __set_errno_
.2:
        mov eax, 0FFFFFFFFh
        pop edi
        pop esi
        pop ecx
        ret
.3:
        cmp ebx, byte 1
        jne short .4
        sub esi, dword [byte ecx+04h]
.4:
        mov eax, dword [byte ecx+08h]
        mov dword [byte ecx+04h], 0
        mov dword [ecx], eax
.5:
        and byte [byte ecx+0Ch], 0EBh
        mov edx, esi
        mov eax, dword [byte ecx+010h]
        call lseek_
        cmp eax, byte 0FFFFFFFFh
        jne near .11
        pop edi
        pop esi
        pop ecx
        ret
.6:
        cmp ebx, byte 1
        jb short .7
        jbe short .8
        cmp ebx, byte 2
        je short .10
        jmp short .1
.7:
        test ebx, ebx
        je short .9
        jmp short .1
.8:
        mov eax, edx
        mov edx, ecx
        mov edi, dword [byte ecx+04h]
        call __update_buffer_
        test eax, eax
        je short .11
        mov edx, esi
        mov eax, dword [byte ecx+010h]
        sub edx, edi
        call lseek_
        cmp eax, byte 0FFFFFFFFh
        jne short .11
        pop edi
        pop esi
        pop ecx
        ret
.9:
        mov eax, dword [byte ecx+010h]
        call tell_
        mov edx, dword [byte ecx+04h]
        mov edi, esi
        sub eax, edx
        sub edi, eax
        mov edx, ecx
        mov eax, edi
        call __update_buffer_
        test eax, eax
        je short .11
        mov edx, esi
        mov eax, dword [byte ecx+010h]
        call lseek_
        cmp eax, byte 0FFFFFFFFh
        jne short .11
        pop edi
        pop esi
        pop ecx
        ret
.10:
        mov eax, dword [byte ecx+08h]
        mov dl, byte [byte ecx+0Ch]
        mov dword [ecx], eax
        and dl, 0EFh
        mov eax, dword [byte ecx+010h]
        mov byte [byte ecx+0Ch], dl
        mov edx, esi
        mov dword [byte ecx+04h], 0
        call lseek_
        cmp eax, byte 0FFFFFFFFh
        je short .12
.11:
        xor eax, eax
.12:
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; __chktty_                                                     9B1FB  library
; Run-time library: marks a stream that is a terminal
;-----------------------------------------------------------------------------
__chktty_:
        push ebx
        push ecx
        push edx
        mov edx, eax
        test byte [byte eax+0Dh], 20h
        jne short .1
        mov eax, dword [byte edx+010h]
        call isatty_
        test eax, eax
        je short .1
        mov bl, byte [byte edx+0Dh]
        or bl, 20h
        mov byte [byte edx+0Dh], bl
        test bl, 7
        jne short .1
        mov cl, bl
        or cl, 2
        mov byte [byte edx+0Dh], cl
.1:
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; GetPsp                                       9B22C  95 PC, medium confidence
; Returns the program segment prefix
;-----------------------------------------------------------------------------
GetPsp:
        mov eax, dword [_psp]
        ret
;-----------------------------------------------------------------------------
; __flush_                                                      9B232  library
; Run-time library: writes out a stream's buffer
;-----------------------------------------------------------------------------
__flush_:
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, eax
        mov ah, byte [byte eax+0Dh]
        xor esi, esi
        test ah, 10h
        je short .2
        mov bh, byte [byte ecx+0Dh]
        and bh, 0EFh
        mov al, byte [byte ecx+0Ch]
        mov byte [byte ecx+0Dh], bh
        test al, 2
        je near .4
        cmp dword [byte ecx+08h], byte 0
        je near .4
        mov ebx, dword [byte ecx+04h]
        mov edx, dword [byte ecx+08h]
        mov eax, dword [byte ecx+010h]
        call __qwrite_
        cmp eax, byte 0FFFFFFFFh
        jne short .1
        mov dl, byte [byte ecx+0Ch]
        or dl, 20h
        mov esi, eax
        mov byte [byte ecx+0Ch], dl
        jmp short .4
.1:
        cmp eax, dword [byte ecx+04h]
        je short .4
        mov eax, 0Ch
        call __set_errno_
        mov ah, byte [byte ecx+0Ch]
        or ah, 20h
        mov esi, 0FFFFFFFFh
        mov byte [byte ecx+0Ch], ah
        jmp short .4
.2:
        cmp dword [byte ecx+08h], byte 0
        je short .4
        mov dl, byte [byte ecx+0Ch]
        and dl, 0EFh
        mov dh, byte [byte ecx+0Dh]
        mov byte [byte ecx+0Ch], dl
        test dh, 20h
        jne short .4
        mov eax, dword [byte ecx+04h]
        test eax, eax
        je short .3
        mov edx, eax
        mov ebx, 1
        neg edx
        mov eax, dword [byte ecx+010h]
        call lseek_
.3:
        cmp eax, byte 0FFFFFFFFh
        jne short .4
        mov bl, byte [byte ecx+0Ch]
        or bl, 20h
        mov esi, eax
        mov byte [byte ecx+0Ch], bl
.4:
        mov eax, dword [byte ecx+08h]
        mov dword [byte ecx+04h], 0
        mov dword [ecx], eax
        mov eax, esi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; ftell_                                                        9B2F1  library
; Run-time library ftell: a stream's file position
;-----------------------------------------------------------------------------
ftell_:
        push ebx
        push ecx
        push edx
        mov edx, eax
        mov eax, dword [byte eax+010h]
        call tell_
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je short .2
        mov ecx, dword [byte edx+04h]
        test ecx, ecx
        je short .2
        test byte [byte edx+0Dh], 10h
        je short .1
        lea eax, [ecx+ebx]
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, ebx
        sub eax, ecx
.2:
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __close_                                                      9B321  library
; Run-time library: closes a file handle
;-----------------------------------------------------------------------------
__close_:
        push ebx
        push edx
        mov edx, eax
        mov ebx, eax
        mov ah, 3Eh
        int 21h
        rcl eax, 1
        ror eax, 1
        test eax, eax
        jl short .1
        mov eax, edx
        xor edx, edx
        call __SetIOMode_
        xor eax, eax
        pop edx
        pop ebx
        ret
.1:
        mov eax, 4
        call __set_errno_
        mov eax, 0FFFFFFFFh
        pop edx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __ioalloc_                                                    9B353  library
; Run-time library: allocates a stream's buffer
;-----------------------------------------------------------------------------
__ioalloc_:
        push ecx
        push edx
        mov edx, eax
        call __chktty_
        cmp dword [byte edx+014h], byte 0
        jne short .3
        mov ah, byte [byte edx+0Dh]
        test ah, 2
        je short .1
        mov dword [byte edx+014h], 86h
        jmp short .3
.1:
        test ah, 4
        je short .2
        mov dword [byte edx+014h], 1
        jmp short .3
.2:
        mov dword [byte edx+014h], 1000h
.3:
        mov eax, dword [byte edx+014h]
        call _nmalloc_
        mov dword [byte edx+08h], eax
        test eax, eax
        jne short .4
        lea eax, [byte edx+018h]
        mov cl, byte [byte edx+0Dh]
        mov dword [byte edx+014h], 1
        and cl, 0F8h
        mov dword [byte edx+08h], eax
        mov ch, cl
        mov byte [byte edx+0Dh], cl
        or ch, 4
        mov byte [byte edx+0Dh], ch
        jmp short .5
.4:
        or byte [byte edx+0Ch], 8
.5:
        mov eax, dword [byte edx+08h]
        mov dword [byte edx+04h], 0
        mov dword [edx], eax
        pop edx
        pop ecx
        ret
;-----------------------------------------------------------------------------
; fputc_                                                        9B3CA  library
; Run-time library fputc: writes a character to a stream
;-----------------------------------------------------------------------------
fputc_:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebx, eax
        test byte [byte edx+0Ch], 2
        jne short .2
        mov eax, 4
        call __set_errno_
        or byte [byte edx+0Ch], 20h
.1:
        mov eax, 0FFFFFFFFh
        jmp near .7
.2:
        cmp dword [byte edx+08h], byte 0
        jne short .3
        mov eax, edx
        call __ioalloc_
.3:
        mov ecx, 400h
        cmp ebx, byte 0Ah
        jne short .4
        mov al, byte [byte edx+0Ch]
        mov ecx, 600h
        test al, 40h
        jne short .4
        or byte [byte edx+0Dh], 10h
        mov eax, dword [edx]
        mov byte [eax], 0Dh
        mov esi, dword [edx]
        inc esi
        mov edi, dword [byte edx+04h]
        mov dword [edx], esi
        inc edi
        mov ebp, dword [byte edx+014h]
        mov dword [byte edx+04h], edi
        cmp edi, ebp
        jne short .4
        mov eax, edx
        call __flush_
        test eax, eax
        jne short .1
.4:
        or byte [byte edx+0Dh], 10h
        mov eax, dword [edx]
        mov byte [eax], bl
        mov eax, dword [edx]
        inc eax
        mov esi, dword [byte edx+04h]
        mov dword [edx], eax
        inc esi
        mov edi, dword [byte edx+0Ch]
        mov dword [byte edx+04h], esi
        test ecx, edi
        jne short .5
        cmp esi, dword [byte edx+014h]
        jne short .6
.5:
        mov eax, edx
        call __flush_
        test eax, eax
        jne short .1
.6:
        xor eax, eax
        mov al, bl
.7:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
        db 00h,00h
FillRectSpansModeTable:                         ; used by FillRectSpans
        dd FillRectSpans+0ACh
        dd FillRectSpans+0ACh
        dd FillRectSpans+0CDh
        dd FillRectSpans+0F1h
        dd FillRectSpans+0111h
        dd FillRectSpans+0131h
        dd FillRectSpans+0182h
        dd FillRectSpans+01D3h
        dd FillRectSpans+021Bh
        dd FillRectSpans+025Fh
