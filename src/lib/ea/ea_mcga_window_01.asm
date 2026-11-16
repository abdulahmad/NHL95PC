; Blitting into an MCGA window.
bits 32
%include "hockey.inc"
section s_9A7A0 progbits alloc exec nowrite align=1
extern _os_handle, str_MCGAWINDOW, str_WindowdefOUTOFMEMORY, str_WindowdefBADBLOCK, str_WindowdefadrOUTOFROW, FatalError, AllocMemHandleLocked, FillRowTable
extern ZeroMem
global CreateMcgaWindow
CreateMcgaWindow:
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
        call AllocMemHandleLocked
        add esp, byte 0Ch
        mov ebp, eax
        test eax, eax
        jne short .1
        push str_WindowdefOUTOFMEMORY
        call FatalError
        add esp, byte 4
.1:
        mov esi, dword [byte ebp+00h]
        test esi, esi
        jne short .2
        push str_WindowdefBADBLOCK
        call FatalError
        add esp, byte 4
.2:
        lea eax, [byte esi+030h]
        push eax
        call _os_handle
        mov edi, eax
        add esp, byte 4
        push byte 40h
        push esi
        call ZeroMem
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
        call FillRowTable
        mov dword [byte esi+028h], eax
        test eax, eax
        jne short .3
        mov esi, dword [byte esp+018h]
        push esi
        mov edi, dword [byte esp+018h]
        push edi
        push str_WindowdefadrOUTOFROW
        call FatalError
        add esp, byte 0Ch
.3:
        mov eax, ebp
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h
