; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_930A7 progbits alloc exec nowrite align=1
extern __set_errno_dos_, fgetc_, sub_9BA18, ungetc_
global mkdir_, loc_930C2, cget_file_, loc_930E8, loc_930F2, loc_93103, loc_9310E, uncget_file_
global vfscanf_, fscanf_
mkdir_:
        push edx
        mov edx, eax
        mov ah, 39h
        int 21h
        rcl eax, 1
        ror eax, 1
        test eax, eax
        jge short loc_930C2
        and eax, 0FFFFh
        call __set_errno_dos_
        pop edx
        ret
loc_930C2:
        xor eax, eax
        pop edx
        ret
cget_file_:
        push ebx
        push ecx
        push edx
        mov edx, eax
        mov eax, dword [byte eax+08h]
        cmp dword [byte eax+04h], byte 0
        jle short loc_930E8
        test byte [byte eax+0Ch], 4
        jne short loc_930E8
        mov ebx, dword [eax]
        mov cl, byte [ebx]
        cmp cl, 0Dh
        je short loc_930E8
        cmp cl, 1Ah
        jne short loc_930F2
loc_930E8:
        mov eax, dword [byte edx+08h]
        call fgetc_
        jmp short loc_93103
loc_930F2:
        dec dword [byte eax+04h]
        mov eax, dword [byte edx+08h]
        mov ebx, dword [eax]
        lea ecx, [byte ebx+01h]
        mov dword [eax], ecx
        xor eax, eax
        mov al, byte [ebx]
loc_93103:
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        jne short loc_9310E
        or byte [byte edx+010h], 2
loc_9310E:
        mov eax, ebx
        pop edx
        pop ecx
        pop ebx
        ret
uncget_file_:
        mov edx, dword [byte edx+08h]
        jmp near ungetc_
vfscanf_:
        push ecx
        push esi
        sub esp, byte 14h
        mov ecx, cget_file_
        mov esi, uncget_file_
        mov dword [byte esp+08h], eax
        mov eax, esp
        mov dword [esp], ecx
        mov dword [byte esp+04h], esi
        call sub_9BA18
        add esp, byte 14h
        pop esi
        pop ecx
        ret
fscanf_:
        push ebx
        push edx
        sub esp, byte 4
        lea ebx, [byte esp+018h]
        mov eax, dword [byte esp+010h]
        mov edx, dword [byte esp+014h]
        mov dword [esp], ebx
        mov ebx, esp
        call vfscanf_
        add esp, byte 4
        pop edx
        pop ebx
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
