; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_90A40 progbits alloc exec nowrite align=1
extern byte_D42C0, byte_D42C1, byte_D42C2, byte_D42C4, dword_D42C8, dword_D42D0
global TextWidthN
TextWidthN:
        push esi
        push edi
        push ebp
        mov edx, dword [byte esp+010h]
        mov ecx, dword [byte esp+014h]
        xor eax, eax
        movzx esi, byte [byte_D42C1]
        xor ebx, ebx
        mov bl, byte [byte_D42C0]
        sub esi, ebx
        lea edi, [byte esi+01h]
        cmp byte [edx], 0
        je short .7
        mov ebp, dword [dword_D42C8]
.1:
        test ecx, ecx
        je short .7
        mov bl, byte [edx]
        sub bl, byte [byte_D42C0]
        and ebx, 0FFh
        cmp ebx, edi
        jge short .6
        mov esi, dword [dword_D42D0]
        test esi, esi
        je short .2
        mov bl, byte [esi+ebx]
        and ebx, 0FFh
        jmp short .5
.2:
        test ebp, ebp
        je short .3
        mov esi, ebp
        movzx esi, byte [esi+ebx]
        jmp short .4
.3:
        movzx esi, byte [byte_D42C2]
.4:
        xor ebx, ebx
        mov bl, byte [byte_D42C4]
        add ebx, esi
.5:
        add eax, ebx
.6:
        inc edx
        dec ecx
        cmp byte [edx], 0
        jne short .1
.7:
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
