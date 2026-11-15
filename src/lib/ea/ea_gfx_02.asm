; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_90A40 progbits alloc exec nowrite align=1
extern byte_D42C0, byte_D42C1, byte_D42C2, byte_D42C4, dword_D42C8, dword_D42D0
global sub_90A40, loc_90A6C, loc_90A97, loc_90AA3, loc_90AAA, loc_90AB4, loc_90AB6, loc_90ABD
sub_90A40:
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
        je short loc_90ABD
        mov ebp, dword [dword_D42C8]
loc_90A6C:
        test ecx, ecx
        je short loc_90ABD
        mov bl, byte [edx]
        sub bl, byte [byte_D42C0]
        and ebx, 0FFh
        cmp ebx, edi
        jge short loc_90AB6
        mov esi, dword [dword_D42D0]
        test esi, esi
        je short loc_90A97
        mov bl, byte [esi+ebx]
        and ebx, 0FFh
        jmp short loc_90AB4
loc_90A97:
        test ebp, ebp
        je short loc_90AA3
        mov esi, ebp
        movzx esi, byte [esi+ebx]
        jmp short loc_90AAA
loc_90AA3:
        movzx esi, byte [byte_D42C2]
loc_90AAA:
        xor ebx, ebx
        mov bl, byte [byte_D42C4]
        add ebx, esi
loc_90AB4:
        add eax, ebx
loc_90AB6:
        inc edx
        dec ecx
        cmp byte [edx], 0
        jne short loc_90A6C
loc_90ABD:
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
