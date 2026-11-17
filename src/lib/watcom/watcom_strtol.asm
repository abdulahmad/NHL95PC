; Watcom C runtime: strtol and strtoul.
bits 32
%include "hockey.inc"
section s_A6BE1 progbits alloc exec nowrite align=1
extern __set_errno_, CharClassTable, tolower_
global StrToLong, strtol_, strtoul_, DigitValue
;-----------------------------------------------------------------------------
; StrToLong                                    A6BE1  95 PC, medium confidence
; Converts a string to a number, signed or unsigned (the core of strtol and
; strtoul)
;-----------------------------------------------------------------------------
StrToLong:
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ebp, eax
        mov edi, edx
        mov esi, ebx
        mov dword [byte esp+04h], ecx
        test edx, edx
        je short .1
        mov dword [edx], eax
.1:
        mov edx, ebp
.2:
        mov al, byte [edx]
        inc al
        and eax, 0FFh
        test byte [dword eax+CharClassTable], 2
        je short .3
        inc edx
        jmp short .2
.3:
        mov al, byte [edx]
        mov byte [byte esp+0Ch], al
        cmp al, 2Bh
        je short .4
        cmp al, 2Dh
        jne short .5
.4:
        inc edx
.5:
        test esi, esi
        jne short .9
        cmp byte [edx], 30h
        jne short .7
        mov al, byte [byte edx+01h]
        cmp al, 78h
        je short .6
        cmp al, 58h
        jne short .7
.6:
        mov esi, 10h
        jmp short .9
.7:
        cmp byte [edx], 30h
        jne short .8
        mov esi, 8
        jmp short .9
.8:
        mov esi, 0Ah
.9:
        cmp esi, byte 2
        jl short .10
        cmp esi, byte 24h
        jle short .11
.10:
        mov eax, 0Dh
        call __set_errno_
        xor eax, eax
        jmp near .25
.11:
        cmp esi, byte 10h
        jne short .13
        cmp byte [edx], 30h
        jne short .13
        mov cl, byte [byte edx+01h]
        cmp cl, 78h
        je short .12
        cmp cl, 58h
        jne short .13
.12:
        add edx, byte 2
.13:
        mov dword [esp], edx
        xor al, al
        xor ebx, ebx
        mov byte [byte esp+08h], al
.14:
        xor eax, eax
        mov al, byte [edx]
        call DigitValue
        cmp eax, esi
        jge short .16
        mov ecx, ebx
        imul ebx, esi
        add ebx, eax
        cmp ebx, ecx
        jae short .15
        mov byte [byte esp+08h], 1
.15:
        inc edx
        jmp short .14
.16:
        cmp edx, dword [esp]
        jne short .17
        mov edx, ebp
.17:
        test edi, edi
        je short .18
        mov dword [edi], edx
.18:
        cmp dword [byte esp+04h], byte 1
        jne short .20
        cmp ebx, 80000000h
        jb short .20
        jne short .19
        cmp byte [byte esp+0Ch], 2Dh
        je short .20
.19:
        mov byte [byte esp+08h], 1
.20:
        cmp byte [byte esp+08h], 0
        je short .23
        mov eax, 0Eh
        mov edi, dword [byte esp+04h]
        call __set_errno_
        test edi, edi
        jne short .21
        mov eax, 0FFFFFFFFh
        jmp short .25
.21:
        cmp byte [byte esp+0Ch], 2Dh
        jne short .22
        mov eax, 80000000h
        jmp short .25
.22:
        mov eax, 7FFFFFFFh
        jmp short .25
.23:
        cmp byte [byte esp+0Ch], 2Dh
        jne short .24
        neg ebx
.24:
        mov eax, ebx
.25:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
;-----------------------------------------------------------------------------
; strtol_                                      A6D1A  95 PC, medium confidence
; C library strtol: signed form of the shared string to number routine
;-----------------------------------------------------------------------------
strtol_:
        push ecx
        xor ecx, ecx
        call StrToLong
        pop ecx
        ret
;-----------------------------------------------------------------------------
; strtoul_                                     A6D24  95 PC, medium confidence
; Converts a string to an unsigned number (strtoul)
;-----------------------------------------------------------------------------
strtoul_:
        push ecx
        mov ecx, 1
        jmp short strtol_+03h
;-----------------------------------------------------------------------------
; DigitValue                                   A6D2C  95 PC, medium confidence
; Returns the value of a digit or letter in bases up to 36, or 37 if it is
; not one
;-----------------------------------------------------------------------------
DigitValue:
        push edx
        mov dl, al
        cmp al, 30h
        jb short .1
        cmp al, 39h
        ja short .1
        xor eax, eax
        mov al, dl
        sub eax, byte 30h
        pop edx
        ret
.1:
        xor eax, eax
        mov al, dl
        call tolower_
        mov dl, al
        cmp al, 61h
        jb short .2
        cmp al, 69h
        ja short .2
        and eax, 0FFh
        sub eax, byte 57h
        pop edx
        ret
.2:
        cmp dl, 6Ah
        jb short .4
        cmp dl, 72h
        ja short .4
.3:
        xor eax, eax
        mov al, dl
        sub eax, byte 57h
        pop edx
        ret
.4:
        cmp dl, 73h
        jb short .5
        cmp dl, 7Ah
        jbe short .3
.5:
        mov eax, 25h
        pop edx
        ret
