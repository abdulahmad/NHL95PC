; Blitting into an MCGA window.
bits 32
%include "hockey.inc"
section s_9A7A0 progbits alloc exec nowrite align=1
extern _os_handle, str_MCGAWINDOW, str_WindowdefOUTOFMEMORY, str_WindowdefBADBLOCK, str_WindowdefadrOUTOFROW, FatalError, sub_8CC70, sub_98D20
extern sub_B3FC2
global sub_9A7A0, loc_9A7DB, loc_9A7EF, loc_9A868
sub_9A7A0:
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov eax, dword [byte esp+014h]
        mov dword [esp], eax
        imul eax, dword [byte esp+018h]
        add eax, byte 40h
        mov ebx, dword [byte esp+01Ch]
        push ebx
        push eax
        push str_MCGAWINDOW
        call sub_8CC70
        add esp, byte 0Ch
        mov ebp, eax
        test eax, eax
        jne short loc_9A7DB
        push str_WindowdefOUTOFMEMORY
        call FatalError
        add esp, byte 4
loc_9A7DB:
        mov esi, dword [byte ebp+00h]
        test esi, esi
        jne short loc_9A7EF
        push str_WindowdefBADBLOCK
        call FatalError
        add esp, byte 4
loc_9A7EF:
        lea eax, [byte esi+030h]
        push eax
        call _os_handle
        mov edi, eax
        add esp, byte 4
        push byte 40h
        push esi
        call sub_B3FC2
        add esp, byte 8
        mov eax, dword [esp]
        mov word [byte edi+04h], ax
        mov eax, dword [byte esp+018h]
        mov word [byte edi+06h], ax
        mov dword [edi], 0
        or byte [edi], 1
        mov eax, dword [esp]
        mov dword [esi], eax
        mov dword [byte esi+020h], eax
        mov dword [byte esi+010h], eax
        mov dword [byte esi+01Ch], eax
        mov eax, dword [byte esp+018h]
        mov dword [byte esi+04h], eax
        mov dword [byte esi+014h], eax
        mov dword [byte esi+02Ch], edi
        mov ebx, eax
        mov edx, dword [esp]
        mov eax, 10h
        call sub_98D20
        mov dword [byte esi+028h], eax
        test eax, eax
        jne short loc_9A868
        mov esi, dword [byte esp+018h]
        push esi
        mov edi, dword [byte esp+018h]
        push edi
        push str_WindowdefadrOUTOFROW
        call FatalError
        add esp, byte 0Ch
loc_9A868:
        mov eax, ebp
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h
