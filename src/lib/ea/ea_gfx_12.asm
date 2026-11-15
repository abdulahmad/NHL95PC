; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_93170 progbits alloc exec nowrite align=1
extern byte_D42E4, dword_D30C8, dword_D43E4, DrawArtOpaque, sub_92CD0, sub_B3ABC, sub_B6D47, vsprintf_
global sub_93170, sub_931D0, loc_931E4, loc_931F6, loc_931FB, DrawArtMasked, loc_9321D, sub_93240
sub_93170:
        sub esp, 104h
        lea eax, [dword esp+0114h]
        mov dword [dword esp+0100h], eax
        lea ebx, [dword esp+0100h]
        mov edx, dword [dword esp+0110h]
        mov eax, esp
        call vsprintf_
        mov edx, dword [dword esp+010Ch]
        push edx
        mov ebx, dword [dword esp+010Ch]
        push ebx
        lea eax, [byte esp+08h]
        push eax
        call sub_92CD0
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [dword esp+0100h], ecx
        add esp, 104h
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
sub_931D0:
        mov ebx, dword [byte esp+08h]
        mov ecx, dword [byte esp+0Ch]
        mov edx, dword [byte esp+04h]
        mov eax, ebx
        test ecx, ecx
        je short loc_931FB
        add ecx, ebx
loc_931E4:
        xor ebx, ebx
        mov bl, byte [edx]
        mov bl, byte [dword ebx+byte_D42E4]
        inc edx
        cmp bl, 0FFh
        je short loc_931F6
        mov byte [eax], bl
loc_931F6:
        inc eax
        cmp eax, ecx
        jb short loc_931E4
loc_931FB:
        ret
DrawArtMasked:
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        cmp dword [dword_D30C8], byte 0
        jne short loc_9321D
        push eax
        push ebx
        push edx
        call sub_B6D47
        add esp, byte 0Ch
        ret
loc_9321D:
        mov dword [dword_D43E4], sub_931D0
        push eax
        push ebx
        push edx
        call DrawArtOpaque
        add esp, byte 0Ch
        mov dword [dword_D43E4], sub_B3ABC
        ret
        db 08Dh,040h,00h
sub_93240:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call DrawArtMasked
        add esp, byte 0Ch
        ret
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+08h]
        sar eax, 10h
        mov ebx, dword [byte esp+0Ch]
        sub ebx, eax
        push ebx
        mov eax, dword [byte edx+06h]
        sar eax, 10h
        mov ebx, dword [byte esp+0Ch]
        sub ebx, eax
        push ebx
        push edx
        call DrawArtMasked
        add esp, byte 0Ch
        ret
