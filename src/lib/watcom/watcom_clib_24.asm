; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_9805E progbits alloc exec nowrite align=1
extern fgetc_
global _fmemmove_, _Alphabet, utoa_, itoa_, fgets_
;-----------------------------------------------------------------------------
; _fmemmove_                                                    9805E  library
; C run-time: far memmove, copies memory that may overlap
;-----------------------------------------------------------------------------
_fmemmove_:
        push esi
        push edi
        push es
        push fs
        push edx
        mov esi, ecx
        mov ecx, dword [byte esp+018h]
        mov edx, eax
        mov eax, ebx
        cmp ebx, edx
        jne short .1
        cmp si, word [esp]
        je short .4
.1:
        cmp eax, edx
        jae short .3
        lea edi, [eax+ecx]
        cmp edi, edx
        jbe short .3
        mov fs, word [esp]
        mov es, esi
        mov eax, edi
        add edx, ecx
.2:
        test ecx, ecx
        je short .4
        dec eax
        dec edx
        mov bl, byte [es:eax]
        dec ecx
        mov byte [fs:edx], bl
        jmp short .2
.3:
        mov es, word [esp]
        mov edi, edx
        push ds
        xchg esi, eax
        mov ds, eax
        shr ecx, 1
        db 066h,0F3h,0A5h                       ; insn: rep movsw
        adc ecx, ecx
        rep movsb
        pop ds
.4:
        mov ebx, dword [esp]
        mov eax, edx
        mov edx, ebx
        add esp, byte 4
        pop fs
        pop es
        pop edi
        pop esi
        ret 4
_Alphabet:                                      ; used by utoa_
        db 030h,031h,032h,033h,034h,035h,036h,037h,038h,039h,061h,062h,063h,064h,065h,066h
        db 067h,068h,069h,06Ah,06Bh,06Ch,06Dh,06Eh,06Fh,070h,071h,072h,073h,074h,075h,076h
        db 077h,078h,079h,07Ah,00h
;-----------------------------------------------------------------------------
; utoa_                                                         980E5  library
; Run-time library utoa: an unsigned integer to a string
;-----------------------------------------------------------------------------
utoa_:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 28h
        mov ebp, edx
        mov edi, ebx
        mov esi, edx
        xor dl, dl
        lea ecx, [byte esp+01h]
        mov byte [esp], dl
.1:
        lea ebx, [byte esp+024h]
        mov dword [byte esp+024h], edi
        xor edx, edx
        div dword [ebx]
        mov dword [ebx], eax
        mov al, byte [dword cs:edx+_Alphabet]
        mov byte [ecx], al
        mov eax, dword [byte esp+024h]
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
        mov eax, ebp
        add esp, byte 28h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; itoa_                                                         9812F  library
; Run-time library itoa: an integer to a string
;-----------------------------------------------------------------------------
itoa_:
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
        call utoa_
        mov eax, ecx
        pop ecx
        ret
;-----------------------------------------------------------------------------
; fgets_                                                        9814A  library
; Run-time library fgets: reads a line from a stream
;-----------------------------------------------------------------------------
fgets_:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov ecx, edx
        mov edx, edi
        mov ah, byte [byte ebx+0Ch]
        mov ebp, dword [byte ebx+0Ch]
        and ah, 0CFh
        and ebp, byte 30h
        mov byte [byte ebx+0Ch], ah
.1:
        dec ecx
        test ecx, ecx
        jle short .2
        mov eax, ebx
        call fgetc_
        mov dword [esp], eax
        cmp eax, byte 0FFFFFFFFh
        je short .2
        mov al, byte [esp]
        mov byte [edx], al
        inc edx
        cmp al, 0Ah
        jne short .1
.2:
        cmp dword [esp], byte 0FFFFFFFFh
        jne short .4
        cmp edx, edi
        je short .3
        test byte [byte ebx+0Ch], 20h
        je short .4
.3:
        xor edi, edi
        jmp short .5
.4:
        mov byte [edx], 0
.5:
        mov esi, dword [byte ebx+0Ch]
        or esi, ebp
        mov eax, edi
        mov dword [byte ebx+0Ch], esi
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
