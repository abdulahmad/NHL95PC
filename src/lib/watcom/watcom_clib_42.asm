; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_A321C progbits alloc exec nowrite align=1
extern strtod_
global forcedecpt_, loc_A3226, loc_A3239, loc_A3249, loc_A3251, loc_A3257, loc_A3261, __cnvs2d_
forcedecpt_:
        push ebx
        push ecx
        mov ebx, edx
        test byte [byte edx+014h], 1
        jne short loc_A3261
loc_A3226:
        mov dh, byte [eax]
        test dh, dh
        je short loc_A3239
        cmp dh, 65h
        je short loc_A3239
        cmp dh, 45h
        je short loc_A3239
        inc eax
        jmp short loc_A3226
loc_A3239:
        mov edx, eax
        mov cl, byte [byte ebx+015h]
        dec eax
        cmp cl, 47h
        je short loc_A3249
        cmp cl, 67h
        jne short loc_A3251
loc_A3249:
        cmp byte [eax], 30h
        jne short loc_A3251
        dec eax
        jmp short loc_A3249
loc_A3251:
        cmp byte [eax], 2Eh
        je short loc_A3257
        inc eax
loc_A3257:
        mov bl, byte [edx]
        inc edx
        mov byte [eax], bl
        inc eax
        test bl, bl
        jne short loc_A3257
loc_A3261:
        pop ecx
        pop ebx
        ret
__cnvs2d_:
        push ebx
        mov ebx, edx
        xor edx, edx
        call strtod_
        fstp qword [ebx]
        pop ebx
        ret
        db 00h,00h
