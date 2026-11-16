; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_A2AC8 progbits alloc exec nowrite align=1
extern __fatal_runtime_error_, str_FloatingPointSupportNot, __heap_enabled, __amblksiz
global abs_, __CommonInit_, NoFloatSupport, str_DigitChars, ultoa_, ltoa_, toupper_, _heapenable_
abs_:
        test eax, eax
        jge short .1
        neg eax
.1:
        ret
__CommonInit_:
        mov dword [__amblksiz], 8000h
        ret
        db 00h,00h
NoFloatSupport:
        push edx
        mov eax, str_FloatingPointSupportNot
        mov edx, 1
        call __fatal_runtime_error_
        pop edx
        ret
str_DigitChars:
        db 030h,031h,032h,033h,034h,035h,036h,037h,038h,039h,061h,062h,063h,064h,065h,066h
        db 067h,068h,069h,06Ah,06Bh,06Ch,06Dh,06Eh,06Fh,070h,071h,072h,073h,074h,075h,076h
        db 077h,078h,079h,07Ah,00h
ultoa_:
        push ecx
        push esi
        push ebp
        sub esp, byte 28h
        push edx
        mov ebp, ebx
        mov esi, edx
        xor dl, dl
        lea ecx, [byte esp+05h]
        mov byte [byte esp+04h], dl
.1:
        lea ebx, [byte esp+028h]
        mov dword [byte esp+028h], ebp
        xor edx, edx
        div dword [ebx]
        mov dword [ebx], edx
        mov edx, dword [byte esp+028h]
        mov dl, byte [dword cs:edx+str_DigitChars]
        mov byte [ecx], dl
        inc ecx
        test eax, eax
        jne short .1
.2:
        dec ecx
        mov al, byte [ecx]
        mov byte [esi], al
        inc esi
        test al, al
        jne short .2
        mov eax, dword [esp]
        add esp, byte 2Ch
        pop ebp
        pop esi
        pop ecx
        ret
ltoa_:
        push ecx
        mov ecx, edx
        cmp ebx, byte 0Ah
        jne short .1
        test eax, eax
        jge short .1
        neg eax
        mov byte [edx], 2Dh
        inc edx
.1:
        call ultoa_
        mov eax, ecx
        pop ecx
        ret
toupper_:
        cmp eax, byte 61h
        jl short .1
        cmp eax, byte 7Ah
        jg short .1
        sub eax, byte 20h
.1:
        ret
_heapenable_:
        push edx
        mov edx, eax
        mov eax, dword [__heap_enabled]
        mov dword [__heap_enabled], edx
        pop edx
        ret
