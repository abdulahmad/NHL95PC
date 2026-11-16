; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_96185 progbits alloc exec nowrite align=1
extern __delay_, __fprtf_, __IOMode_, __set_errno_, __set_errno_dos_, __sys_fini_387_emulator, __sys_init_387_emulator, fputc_
extern fputs_, strerror_, __STKOVF, ErrnoPtr, CMainHook, str_ColonSpace, PerrorSeparator
global fprintf_, strupr_, __CHP, j___sys_init_387_emulator, j___sys_fini_387_emulator, strlwr_, j___delay_, perror_
global write_
;-----------------------------------------------------------------------------
; fprintf_                                                      96185  library
; Run-time library fprintf: formats to a stream
;-----------------------------------------------------------------------------
fprintf_:
        push ebx
        push edx
        sub esp, byte 4
        lea ebx, [byte esp+018h]
        mov eax, dword [byte esp+010h]
        mov edx, dword [byte esp+014h]
        mov dword [esp], ebx
        mov ebx, esp
        call __fprtf_
        add esp, byte 4
        pop edx
        pop ebx
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; strupr_                                                       961B0  library
; Run-time library strupr: makes a string upper case
;-----------------------------------------------------------------------------
strupr_:
        push ebx
        push edx
        mov ebx, eax
.1:
        mov dl, byte [eax]
        test dl, dl
        je short .3
        sub dl, 61h
        cmp dl, 19h
        ja short .2
        add dl, 41h
        mov byte [eax], dl
.2:
        inc eax
        jmp short .1
.3:
        mov eax, ebx
        pop edx
        pop ebx
        ret
        db 00h
;-----------------------------------------------------------------------------
; __CHP                                                         961D0  library
; Run-time library: rounds the x87 top of stack to an integer (chop)
;-----------------------------------------------------------------------------
__CHP:
        push eax
        wait
        fnstcw word [esp]
        wait
        push dword [esp]
        mov byte [byte esp+01h], 1Fh
        fldcw word [esp]
        frndint
        fldcw word [byte esp+04h]
        wait
        lea esp, [byte esp+08h]
        ret
        db 00h
;-----------------------------------------------------------------------------
; j___sys_init_387_emulator                                     961EE  library
; Jump to the start-up of the 387 emulator
;-----------------------------------------------------------------------------
j___sys_init_387_emulator:
        jmp near __sys_init_387_emulator
;-----------------------------------------------------------------------------
; j___sys_fini_387_emulator                                     961F3  library
; Jump to the shut-down of the 387 emulator
;-----------------------------------------------------------------------------
j___sys_fini_387_emulator:
        jmp near __sys_fini_387_emulator
;-----------------------------------------------------------------------------
; strlwr_                                                       961F8  library
; C run-time: converts a string to lower case in place
;-----------------------------------------------------------------------------
strlwr_:
        push ebx
        push edx
        mov ebx, eax
.1:
        mov dl, byte [eax]
        test dl, dl
        je short .3
        sub dl, 41h
        cmp dl, 19h
        ja short .2
        add dl, 61h
        mov byte [eax], dl
.2:
        inc eax
        jmp short .1
.3:
        mov eax, ebx
        pop edx
        pop ebx
        ret
        db 00h
;-----------------------------------------------------------------------------
; j___delay_                                                    96218  library
; Jump to the run-time millisecond delay
;-----------------------------------------------------------------------------
j___delay_:
        jmp near __delay_
;-----------------------------------------------------------------------------
; perror_                                                       9621D  library
; C run-time: prints a message and the text of the current errno to stderr
;-----------------------------------------------------------------------------
perror_:
        push edx
        test eax, eax
        je short .1
        cmp byte [eax], 0
        je short .1
        mov edx, PerrorSeparator
        call fputs_
        mov eax, str_ColonSpace
        mov edx, PerrorSeparator
        call fputs_
.1:
        call ErrnoPtr
        mov eax, dword [eax]
        mov edx, PerrorSeparator
        call strerror_
        call fputs_
        mov eax, 0Ah
        mov edx, PerrorSeparator
        call fputc_
        pop edx
        ret
;-----------------------------------------------------------------------------
; write_                                                        96267  library
; C run-time: writes a buffer to a file handle
;-----------------------------------------------------------------------------
write_:
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, byte 18h
        push eax
        push edx
        push ebx
        call __IOMode_
        mov edx, eax
        mov dword [byte ebp-018h], eax
        test eax, eax
        jne short .2
        mov eax, 4
.1:
        call __set_errno_
        mov eax, 0FFFFFFFFh
        jmp near .15
.2:
        test al, 2
        jne short .3
        mov eax, 6
        jmp short .1
.3:
        test al, 80h
        je short .5
        mov ebx, dword [byte ebp-01Ch]
        xor edx, eax
        mov al, 2
        mov ah, 42h
        mov ecx, edx
        shr ecx, 10h
        int 21h
        rcl dx, 1
        ror dx, 1
        shl edx, 10h
        mov dx, ax
        mov dword [byte ebp-010h], edx
        test edx, edx
        jge short .5
.4:
        xor eax, eax
        mov ax, word [byte ebp-010h]
        call __set_errno_dos_
        jmp near .15
.5:
        test byte [byte ebp-018h], 40h
        je short .6
        mov ebx, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-020h]
        mov ecx, dword [byte ebp-024h]
        mov ah, 40h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov edx, eax
        mov dword [byte ebp-010h], eax
        test eax, eax
        jl short .4
        cmp eax, dword [byte ebp-024h]
        je near .14
        mov eax, 0Ch
        call __set_errno_
        mov dword [byte ebp-024h], edx
        jmp near .14
.6:
        call CMainHook
        mov edx, eax
        cmp eax, 0B0h
        jae short .7
        call __STKOVF
.7:
        mov edi, 200h
        cmp edx, 230h
        jae short .8
        mov edi, 80h
.8:
        lea eax, [byte edi+03h]
        xor edx, edx
        and al, 0FCh
        xor esi, esi
        sub esp, eax
        mov dword [byte ebp-04h], edx
        mov dword [byte ebp-014h], edx
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-08h], esp
        mov dword [byte ebp-0Ch], eax
.9:
        mov eax, dword [byte ebp-04h]
        cmp eax, dword [byte ebp-024h]
        jae near .13
        mov eax, dword [byte ebp-0Ch]
        cmp byte [eax], 0Ah
        jne short .12
        mov eax, dword [byte ebp-08h]
        mov byte [esi+eax], 0Dh
        inc esi
        cmp esi, edi
        jne short .12
        mov ebx, dword [byte ebp-01Ch]
        mov edx, eax
        mov ecx, edi
        mov ah, 40h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov esi, eax
        mov dword [byte ebp-010h], eax
        test eax, eax
        jl near .4
        cmp eax, edi
        je short .11
.10:
        mov eax, 0Ch
        call __set_errno_
        mov eax, dword [byte ebp-014h]
        add eax, esi
        jmp near .15
.11:
        mov eax, dword [byte ebp-04h]
        xor esi, edi
        mov dword [byte ebp-014h], eax
.12:
        mov eax, dword [byte ebp-08h]
        mov edx, dword [byte ebp-0Ch]
        mov ebx, dword [byte ebp-0Ch]
        mov ecx, dword [byte ebp-04h]
        inc ebx
        inc ecx
        mov dl, byte [edx]
        mov dword [byte ebp-0Ch], ebx
        mov byte [esi+eax], dl
        inc esi
        mov dword [byte ebp-04h], ecx
        cmp esi, edi
        jne short .9
        mov ebx, dword [byte ebp-01Ch]
        mov edx, eax
        mov ecx, edi
        mov ah, 40h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov esi, eax
        mov dword [byte ebp-010h], eax
        test eax, eax
        jl near .4
        cmp eax, edi
        jne short .10
        mov eax, dword [byte ebp-04h]
        xor esi, edi
        mov dword [byte ebp-014h], eax
        jmp near .9
.13:
        test esi, esi
        je short .14
        mov ebx, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-08h]
        mov ecx, esi
        mov ah, 40h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov edx, eax
        mov dword [byte ebp-010h], eax
        test eax, eax
        jl near .4
        cmp eax, esi
        je short .14
        mov eax, 0Ch
        call __set_errno_
        mov eax, dword [byte ebp-014h]
        add eax, edx
        jmp short .15
.14:
        mov eax, dword [byte ebp-024h]
.15:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h
