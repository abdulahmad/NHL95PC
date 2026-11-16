; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_9D586 progbits alloc exec nowrite align=1
extern __init_80x87, str_UnknownError, __8087, FpuType, delaycount, __save_8087_, StrErrorTable, EmuInitHook
extern EmuFiniHook, __save_8087_, _doserrno, ErrnoVar, __no87, DefaultControlWord
global __init_8087_, _fpreset_, __chk8087_, __delay_init_, __delay_, ErrnoPtr, __get_doserrno_ptr_, strerror_
__init_8087_:
        push ebx
        push edx
        cmp byte [FpuType], 0
        je short .1
        mov edx, __save_8087_
        mov ebx, __save_8087_+05h
        mov dword [EmuInitHook], edx
        mov dword [EmuFiniHook], ebx
.1:
        xor eax, eax
        mov ax, word [DefaultControlWord]
        call __init_80x87
        pop edx
        pop ebx
        ret
_fpreset_:
        cmp byte [FpuType], 0
        jne short __init_8087_
        ret
__chk8087_:
        push edx
        mov ah, byte [__8087]
        test ah, ah
        jne short .2
        mov byte [FpuType], ah
        LD sub, eax, eax
        push eax
        fninit
        fnstcw word [esp]
        pop eax
        LD mov, al, ah
        xor dl, dl
        cmp al, 3
        jne short .1
        call __init_8087_
        mov dl, al
.1:
        cmp byte [__no87], 0
        jne short .2
        mov byte [__8087], dl
        mov byte [FpuType], dl
.2:
        pop edx
        ret
__delay_init_:
        push ebx
        push ecx
        push edx
        push esi
        mov ah, 2Ch
        int 21h
        xor eax, eax
        mov al, dh
        mov ebx, eax
.1:
        mov ah, 2Ch
        int 21h
        xor eax, eax
        db 088h,0F0h                            ; insn: mov al,dh
        db 039h,0C3h                            ; insn: cmp ebx,eax
        db 074h, .1-($+2)
        db 031h,0F6h                            ; insn: xor esi,esi
        mov bl, al
.2:
        mov ah, 2Ch
        int 21h
        inc esi
        cmp bl, dh
        je short .2
        mov dword [delaycount], esi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
__delay_:
        push ebx
        push ecx
        push edx
        push esi
        test eax, eax
        je short .3
        imul eax, dword [delaycount]
        mov esi, 3E8h
        add eax, 1F4h
        xor edx, edx
        div esi
        mov esi, eax
        test eax, eax
        jne short .1
        lea esi, [byte eax+01h]
.1:
        xor eax, eax
        mov bl, al
.2:
        mov ah, 2Ch
        int 21h
        cmp bl, dh
        dec esi
        jne short .2
.3:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
ErrnoPtr:
        mov eax, ErrnoVar
        ret
__get_doserrno_ptr_:
        mov eax, _doserrno
        ret
strerror_:
        test eax, eax
        jl short .1
        cmp eax, byte 0Fh
        jle short .2
.1:
        mov eax, str_UnknownError
        ret
.2:
        mov eax, dword [nosplit eax*4+StrErrorTable]
        ret
