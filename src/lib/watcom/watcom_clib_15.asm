; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_91D0B progbits alloc exec nowrite align=1
extern __close_, __flush_, __freefp_, __ioalloc_, _nfree_, __ClosedStreams, fputc_, ftell_
extern j_unlink_, lseek_, GetPsp
global fclose_, __shutdown_stream_, __hex_, __MkTmpFile_, __doclose_, strncpy_, fputs_, strcmp_
global FixedMulRound, memcmp_
;-----------------------------------------------------------------------------
; fclose_                                                       91D0B  library
; Run-time library fclose: closes a stream
;-----------------------------------------------------------------------------
fclose_:
        push ebx
        push edx
        mov edx, eax
        mov eax, dword [__ClosedStreams]
.1:
        test eax, eax
        jne short .2
        mov eax, 0FFFFFFFFh
        pop edx
        pop ebx
        ret
.2:
        mov ebx, dword [byte eax+04h]
        cmp edx, ebx
        je short .3
        mov eax, dword [eax]
        jmp short .1
.3:
        mov edx, 1
        mov eax, ebx
        call __shutdown_stream_
        pop edx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __shutdown_stream_                                            91D3A  library
; Run-time library: flushes and closes a stream
;-----------------------------------------------------------------------------
__shutdown_stream_:
        push ebx
        mov ebx, eax
        call __doclose_
        mov edx, eax
        mov eax, ebx
        call __freefp_
        mov eax, edx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __hex_                                                        91D4F  library
; Run-time library: a value 0-15 to its lower case hex digit
;-----------------------------------------------------------------------------
__hex_:
        add eax, byte 30h
        cmp eax, byte 39h
        jle short .1
        add eax, byte 27h
.1:
        ret
;-----------------------------------------------------------------------------
; __MkTmpFile_                                                  91D5B  library
; Run-time library: makes the name of a temporary file
;-----------------------------------------------------------------------------
__MkTmpFile_:
        push ebx
        push ecx
        push esi
        push edi
        mov ecx, eax
        mov edi, edx
        call GetPsp
        mov edx, 4
        mov ebx, eax
        mov esi, ecx
        mov byte [ecx], 74h
        add edx, ecx
.1:
        mov eax, ebx
        and eax, byte 0Fh
        call __hex_
        mov byte [edx], al
        dec edx
        shr ebx, 4
        cmp edx, esi
        jne short .1
        mov eax, edi
        sar eax, 4
        and eax, byte 0Fh
        mov byte [byte ecx+05h], 5Fh
        call __hex_
        mov byte [byte ecx+06h], al
        mov eax, edi
        and eax, byte 0Fh
        call __hex_
        mov byte [byte ecx+08h], 2Eh
        mov byte [byte ecx+09h], 74h
        mov byte [byte ecx+0Ah], 6Dh
        mov byte [byte ecx+0Bh], 70h
        mov byte [byte ecx+0Ch], 0
        mov byte [byte ecx+07h], al
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __doclose_                                                    91DC4  library
; Run-time library: closes a stream and frees its buffer
;-----------------------------------------------------------------------------
__doclose_:
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 10h
        mov ecx, eax
        mov edi, edx
        cmp dword [byte eax+0Ch], byte 0
        jne short .1
        mov esi, 0FFFFFFFFh
        jmp short .6
.1:
        mov ah, byte [byte eax+0Dh]
        xor esi, esi
        test ah, 10h
        je short .2
        mov eax, ecx
        call __flush_
        mov esi, eax
.2:
        mov eax, ecx
        call ftell_
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je short .3
        mov eax, dword [byte ecx+010h]
        xor ebx, ebx
        call lseek_
.3:
        test edi, edi
        je short .4
        mov eax, dword [byte ecx+010h]
        call __close_
        or esi, eax
.4:
        test byte [byte ecx+0Ch], 8
        je short .5
        mov eax, dword [byte ecx+08h]
        call _nfree_
        mov dword [byte ecx+08h], 0
.5:
        test byte [byte ecx+0Dh], 8
        je short .6
        xor edx, edx
        mov eax, esp
        mov dl, byte [byte ecx+019h]
        call __MkTmpFile_
        mov eax, esp
        call j_unlink_
.6:
        mov eax, esi
        add esp, byte 10h
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; strncpy_                                                      91E4D  library
; Run-time library strncpy: copies at most n characters
;-----------------------------------------------------------------------------
strncpy_:
        push ecx
        push esi
        mov esi, eax
        jmp short .2
.1:
        mov cl, byte [edx]
        test cl, cl
        je short .3
        inc edx
        dec ebx
        mov byte [eax], cl
        inc eax
.2:
        test ebx, ebx
        jne short .1
.3:
        test ebx, ebx
        je short .4
        dec ebx
        mov byte [eax], 0
        inc eax
        jmp short .3
.4:
        mov eax, esi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; fputs_                                                        91E72  library
; Run-time library fputs: writes a string to a stream
;-----------------------------------------------------------------------------
fputs_:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ecx, eax
        mov ebx, edx
        cmp dword [byte edx+08h], byte 0
        jne short .1
        mov eax, ebx
        call __ioalloc_
.1:
        mov ah, byte [byte ebx+0Dh]
        xor edi, edi
        test ah, 4
        je short .2
        mov dl, ah
        and dl, 0F9h
        mov dh, dl
        mov byte [byte ebx+0Dh], dl
        or dh, 2
        mov edi, 1
        mov byte [byte ebx+0Dh], dh
.2:
        mov ebp, ecx
        xor esi, esi
.3:
        xor eax, eax
        mov al, byte [ecx]
        test eax, eax
        je short .4
        mov edx, ebx
        inc ecx
        call fputc_
        cmp eax, byte 0FFFFFFFFh
        jne short .3
        mov esi, eax
.4:
        test edi, edi
        je short .5
        mov al, byte [byte ebx+0Dh]
        and al, 0F9h
        mov ah, al
        mov byte [byte ebx+0Dh], al
        or ah, 4
        mov byte [byte ebx+0Dh], ah
        test esi, esi
        jne short .5
        mov eax, ebx
        call __flush_
        mov esi, eax
.5:
        test esi, esi
        jne short .6
        mov esi, ecx
        sub esi, ebp
.6:
        mov eax, esi
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; strcmp_                                                       91F00  library
; Run-time library strcmp: compares two strings
;-----------------------------------------------------------------------------
strcmp_:
        push ebx
        push ecx
        mov ebx, eax
        cmp eax, edx
        je short .2
.1:
        mov eax, dword [ebx]
        mov ecx, dword [edx]
        cmp ecx, eax
        jne short .3
        not ecx
        add eax, 0FEFEFEFFh
        and eax, ecx
        and eax, 80808080h
        jne short .2
        mov eax, dword [byte ebx+04h]
        mov ecx, dword [byte edx+04h]
        cmp ecx, eax
        jne short .3
        not ecx
        add eax, 0FEFEFEFFh
        and eax, ecx
        and eax, 80808080h
        jne short .2
        mov eax, dword [byte ebx+08h]
        mov ecx, dword [byte edx+08h]
        cmp ecx, eax
        jne short .3
        not ecx
        add eax, 0FEFEFEFFh
        and eax, ecx
        and eax, 80808080h
        jne short .2
        mov eax, dword [byte ebx+0Ch]
        mov ecx, dword [byte edx+0Ch]
        cmp ecx, eax
        jne short .3
        add ebx, byte 10h
        add edx, byte 10h
        not ecx
        add eax, 0FEFEFEFFh
        and eax, ecx
        and eax, 80808080h
        je short .1
.2:
        sub eax, eax
        pop ecx
        pop ebx
        ret
.3:
        cmp al, cl
        jne short .4
        cmp al, 0
        je short .2
        cmp ah, ch
        jne short .4
        cmp ah, 0
        je short .2
        shr eax, 10h
        shr ecx, 10h
        cmp al, cl
        jne short .4
        cmp al, 0
        je short .2
        cmp ah, ch
.4:
        sbb eax, eax
        or al, 1
        pop ecx
        pop ebx
        ret
        db 00h,00h,00h
;-----------------------------------------------------------------------------
; FixedMulRound                                91FA4  95 PC, medium confidence
; Multiplies two 16.16 fixed-point numbers with rounding
;-----------------------------------------------------------------------------
FixedMulRound:
        mov eax, dword [byte esp+04h]
        imul dword [byte esp+08h]
        add eax, 7FFFh
        adc edx, byte 0
        shrd eax, edx, 10h
        ret
        db 00h,00h,00h
;-----------------------------------------------------------------------------
; memcmp_                                                       91FBC  library
; Run-time library memcmp: compares two blocks
;-----------------------------------------------------------------------------
memcmp_:
        push ecx
        push esi
        push edi
        mov esi, eax
        mov edi, edx
        mov ecx, ebx
        push es
        mov eax, ds
        mov es, eax
        xor eax, eax
        repe cmpsb
        je short .1
        sbb eax, eax
        sbb eax, byte 0FFFFFFFFh
.1:
        pop es
        pop edi
        pop esi
        pop ecx
        ret
        db 00h,00h,00h,00h,00h,00h
