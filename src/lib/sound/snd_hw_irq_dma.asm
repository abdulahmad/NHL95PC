; IRQ and DMA setup for the sound cards.
bits 32
%include "hockey.inc"
section s_A9C9C progbits alloc exec nowrite align=1
extern __GETDS, unk_A9C80, unk_A9C81, unk_A9C83, unk_A9C85, unk_A9C86, unk_A9C88, unk_A9C89
extern unk_A9C8A, unk_A9C8E, unk_A9C8F, unk_A9C90, unk_A9C91, unk_A9C92, unk_A9C96, unk_A9C98
global sub_A9C9C, loc_A9CAC, loc_A9CD2, loc_A9CDD, loc_A9CDF, loc_A9CE3, loc_A9CE5, loc_A9CFD
global loc_A9CFF, loc_A9D05, loc_A9D07, loc_A9D09, loc_A9D11, loc_A9D13, loc_A9D19, loc_A9D1B
global sub_A9D1D, loc_A9D30, loc_A9D4B, sub_A9D4C, sub_A9D54, loc_A9D61, loc_A9D63, loc_A9D7D
global loc_A9D80, loc_A9D82, loc_A9D8E, loc_A9D90, loc_A9D91, loc_A9DA2, loc_A9DA5, loc_A9DA7
global loc_A9DB3, loc_A9DB5, loc_A9DB6, loc_A9DC5, loc_A9DC8, loc_A9DCA, loc_A9DD6, loc_A9DD8
global loc_A9DD9, loc_A9DDF, loc_A9DE1, loc_A9DE5, loc_A9DE7, sub_A9DEB, loc_A9DFA, loc_A9DFD
global loc_A9DFF, loc_A9E0B, loc_A9E0D, loc_A9E0E, sub_A9E0F, loc_A9E1E, loc_A9E21, loc_A9E23
global loc_A9E30, loc_A9E32, loc_A9E33, sub_A9E34, loc_A9E42, loc_A9E44, loc_A9E4D, loc_A9E4F
global sub_A9E55, loc_A9E62, loc_A9E64, loc_A9E73, loc_A9E75, loc_A9E7C, loc_A9E7E, loc_A9E80
global loc_A9E8D, loc_A9E8F, loc_A9E91, loc_A9E9E, loc_A9EA0, loc_A9EA2, loc_A9EAD, loc_A9EAF
global loc_A9EB6, loc_A9EB8, loc_A9EBA, loc_A9EC7, loc_A9EC9, loc_A9ECB, loc_A9ED8, loc_A9EDA
global loc_A9EDC, loc_A9EE7, loc_A9EF7, loc_A9EFA, loc_A9EFC, loc_A9F09, loc_A9F0B, loc_A9F0C
global loc_A9F15, sub_A9F1A, loc_A9F28, loc_A9F2F, loc_A9F31, loc_A9F33, loc_A9F6C, loc_A9F7F
global loc_A9F90, sub_A9F93, loc_A9FCD, loc_A9FF9, loc_AA001, loc_AA010, loc_AA05B, loc_AA05D
global loc_AA068, loc_AA06A, loc_AA06E, loc_AA070, loc_AA081, loc_AA083, loc_AA088, loc_AA08A
global loc_AA0A0, loc_AA0A2, loc_AA0B8, loc_AA0BA, loc_AA0BD, loc_AA0BF, loc_AA0C4, loc_AA0C6
global loc_AA0CF, loc_AA0D1, loc_AA0E8, loc_AA0EF, loc_AA0F1, loc_AA0F3, loc_AA10B, loc_AA119
global loc_AA120, loc_AA122, loc_AA124, loc_AA141, loc_AA148, sub_AA14D, loc_AA163, loc_AA165
global loc_AA172, loc_AA174, loc_AA1A8, loc_AA1B0, sub_AA1B2, loc_AA1C1, loc_AA1C3, loc_AA1C8
global loc_AA1CA, sub_AA1D9, loc_AA1EB, loc_AA1ED, loc_AA1F9, loc_AA1FC, loc_AA1FE
sub_A9C9C:
        pushf
        cli
        push es
        mov byte [unk_A9C91], al
        add al, 8
        cmp al, 0Fh
        jbe short loc_A9CAC
        add al, 60h
loc_A9CAC:
        mov ah, 35h
        int 21h
        o16 mov word [unk_A9C96], es
        mov dword [unk_A9C92], ebx
        pop es
        push ds
        mov ax, cs
        mov ds, ax
        mov al, byte [unk_A9C91]
        add al, 8
        cmp al, 0Fh
        jbe short loc_A9CD2
        add al, 60h
loc_A9CD2:
        mov ah, 25h
        int 21h
        pop ds
        mov al, 20h
        out 20h, al
        jmp short loc_A9CDD
loc_A9CDD:
        jmp short loc_A9CDF
loc_A9CDF:
        out 0A0h, al
        jmp short loc_A9CE3
loc_A9CE3:
        jmp short loc_A9CE5
loc_A9CE5:
        mov cl, byte [unk_A9C91]
        mov ah, 1
        cmp cl, 8
        jb short loc_A9D09
        sub cl, 8
        shl ah, cl
        not ah
        in al, 21h
        jmp short loc_A9CFD
loc_A9CFD:
        jmp short loc_A9CFF
loc_A9CFF:
        LD and, al, ah
        out 21h, al
        jmp short loc_A9D05
loc_A9D05:
        jmp short loc_A9D07
loc_A9D07:
        popf
        ret
loc_A9D09:
        shl ah, cl
        not ah
        in al, 21h
        jmp short loc_A9D11
loc_A9D11:
        jmp short loc_A9D13
loc_A9D13:
        LD and, al, ah
        out 21h, al
        jmp short loc_A9D19
loc_A9D19:
        jmp short loc_A9D1B
loc_A9D1B:
        popf
        ret
sub_A9D1D:
        mov al, byte [unk_A9C91]
        LD or, al, al
        je short loc_A9D4B
        pushf
        cli
        add al, 8
        cmp al, 0Fh
        jbe short loc_A9D30
        add al, 60h
loc_A9D30:
        push ds
        mov edx, dword [unk_A9C92]
        o16 mov ds, word [unk_A9C96]
        mov ah, 25h
        int 21h
        pop ds
        LD xor, al, al
        mov byte [unk_A9C91], al
        popf
loc_A9D4B:
        ret
sub_A9D4C:
        pushf
        pusha
        push ds
        call __GETDS
sub_A9D54:
        movzx edx, word [unk_A9C86]
        add edx, byte 0Eh
        in al, dx
        jmp short loc_A9D61
loc_A9D61:
        jmp short loc_A9D63
loc_A9D63:
        cmp byte [unk_A9C8E], 1
        je short loc_A9DD9
        mov ah, 14h
        movzx edx, word [unk_A9C86]
        add edx, byte 0Ch
        mov ecx, 3E8h
loc_A9D7D:
        in al, dx
        jmp short loc_A9D80
loc_A9D80:
        jmp short loc_A9D82
loc_A9D82:
        and al, 80h
        loopne loc_A9D7D
        stc
        jne short loc_A9D91
        LD mov, al, ah
        out dx, al
        jmp short loc_A9D8E
loc_A9D8E:
        jmp short loc_A9D90
loc_A9D90:
        clc
loc_A9D91:
        mov ah, 0FFh
        movzx edx, word [unk_A9C86]
        add edx, byte 0Ch
        mov ecx, 3E8h
loc_A9DA2:
        in al, dx
        jmp short loc_A9DA5
loc_A9DA5:
        jmp short loc_A9DA7
loc_A9DA7:
        and al, 80h
        loopne loc_A9DA2
        stc
        jne short loc_A9DB6
        LD mov, al, ah
        out dx, al
        jmp short loc_A9DB3
loc_A9DB3:
        jmp short loc_A9DB5
loc_A9DB5:
        clc
loc_A9DB6:
        movzx edx, word [unk_A9C86]
        add edx, byte 0Ch
        mov ecx, 3E8h
loc_A9DC5:
        in al, dx
        jmp short loc_A9DC8
loc_A9DC8:
        jmp short loc_A9DCA
loc_A9DCA:
        and al, 80h
        loopne loc_A9DC5
        stc
        jne short loc_A9DD9
        LD mov, al, ah
        out dx, al
        jmp short loc_A9DD6
loc_A9DD6:
        jmp short loc_A9DD8
loc_A9DD8:
        clc
loc_A9DD9:
        mov al, 20h
        out 0A0h, al
        jmp short loc_A9DDF
loc_A9DDF:
        jmp short loc_A9DE1
loc_A9DE1:
        out 20h, al
        jmp short loc_A9DE5
loc_A9DE5:
        jmp short loc_A9DE7
loc_A9DE7:
        pop ds
        popa
        popf
        iret
sub_A9DEB:
        movzx edx, word [unk_A9C86]
        add edx, byte 0Ch
        mov ecx, 3E8h
loc_A9DFA:
        in al, dx
        jmp short loc_A9DFD
loc_A9DFD:
        jmp short loc_A9DFF
loc_A9DFF:
        and al, 80h
        loopne loc_A9DFA
        stc
        jne short loc_A9E0E
        LD mov, al, ah
        out dx, al
        jmp short loc_A9E0B
loc_A9E0B:
        jmp short loc_A9E0D
loc_A9E0D:
        clc
loc_A9E0E:
        ret
sub_A9E0F:
        movzx edx, word [unk_A9C86]
        add edx, byte 0Eh
        mov ecx, 3E8h
loc_A9E1E:
        in al, dx
        jmp short loc_A9E21
loc_A9E21:
        jmp short loc_A9E23
loc_A9E23:
        and al, 80h
        loope loc_A9E1E
        stc
        je short loc_A9E33
        sub edx, byte 4
        in al, dx
        jmp short loc_A9E30
loc_A9E30:
        jmp short loc_A9E32
loc_A9E32:
        clc
loc_A9E33:
        ret
sub_A9E34:
        call sub_AA14D
        mov al, byte [unk_A9C8F]
        out 21h, al
        jmp short loc_A9E42
loc_A9E42:
        jmp short loc_A9E44
loc_A9E44:
        mov al, byte [unk_A9C90]
        out 0A1h, al
        jmp short loc_A9E4D
loc_A9E4D:
        jmp short loc_A9E4F
loc_A9E4F:
        call sub_A9E55
        ret
sub_A9E55:
        movzx edx, word [unk_A9C86]
        add edx, byte 0Eh
        in al, dx
        jmp short loc_A9E62
loc_A9E62:
        jmp short loc_A9E64
loc_A9E64:
        movzx edx, word [unk_A9C86]
        add edx, byte 6
        mov al, 1
        out dx, al
        jmp short loc_A9E73
loc_A9E73:
        jmp short loc_A9E75
loc_A9E75:
        pushf
        push ecx
        mov ecx, 14h
loc_A9E7C:
        jmp short loc_A9E7E
loc_A9E7E:
        jmp short loc_A9E80
loc_A9E80:
        push eax
        pop eax
        loop loc_A9E7C
        pop ecx
        popf
        pushf
        push ecx
        mov ecx, 14h
loc_A9E8D:
        jmp short loc_A9E8F
loc_A9E8F:
        jmp short loc_A9E91
loc_A9E91:
        push eax
        pop eax
        loop loc_A9E8D
        pop ecx
        popf
        pushf
        push ecx
        mov ecx, 14h
loc_A9E9E:
        jmp short loc_A9EA0
loc_A9EA0:
        jmp short loc_A9EA2
loc_A9EA2:
        push eax
        pop eax
        loop loc_A9E9E
        pop ecx
        popf
        dec al
        out dx, al
        jmp short loc_A9EAD
loc_A9EAD:
        jmp short loc_A9EAF
loc_A9EAF:
        pushf
        push ecx
        mov ecx, 14h
loc_A9EB6:
        jmp short loc_A9EB8
loc_A9EB8:
        jmp short loc_A9EBA
loc_A9EBA:
        push eax
        pop eax
        loop loc_A9EB6
        pop ecx
        popf
        pushf
        push ecx
        mov ecx, 14h
loc_A9EC7:
        jmp short loc_A9EC9
loc_A9EC9:
        jmp short loc_A9ECB
loc_A9ECB:
        push eax
        pop eax
        loop loc_A9EC7
        pop ecx
        popf
        pushf
        push ecx
        mov ecx, 14h
loc_A9ED8:
        jmp short loc_A9EDA
loc_A9EDA:
        jmp short loc_A9EDC
loc_A9EDC:
        push eax
        pop eax
        loop loc_A9ED8
        pop ecx
        popf
        mov ecx, 3E8h
loc_A9EE7:
        push ecx
        movzx edx, word [unk_A9C86]
        add edx, byte 0Eh
        mov ecx, 3E8h
loc_A9EF7:
        in al, dx
        jmp short loc_A9EFA
loc_A9EFA:
        jmp short loc_A9EFC
loc_A9EFC:
        and al, 80h
        loope loc_A9EF7
        stc
        je short loc_A9F0C
        sub edx, byte 4
        in al, dx
        jmp short loc_A9F09
loc_A9F09:
        jmp short loc_A9F0B
loc_A9F0B:
        clc
loc_A9F0C:
        pop ecx
        cmp al, 0AAh
        loopne loc_A9EE7
        stc
        jne short loc_A9F15
        clc
loc_A9F15:
        LD sbb, eax, eax
        rol eax, 1
        ret
sub_A9F1A:
        push eax
        push ebx
        mov ah, 0E1h
        call sub_A9DEB
        mov ecx, 4E20h
loc_A9F28:
        pushf
        push ecx
        mov ecx, 14h
loc_A9F2F:
        jmp short loc_A9F31
loc_A9F31:
        jmp short loc_A9F33
loc_A9F33:
        push eax
        pop eax
        loop loc_A9F2F
        pop ecx
        popf
        loop loc_A9F28
        LD xor, eax, eax
        call sub_A9E0F
        LD mov, ah, al
        call sub_A9E0F
        LD mov, ebx, eax
        cmp eax, 201h
        jb short loc_A9F7F
        cmp eax, 400h
        jb short loc_A9F6C
        mov eax, 5622h
        mov dword [unk_A9C8A], eax
        mov byte [unk_A9C8E], 0
        jmp short loc_A9F90
loc_A9F6C:
        mov eax, 5622h
        mov dword [unk_A9C8A], eax
        mov byte [unk_A9C8E], 1
        jmp short loc_A9F90
loc_A9F7F:
        mov eax, 2B11h
        mov dword [unk_A9C8A], eax
        mov byte [unk_A9C8E], 0
loc_A9F90:
        pop ebx
        pop eax
        ret
sub_A9F93:
        push ebp
        LD mov, ebp, esp
        in al, 21h
        mov byte [unk_A9C8F], al
        in al, 0A1h
        mov byte [unk_A9C90], al
        LD xor, al, al
        mov byte [unk_A9C91], al
        mov eax, dword [byte ebp+08h]
        mov word [unk_A9C86], ax
        mov eax, dword [byte ebp+0Ch]
        mov byte [unk_A9C88], al
        mov eax, dword [byte ebp+010h]
        mov byte [unk_A9C89], al
        call sub_A9E55
        jae short loc_A9FCD
        leave
        ret
loc_A9FCD:
        call sub_A9F1A
        mov ebx, dword [unk_A9C8A]
        LD or, ebx, ebx
        je short loc_A9FF9
        LD xor, edx, edx
        mov eax, 0F424000h
        div ebx
        neg eax
        LD mov, ebx, eax
        mov ah, 40h
        call sub_A9DEB
        jb short loc_A9FF9
        LD mov, ah, bh
        call sub_A9DEB
loc_A9FF9:
        LD sbb, eax, eax
        rol eax, 1
        jae short loc_AA001
        leave
        ret
loc_AA001:
        mov ah, 0D1h
        call sub_A9DEB
        LD sbb, eax, eax
        rol eax, 1
        jae short loc_AA010
        leave
        ret
loc_AA010:
        mov eax, dword [byte ebp+018h]
        mov word [unk_A9C83], ax
        mov eax, dword [byte ebp+014h]
        mov word [unk_A9C81], ax
        shr eax, 10h
        mov byte [unk_A9C80], al
        mov al, byte [unk_A9C85]
        LD or, al, al
        jne near loc_AA148
        mov al, 1
        mov byte [unk_A9C85], al
        mov al, byte [unk_A9C88]
        mov edx, sub_A9D4C
        call sub_A9C9C
        cli
        LD xor, edx, edx
        mov al, byte [unk_A9C89]
        or al, 4
        out 0Ah, al
        jmp short loc_AA05B
loc_AA05B:
        jmp short loc_AA05D
loc_AA05D:
        mov al, byte [unk_A9C89]
        or al, 58h
        out 0Bh, al
        jmp short loc_AA068
loc_AA068:
        jmp short loc_AA06A
loc_AA06A:
        out 0Ch, al
        jmp short loc_AA06E
loc_AA06E:
        jmp short loc_AA070
loc_AA070:
        mov dl, byte [unk_A9C89]
        shl dl, 1
        mov ax, word [unk_A9C81]
        out dx, al
        jmp short loc_AA081
loc_AA081:
        jmp short loc_AA083
loc_AA083:
        LD mov, al, ah
        out dx, al
        jmp short loc_AA088
loc_AA088:
        jmp short loc_AA08A
loc_AA08A:
        LD xor, ebx, ebx
        mov bl, byte [unk_A9C89]
        mov dl, byte [dword ebx+unk_A9C98]
        mov al, byte [unk_A9C80]
        out dx, al
        jmp short loc_AA0A0
loc_AA0A0:
        jmp short loc_AA0A2
loc_AA0A2:
        mov dl, byte [unk_A9C89]
        shl dl, 1
        inc dl
        mov ax, word [unk_A9C83]
        dec ax
        out 0Ch, al
        jmp short loc_AA0B8
loc_AA0B8:
        jmp short loc_AA0BA
loc_AA0BA:
        out dx, al
        jmp short loc_AA0BD
loc_AA0BD:
        jmp short loc_AA0BF
loc_AA0BF:
        LD mov, al, ah
        out dx, al
        jmp short loc_AA0C4
loc_AA0C4:
        jmp short loc_AA0C6
loc_AA0C6:
        mov al, byte [unk_A9C89]
        out 0Ah, al
        jmp short loc_AA0CF
loc_AA0CF:
        jmp short loc_AA0D1
loc_AA0D1:
        cmp byte [unk_A9C8E], 1
        je short loc_AA10B
        mov ah, 14h
        call sub_A9DEB
        jb short loc_AA141
        mov ecx, 4E20h
loc_AA0E8:
        pushf
        push ecx
        mov ecx, 14h
loc_AA0EF:
        jmp short loc_AA0F1
loc_AA0F1:
        jmp short loc_AA0F3
loc_AA0F3:
        push eax
        pop eax
        loop loc_AA0EF
        pop ecx
        popf
        loop loc_AA0E8
        mov ah, 0FFh
        call sub_A9DEB
        jb short loc_AA141
        call sub_A9DEB
        jmp short loc_AA141
loc_AA10B:
        mov ah, 48h
        call sub_A9DEB
        jb short loc_AA141
        mov ecx, 4E20h
loc_AA119:
        pushf
        push ecx
        mov ecx, 14h
loc_AA120:
        jmp short loc_AA122
loc_AA122:
        jmp short loc_AA124
loc_AA124:
        push eax
        pop eax
        loop loc_AA120
        pop ecx
        popf
        loop loc_AA119
        mov ah, 0FFh
        call sub_A9DEB
        jb short loc_AA141
        call sub_A9DEB
        mov ah, 90h
        call sub_A9DEB
loc_AA141:
        LD sbb, eax, eax
        rol eax, 1
        sti
        leave
        ret
loc_AA148:
        LD xor, eax, eax
        clc
        leave
        ret
sub_AA14D:
        cmp byte [unk_A9C85], 0
        clc
        je short loc_AA1B0
        cli
        mov al, byte [unk_A9C89]
        or al, 4
        out 0Ah, al
        jmp short loc_AA163
loc_AA163:
        jmp short loc_AA165
loc_AA165:
        movzx edx, word [unk_A9C86]
        add edx, byte 0Eh
        in al, dx
        jmp short loc_AA172
loc_AA172:
        jmp short loc_AA174
loc_AA174:
        LD xor, al, al
        mov byte [unk_A9C85], al
        mov al, byte [unk_A9C91]
        LD or, al, al
        je short loc_AA1B0
        call sub_A9D1D
        mov cl, byte [unk_A9C88]
        cmp cl, 0FFh
        je short loc_AA1B0
        mov ah, 1
        cmp cl, 8
        jb short loc_AA1A8
        sub cl, 8
        shl ah, cl
        in al, 0A1h
        LD or, al, ah
        out 0A1h, al
        jmp short loc_AA1B0
loc_AA1A8:
        shl ah, cl
        in al, 21h
        LD or, al, ah
        out 21h, al
loc_AA1B0:
        sti
        ret
sub_AA1B2:
        LD xor, eax, eax
        movzx edx, byte [unk_A9C89]
        shl edx, 1
        inc edx
        in al, dx
        jmp short loc_AA1C1
loc_AA1C1:
        jmp short loc_AA1C3
loc_AA1C3:
        LD mov, ah, al
        in al, dx
        jmp short loc_AA1C8
loc_AA1C8:
        jmp short loc_AA1CA
loc_AA1CA:
        db 086h,0C4h                            ; insn: xchg al,ah
        LD mov, ebx, eax
        movzx eax, word [unk_A9C83]
        dec eax
        LD sub, eax, ebx
        ret
sub_AA1D9:
        push ebp
        LD mov, ebp, esp
        movzx edx, word [unk_A9C86]
        add edx, byte 4
        mov al, 0Eh
        out dx, al
        jmp short loc_AA1EB
loc_AA1EB:
        jmp short loc_AA1ED
loc_AA1ED:
        inc edx
        LD xor, eax, eax
        mov ebx, dword [byte ebp+08h]
        LD or, ebx, ebx
        jne short loc_AA1F9
        mov al, 20h
loc_AA1F9:
        out dx, al
        jmp short loc_AA1FC
loc_AA1FC:
        jmp short loc_AA1FE
loc_AA1FE:
        leave
        ret
