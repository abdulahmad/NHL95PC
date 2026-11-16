; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_91984 progbits alloc exec nowrite align=1
extern __allocfp_, __chktty_, __doclose_, __ExpandDGROUP_, __freefp_, __MemAllocator, __MemFree, __set_errno_
extern __nheap_clean, HeapList, HeapRover, HeapLargestFree, _fmode, __OpenStreams, __ClosedStreams, fseek_
extern sopen_, McgaNoWindow, tolower_
global _nmalloc_, _nfree_, strlen_, __open_flags_, __doopen_, _fsopen_, fopen_, close_file_
;-----------------------------------------------------------------------------
; _nmalloc_                                                     91984  library
; Run-time library: allocates from the near heap
;-----------------------------------------------------------------------------
_nmalloc_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push es
        push fs
        push gs
        push ebp
        sub esp, byte 4
        mov esi, eax
        test eax, eax
        je short .1
        cmp eax, byte 0FFFFFFD4h
        jbe short .2
.1:
        xor eax, eax
        jmp near .13
.2:
        mov ebp, HeapList
        lea edi, [byte esi+03h]
        xor ah, ah
        xor ebx, ebx
        mov byte [esp], ah
        and di, byte 0FFFCh
.3:
        mov eax, edi
        cmp edi, byte 0Ch
        jae short .4
        mov eax, 0Ch
.4:
        cmp eax, dword [HeapLargestFree]
        jbe short .6
        mov ecx, dword [HeapRover]
        test ecx, ecx
        jne short .9
.5:
        mov dword [HeapLargestFree], ecx
        mov ecx, dword [HeapList]
        jmp short .9
.6:
        xor ecx, ecx
        jmp short .5
.7:
        mov edx, ds
        mov eax, ebp
        mov dword [HeapRover], ecx
        and edx, 0FFFFh
        mov eax, esi
        mov ebx, ecx
        call __MemAllocator
        mov ebx, eax
        test eax, eax
        jne short .12
        mov eax, dword [HeapLargestFree]
        mov edx, dword [byte ecx+014h]
        cmp edx, eax
        jbe short .8
        mov dword [HeapLargestFree], edx
.8:
        mov ecx, dword [byte ecx+08h]
.9:
        test ecx, ecx
        jne short .7
        cmp byte [esp], 0
        jne short .10
        mov eax, esi
        call __ExpandDGROUP_
        test eax, eax
        jne short .11
.10:
        mov eax, esi
        call McgaNoWindow
        test eax, eax
        je short .12
        xor cl, cl
        mov byte [esp], cl
        jmp near .3
.11:
        mov byte [esp], 1
        jmp near .3
.12:
        xor ch, ch
        mov eax, ebx
        mov byte [__nheap_clean], ch
.13:
        add esp, byte 4
        pop ebp
        pop gs
        pop fs
        pop es
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; _nfree_                                                       91A67  library
; Run-time library: frees near heap memory
;-----------------------------------------------------------------------------
_nfree_:
        push ebx
        push ecx
        push edx
        push ebp
        mov ebx, eax
        mov ecx, dword [HeapList]
        jmp short .3
.1:
        cmp ecx, ebx
        ja short .2
        cmp ebx, edx
        jb short .4
.2:
        mov ecx, dword [byte ecx+08h]
.3:
        mov edx, dword [byte ecx+08h]
        test edx, edx
        jne short .1
.4:
        mov eax, HeapList
        mov edx, ds
        and edx, 0FFFFh
        mov eax, ebx
        mov ebx, ecx
        call __MemFree
        cmp ecx, dword [HeapRover]
        je short .5
        mov ebp, dword [HeapLargestFree]
        mov edx, dword [byte ecx+014h]
        cmp edx, ebp
        jbe short .5
        mov dword [HeapLargestFree], edx
.5:
        xor ah, ah
        mov byte [__nheap_clean], ah
        pop ebp
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; strlen_                                                       91AC5  library
; Run-time library strlen: the length of a string
;-----------------------------------------------------------------------------
strlen_:
        push ecx
        push edi
        mov edi, eax
        push es
        mov eax, ds
        mov es, eax
        sub ecx, ecx
        dec ecx
        xor eax, eax
        repne scasb
        not ecx
        dec ecx
        pop es
        mov eax, ecx
        pop edi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; __open_flags_                                                 91ADE  library
; Run-time library: turns an fopen mode string into open flags
;-----------------------------------------------------------------------------
__open_flags_:
        push ebx
        push ecx
        push edx
        sub esp, byte 4
        mov edx, eax
        xor eax, eax
        mov al, byte [edx]
        xor ebx, ebx
        call tolower_
        mov byte [esp], al
        cmp al, 72h
        je short .1
        cmp al, 77h
        je short .1
        cmp al, 61h
        je short .1
        mov eax, 9
        call __set_errno_
        xor eax, eax
        jmp near .12
.1:
        mov eax, ebx
        mov cl, byte [byte edx+01h]
        or al, 3
        cmp cl, 2Bh
        jne short .4
        mov ebx, eax
        mov cl, byte [byte edx+02h]
        or al, 40h
        cmp cl, 62h
        je short .3
        cmp cl, 74h
        je short .8
        cmp dword [_fmode], 200h
.2:
        jne short .8
.3:
        mov ebx, eax
        jmp short .8
.4:
        mov ecx, ebx
        or cl, 40h
        cmp byte [byte edx+01h], 62h
        jne short .5
        mov al, byte [byte edx+02h]
        mov ebx, ecx
        cmp al, 2Bh
        jne short .8
        or cl, 3
        jmp short .7
.5:
        cmp byte [byte edx+01h], 74h
        jne short .6
        cmp byte [byte edx+02h], 2Bh
        jmp short .2
.6:
        cmp dword [_fmode], 200h
        jne short .8
.7:
        mov ebx, ecx
.8:
        mov al, byte [esp]
        cmp al, 77h
        jne short .9
        or bl, 2
        jmp short .11
.9:
        cmp al, 61h
        jne short .10
        or bl, 82h
        jmp short .11
.10:
        or bl, 1
.11:
        mov eax, ebx
.12:
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __doopen_                                                     91B92  library
; Run-time library: opens a file for a stream
;-----------------------------------------------------------------------------
__doopen_:
        push esi
        push edi
        mov esi, eax
        and byte [byte ecx+0Ch], 0FCh
        mov eax, edx
        call __open_flags_
        mov edi, dword [byte ecx+0Ch]
        or edi, eax
        xor eax, eax
        mov dword [byte ecx+0Ch], edi
        mov al, byte [edx]
        call tolower_
        mov dl, al
        cmp al, 72h
        jne short .4
        mov dh, byte [byte ecx+0Ch]
        xor eax, eax
        test dh, 2
        je short .1
        mov eax, 2
.1:
        test byte [byte ecx+0Ch], 40h
        je short .2
        or ah, 2
        jmp short .3
.2:
        or ah, 1
.3:
        push byte 0
        jmp short .9
.4:
        test byte [byte ecx+0Ch], 1
        setne al
        and eax, 0FFh
        add eax, byte 21h
        cmp dl, 61h
        jne short .5
        or al, 10h
        jmp short .6
.5:
        or al, 40h
.6:
        test byte [byte ecx+0Ch], 40h
        je short .7
        or ah, 2
        jmp short .8
.7:
        or ah, 1
.8:
        push dword 180h
.9:
        push ebx
        push eax
        push esi
        call sopen_
        add esp, byte 10h
        mov dword [byte ecx+010h], eax
        cmp dword [byte ecx+010h], byte 0FFFFFFFFh
        jne short .10
        mov eax, ecx
        call __freefp_
        xor eax, eax
        pop edi
        pop esi
        ret
.10:
        mov dword [byte ecx+04h], 0
        mov dword [byte ecx+08h], 0
        mov dword [byte ecx+014h], 0
        cmp dl, 61h
        jne short .11
        mov ebx, 2
        mov eax, ecx
        xor edx, edx
        call fseek_
.11:
        mov eax, ecx
        call __chktty_
        mov eax, ecx
        pop edi
        pop esi
        ret
;-----------------------------------------------------------------------------
; _fsopen_                                                      91C5A  library
; Run-time library _fsopen: opens a stream with a share mode
;-----------------------------------------------------------------------------
_fsopen_:
        push ecx
        push esi
        mov esi, eax
        xor eax, eax
        call __allocfp_
        mov ecx, eax
        test eax, eax
        je short .1
        mov eax, esi
        call __doopen_
.1:
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; fopen_                                                        91C75  library
; Run-time library fopen: opens a stream
;-----------------------------------------------------------------------------
fopen_:
        push ebx
        xor ebx, ebx
        call _fsopen_
        pop ebx
        ret
;-----------------------------------------------------------------------------
; close_file_                                                   91C7F  library
; Run-time library: closes the file of a stream
;-----------------------------------------------------------------------------
close_file_:
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov eax, dword [__ClosedStreams]
.1:
        test eax, eax
        je short .4
        mov edx, dword [byte eax+04h]
        cmp ebx, edx
        jne short .3
        test byte [byte edx+0Ch], 3
        je short .2
        mov eax, edx
        mov edx, 1
        call __doclose_
.2:
        mov eax, ebx
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        mov eax, dword [eax]
        jmp short .1
.4:
        mov edx, __OpenStreams
.5:
        mov eax, dword [edx]
        test eax, eax
        je short .7
        cmp ebx, dword [byte eax+04h]
        jne short .6
        mov ecx, dword [eax]
        mov dword [edx], ecx
        mov edx, dword [__ClosedStreams]
        mov dword [__ClosedStreams], eax
        mov dword [eax], edx
        jmp short .2
.6:
        mov edx, eax
        jmp short .5
.7:
        mov eax, 4
        call __set_errno_
        xor eax, eax
        pop edx
        pop ecx
        pop ebx
        ret
