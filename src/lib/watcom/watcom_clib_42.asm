; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_A321C progbits alloc exec nowrite align=1
extern strtod_
global forcedecpt_, __cnvs2d_
;-----------------------------------------------------------------------------
; forcedecpt_                                                   A321C  library
; Run-time library: makes sure a formatted float has a decimal point
;-----------------------------------------------------------------------------
forcedecpt_:
        push ebx
        push ecx
        mov ebx, edx
        test byte [byte edx+014h], 1
        jne short .6
.1:
        mov dh, byte [eax]
        test dh, dh
        je short .2
        cmp dh, 65h
        je short .2
        cmp dh, 45h
        je short .2
        inc eax
        jmp short .1
.2:
        mov edx, eax
        mov cl, byte [byte ebx+015h]
        dec eax
        cmp cl, 47h
        je short .3
        cmp cl, 67h
        jne short .4
.3:
        cmp byte [eax], 30h
        jne short .4
        dec eax
        jmp short .3
.4:
        cmp byte [eax], 2Eh
        je short .5
        inc eax
.5:
        mov bl, byte [edx]
        inc edx
        mov byte [eax], bl
        inc eax
        test bl, bl
        jne short .5
.6:
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __cnvs2d_                                                     A3264  library
; Run-time library: a decimal string to a double
;-----------------------------------------------------------------------------
__cnvs2d_:
        push ebx
        mov ebx, edx
        xor edx, edx
        call strtod_
        fstp qword [ebx]
        pop ebx
        ret
        db 00h,00h
