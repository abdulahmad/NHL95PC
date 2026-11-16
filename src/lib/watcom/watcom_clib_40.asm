; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_A2AC8 progbits alloc exec nowrite align=1
extern __fatal_runtime_error_, str_FloatingPointSupportNot, dword_D5670, dword_D5674
global abs_, loc_A2ACE, __CommonInit_, NoFloatSupport, unk_A2AEE, ultoa_, loc_A2B28, loc_A2B48
global ltoa_, loc_A2B6E, toupper_, loc_A2B84, sub_A2B85
abs_:
        test eax, eax
        jge short loc_A2ACE
        neg eax
loc_A2ACE:
        ret
__CommonInit_:
        mov dword [dword_D5674], 8000h
        ret
        db 00h,00h
NoFloatSupport:
        push edx
        mov eax, str_FloatingPointSupportNot
        mov edx, 1
        call __fatal_runtime_error_
        pop edx
        ret
unk_A2AEE:
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
loc_A2B28:
        lea ebx, [byte esp+028h]
        mov dword [byte esp+028h], ebp
        xor edx, edx
        div dword [ebx]
        mov dword [ebx], edx
        mov edx, dword [byte esp+028h]
        mov dl, byte [dword cs:edx+unk_A2AEE]
        mov byte [ecx], dl
        inc ecx
        test eax, eax
        jne short loc_A2B28
loc_A2B48:
        dec ecx
        mov al, byte [ecx]
        mov byte [esi], al
        inc esi
        test al, al
        jne short loc_A2B48
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
        jne short loc_A2B6E
        test eax, eax
        jge short loc_A2B6E
        neg eax
        mov byte [edx], 2Dh
        inc edx
loc_A2B6E:
        call ultoa_
        mov eax, ecx
        pop ecx
        ret
toupper_:
        cmp eax, byte 61h
        jl short loc_A2B84
        cmp eax, byte 7Ah
        jg short loc_A2B84
        sub eax, byte 20h
loc_A2B84:
        ret
sub_A2B85:
        push edx
        mov edx, eax
        mov eax, dword [dword_D5670]
        mov dword [dword_D5670], edx
        pop edx
        ret
