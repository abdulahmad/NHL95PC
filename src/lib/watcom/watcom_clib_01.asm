; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_8C94C progbits alloc exec nowrite align=1
extern __fatal_runtime_error_, str_StackOverflow, _STACKLOW, saved_ss
global __CHK, __GRO, __STK, loc_8C970, sub_8C97D
__CHK:
        xchg eax, dword [byte esp+04h]
        call __STK
        mov eax, dword [byte esp+04h]
        ret 4
__GRO:
        ret 4
__STK:
        cmp eax, esp
        jae short loc_8C970
        sub eax, esp
        neg eax
        cmp eax, dword [_STACKLOW]
        jbe short loc_8C970
        ret
loc_8C970:
        mov ax, ss
        cmp ax, word [saved_ss]
        je short sub_8C97D
        ret
sub_8C97D:
        mov eax, str_StackOverflow
        mov edx, 1
        call __fatal_runtime_error_
        db 00h,00h,00h,00h
