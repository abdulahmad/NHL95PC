; Reading the mouse.
bits 32
%include "hockey.inc"
section s_B2D38 progbits alloc exec nowrite align=1
extern mouseminx, mouseminy, mousemaxx, mousemaxy, dword_D2FFC, dword_D3000, dword_D301C, dword_D3028
extern dword_D3038, dword_D303C, dword_D3044, dword_D3048, mousebtns, mousepollfn, mousex, mousey
extern off_D306C, off_D3070, off_D3074, sub_B3454, word_D3004, word_D3006, word_D3008
global sub_B2D38, loc_B2D57, loc_B2D5E, sub_B2D74, loc_B2D92, sub_B2D94, loc_B2DB2, MouseSetPos
global MouseRead, sub_B2DEF, SetViewRect, sub_B2E43, loc_B2E94, loc_B2EA5, loc_B2EB3, loc_B2EC2
global loc_B2EEA, sub_B2EF6, sub_B2EFD, sub_B2F04, sub_B2F22, loc_B2F7C, loc_B3006
sub_B2D38:
        LD xor, eax, eax
        dec dword [dword_D3000]
        jne short loc_B2D57
        cmp dword [dword_D3028], byte 1
        jb short loc_B2D57
        ja short loc_B2D5E
        mov eax, 3
        int 33h
        movsx eax, bx
loc_B2D57:
        inc dword [dword_D3000]
        ret
loc_B2D5E:
        mov eax, 3
        int 33h
        and eax, byte 1
        and ebx, byte 2
        LD or, eax, ebx
        inc dword [dword_D3000]
        ret
sub_B2D74:
        push ebp
        LD mov, ebp, esp
        cmp dword [dword_D3028], byte 0
        je short loc_B2D92
        mov ax, 1Ah
        mov bx, word [byte ebp+08h]
        mov cx, word [byte ebp+0Ch]
        mov dx, word [byte ebp+010h]
        int 33h
loc_B2D92:
        leave
        ret
sub_B2D94:
        push ebp
        LD mov, ebp, esp
        cmp dword [dword_D3028], byte 0
        je short loc_B2DB2
        mov ax, 1Ah
        mov bx, word [byte ebp+08h]
        mov cx, word [byte ebp+0Ch]
        mov dx, 40h
        int 33h
loc_B2DB2:
        leave
        ret
MouseSetPos:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov edx, dword [byte ebp+0Ch]
        mov dword [mousex], eax
        mov dword [mousey], edx
        leave
        ret
MouseRead:
        push ebp
        LD mov, ebp, esp
        call sub_B2E43
        db 08Bh,05Dh,08h                        ; insn: mov ebx,[ebp+8]
        db 089h,03h                             ; insn: mov [ebx],eax
        mov ecx, dword [mousex]
        mov ebx, dword [byte ebp+0Ch]
        mov dword [ebx], ecx
        mov edx, dword [mousey]
        mov ebx, dword [byte ebp+010h]
        mov dword [ebx], edx
        leave
        ret
sub_B2DEF:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov edx, dword [byte ebp+0Ch]
        mov dword [mouseminx], eax
        mov dword [mousemaxx], edx
        leave
        ret
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov edx, dword [byte ebp+0Ch]
        mov dword [mouseminy], eax
        mov dword [mousemaxy], edx
        leave
        ret
SetViewRect:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov edx, dword [byte ebp+0Ch]
        mov ebx, dword [byte ebp+010h]
        mov ecx, dword [byte ebp+014h]
        mov dword [mouseminx], eax
        mov dword [mouseminy], edx
        mov dword [mousemaxx], ebx
        mov dword [mousemaxy], ecx
        leave
        ret
sub_B2E43:
        dec dword [dword_D3000]
        jne near loc_B2EEA
        mov eax, dword [dword_D3028]
        LD or, eax, eax
        je near loc_B2EEA
        mov eax, 0Bh
        int 33h
        movsx ecx, cx
        movsx edx, dx
        mov eax, dword [mousex]
        mov ebx, dword [dword_D2FFC]
        LD add, ebx, ebx
        LD adc, eax, eax
        LD add, ecx, eax
        sar ecx, 1
        rcr ebx, 1
        add edx, dword [mousey]
        cmp ecx, dword [mouseminx]
        jge short loc_B2E94
        mov ecx, dword [mouseminx]
        LD xor, ebx, ebx
loc_B2E94:
        cmp ecx, dword [mousemaxx]
        jl short loc_B2EA5
        mov ecx, dword [mousemaxx]
        dec ecx
        LD xor, ebx, ebx
loc_B2EA5:
        cmp edx, dword [mouseminy]
        jge short loc_B2EB3
        mov edx, dword [mouseminy]
loc_B2EB3:
        cmp edx, dword [mousemaxy]
        jl short loc_B2EC2
        mov edx, dword [mousemaxy]
        dec edx
loc_B2EC2:
        mov dword [dword_D2FFC], ebx
        mov dword [mousex], ecx
        mov dword [mousey], edx
        inc dword [dword_D3000]
        call sub_B2D38
        dec dword [dword_D3000]
        mov dword [mousebtns], eax
loc_B2EEA:
        mov eax, dword [mousebtns]
        inc dword [dword_D3000]
        ret
sub_B2EF6:
        inc dword [dword_D3038]
        ret
sub_B2EFD:
        dec dword [dword_D3038]
        ret
sub_B2F04:
        pusha
        mov ax, 1Ah
        mov bx, word [word_D3004]
        mov cx, word [word_D3006]
        mov dx, word [word_D3008]
        int 33h
        popa
        ret
sub_B2F22:
        mov dword [dword_D3028], 0
        mov dword [dword_D3038], 0
        mov dword [dword_D303C], 0
        LD xor, eax, eax
        int 33h
        LD or, ax, ax
        je near loc_B3006
        inc dword [dword_D3028]
        cmp dword [dword_D301C], byte 0
        je short loc_B2F7C
        mov dword [dword_D303C], 2
        mov eax, 3
        int 33h
        LD or, ax, ax
        jne short loc_B2F7C
        mov dword [dword_D3028], 2
loc_B2F7C:
        push dword [dword_D3048]
        push dword [dword_D3044]
        push byte 0
        push byte 0
        call SetViewRect
        mov eax, dword [dword_D3048]
        shr eax, 2
        mov dword [mousex], eax
        mov eax, dword [dword_D3044]
        shr eax, 2
        mov dword [mousey], eax
        mov ax, 1Bh
        int 33h
        mov word [word_D3004], bx
        mov word [word_D3006], cx
        mov word [word_D3008], dx
        push byte 40h
        push byte 20h
        push byte 20h
        call sub_B2D74
        mov dword [off_D306C], sub_B2EFD
        mov dword [off_D3070], sub_B2EFD
        mov dword [off_D3074], sub_B2EF6
        mov dword [mousepollfn], sub_B2E43
        push sub_B2F04
        call sub_B3454
        add esp, byte 20h
loc_B3006:
        mov eax, dword [dword_D3028]
        ret
