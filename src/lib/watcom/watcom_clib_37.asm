; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_9D586 progbits alloc exec nowrite align=1
extern __init_80x87, str_UnknownError, __8087, FpuType, delaycount, loc_9D582, off_D51E4, off_D6600
extern off_D6604, __save_8087_, unk_F24D0, unk_F24D4, __no87, DefaultControlWord
global __init_8087_, loc_9D5A7, _fpreset_, __chk8087_, loc_9D5EA, loc_9D5FF, __delay_init_, loc_9D60F
global loc_9D61F, __delay_, loc_9D659, loc_9D65D, loc_9D666, ErrnoPtr, __get_doserrno_ptr_, strerror_
global loc_9D680, loc_9D686
__init_8087_:
        push ebx
        push edx
        cmp byte [FpuType], 0
        je short loc_9D5A7
        mov edx, __save_8087_
        mov ebx, loc_9D582
        mov dword [off_D6600], edx
        mov dword [off_D6604], ebx
loc_9D5A7:
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
        jne short loc_9D5FF
        mov byte [FpuType], ah
        LD sub, eax, eax
        push eax
        fninit
        fnstcw word [esp]
        pop eax
        LD mov, al, ah
        xor dl, dl
        cmp al, 3
        jne short loc_9D5EA
        call __init_8087_
        mov dl, al
loc_9D5EA:
        cmp byte [__no87], 0
        jne short loc_9D5FF
        mov byte [__8087], dl
        mov byte [FpuType], dl
loc_9D5FF:
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
loc_9D60F:
        mov ah, 2Ch
        int 21h
        xor eax, eax
        db 088h,0F0h                            ; insn: mov al,dh
        db 039h,0C3h                            ; insn: cmp ebx,eax
        db 074h, loc_9D60F-($+2)
        db 031h,0F6h                            ; insn: xor esi,esi
        mov bl, al
loc_9D61F:
        mov ah, 2Ch
        int 21h
        inc esi
        cmp bl, dh
        je short loc_9D61F
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
        je short loc_9D666
        imul eax, dword [delaycount]
        mov esi, 3E8h
        add eax, 1F4h
        xor edx, edx
        div esi
        mov esi, eax
        test eax, eax
        jne short loc_9D659
        lea esi, [byte eax+01h]
loc_9D659:
        xor eax, eax
        mov bl, al
loc_9D65D:
        mov ah, 2Ch
        int 21h
        cmp bl, dh
        dec esi
        jne short loc_9D65D
loc_9D666:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
ErrnoPtr:
        mov eax, unk_F24D4
        ret
__get_doserrno_ptr_:
        mov eax, unk_F24D0
        ret
strerror_:
        test eax, eax
        jl short loc_9D680
        cmp eax, byte 0Fh
        jle short loc_9D686
loc_9D680:
        mov eax, str_UnknownError
        ret
loc_9D686:
        mov eax, dword [nosplit eax*4+off_D51E4]
        ret
