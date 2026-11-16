; Reading the keyboard.
bits 32
%include "hockey.inc"
section s_B29F0 progbits alloc exec nowrite align=1
extern __GETDS, bailout_vec, byte_D2C5C, byte_D2CD4, KeyStateTable, byte_D2CF9, byte_D2D06, byte_D2D12
extern byte_D2D14, byte_D2D2F, byte_D2D7C, byte_D2DD7, byte_D2E32, byte_D2E8D, byte_D2EE8, BiosKeyFunc
extern KeyBuffer, KeyBufferHead, KeyBufferTail, KeyBufferMask, dword_D2D5C, dword_D2D62, dword_D2D68, dword_D2F74
extern GraphicsReady, sub_93170, DosGetVector, DosSetVector, AddExitHandler, PrintfSaveRegs, RestoreTextMode, SetScreenTarget
extern WaitKey, word_D2D60, word_D2D66, word_D2D6C, word_D2D6E
global RemoveKeyboardHandler, loc_B2A9A, sub_B2A9B, loc_B2B09, sub_B2B0A, loc_B2B3A, loc_B2B81, loc_B2B85
global loc_B2BA5, loc_B2BA9, loc_B2BC0, loc_B2BCE, loc_B2BD6, loc_B2BDC, loc_B2BDE, loc_B2BE5
global loc_B2BED, unk_B2C00, sub_B2C01, loc_B2C3B, Int16Service, loc_B2C68, loc_B2C6D, loc_B2C85
global loc_B2CAC, KeyDown, sub_B2CCD, FatalError, loc_B2D01, loc_B2D11, sub_B2D27
RemoveKeyboardHandler:
        cmp word [word_D2D6E], byte 0
        jne near loc_B2A9A
        o16 mov word [word_D2D6E], ds
        in al, 21h
        push eax
        or al, 3
        out 21h, al
        mov ebx, 9
        call DosGetVector
        mov dword [dword_D2D5C], eax
        mov word [word_D2D60], dx
        mov ebx, 16h
        call DosGetVector
        mov dword [dword_D2D62], eax
        mov word [word_D2D66], dx
        mov ebx, 23h
        call DosGetVector
        mov dword [dword_D2D68], eax
        mov word [word_D2D6C], dx
        mov dx, cs
        mov ebx, 9
        mov eax, sub_B2B0A
        call DosSetVector
        mov dx, cs
        mov ebx, 16h
        mov eax, sub_B2C01
        mov dx, cs
        mov ebx, 23h
        mov eax, unk_B2C00
        call DosSetVector
        pop eax
        out 21h, al
        mov ebx, Int16Service
        mov dword [BiosKeyFunc], ebx
        push sub_B2A9B
        call AddExitHandler
        add esp, byte 4
loc_B2A9A:
        ret
sub_B2A9B:
        cmp word [word_D2D6E], byte 0
        je short loc_B2B09
        mov word [word_D2D6E], 0
        pusha
        in al, 21h
        push eax
        or al, 3
        out 21h, al
        mov ebx, 9
        mov eax, dword [dword_D2D5C]
        mov dx, word [word_D2D60]
        call DosSetVector
        mov ebx, 16h
        mov eax, dword [dword_D2D62]
        mov dx, word [word_D2D66]
        mov ebx, 23h
        mov eax, dword [dword_D2D68]
        mov dx, word [word_D2D6C]
        call DosSetVector
        and byte [0417h], 0F0h
        pop eax
        out 21h, al
        mov ebx, sub_B2CCD
        mov dword [BiosKeyFunc], ebx
        popa
loc_B2B09:
        ret
sub_B2B0A:
        push eax
        push ebx
        push ds
        in al, 61h
        LD mov, ah, al
        or al, 80h
        out 61h, al
        LD mov, al, ah
        out 61h, al
        LD xor, eax, eax
        in al, 60h
        LD mov, ebx, eax
        db 066h,02Eh,08Eh,01Dh                  ; insn: o16 mov ds,[cs:12D6Eh]
        dd word_D2D6E
        LD or, bl, bl
        jns short loc_B2B3A
        mov byte [dword ebx+byte_D2C5C], 0
        mov al, 20h
        out 20h, al
        pop ds
        pop ebx
        pop eax
        iret
loc_B2B3A:
        mov byte [dword ebx+KeyStateTable], 1
        mov al, 20h
        out 20h, al
        cmp ebx, byte 3Ah
        je short loc_B2BA9
        test byte [byte_D2D14], 1
        jne near loc_B2BDE
        test byte [byte_D2CF9], 1
        jne short loc_B2BD6
        test byte [byte_D2D06], 1
        jne short loc_B2BCE
        test byte [byte_D2D12], 1
        jne short loc_B2BCE
        test byte [byte_D2CD4], 1
        jne short loc_B2BED
        mov al, byte [dword ebx+byte_D2D7C]
loc_B2B81:
        cmp al, 80h
        jae short loc_B2BC0
loc_B2B85:
        LD or, eax, eax
        je short loc_B2BA5
        mov ebx, dword [KeyBufferHead]
        mov dword [nosplit ebx*4+KeyBuffer], eax
        add ebx, byte 1
        and ebx, dword [KeyBufferMask]
        mov dword [KeyBufferHead], ebx
loc_B2BA5:
        pop ds
        pop ebx
        pop eax
        iret
loc_B2BA9:
        xor dword [byte_D2CD4], byte 1
        mov al, 0EDh
        out 60h, al
        mov al, byte [byte_D2CD4]
        shl al, 2
        out 60h, al
        jmp short loc_B2BA5
loc_B2BC0:
        LD mov, ah, al
        LD xor, al, al
        cmp ah, 90h
        jb short loc_B2B85
        and ah, 7Fh
        jmp short loc_B2B85
loc_B2BCE:
        mov al, byte [dword ebx+byte_D2DD7]
        jmp short loc_B2B81
loc_B2BD6:
        mov al, byte [dword ebx+byte_D2E8D]
loc_B2BDC:
        jmp short loc_B2B81
loc_B2BDE:
        test byte [byte_D2CF9], 1
loc_B2BE5:
        mov al, byte [dword ebx+byte_D2EE8]
        jmp short loc_B2B81
loc_B2BED:
        mov al, byte [dword ebx+byte_D2E32]
        jmp short loc_B2B81
        test byte [byte_D2D2F], 1
        je short loc_B2BE5
        jmp short loc_B2BDC
unk_B2C00:
        db 0CFh
sub_B2C01:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        push ds
        push es
        push fs
        push gs
        LD mov, ebp, esp
        sub esp, byte 8
        cld
        call __GETDS
        sti
        call Int16Service
        pushf
        pop ebx
        and ebx, 4000h
        jne short loc_B2C3B
        LD mov, esp, ebp
        pop gs
        pop fs
        pop es
        pop ds
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        LD or, eax, eax
        retf 4
loc_B2C3B:
        LD mov, esp, ebp
        pop gs
        pop fs
        pop es
        pop ds
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        iret
Int16Service:
        cmp ah, 0
        je short loc_B2C85
        cmp ah, 10h
        je short loc_B2C85
        cmp ah, 1
        je short loc_B2C6D
        cmp ah, 11h
        je short loc_B2C6D
        cmp ah, 2
        je short loc_B2CAC
        cmp ah, 12h
        je short loc_B2CAC
loc_B2C68:
        LD xor, eax, eax
        LD or, eax, eax
        ret
loc_B2C6D:
        mov ebx, dword [KeyBufferTail]
        cmp ebx, dword [KeyBufferHead]
        je short loc_B2C68
        mov eax, dword [nosplit ebx*4+KeyBuffer]
        LD or, eax, eax
        ret
loc_B2C85:
        mov ebx, dword [KeyBufferTail]
        cmp ebx, dword [KeyBufferHead]
        je short loc_B2C85
        mov eax, dword [nosplit ebx*4+KeyBuffer]
        add ebx, byte 1
        and ebx, dword [KeyBufferMask]
        mov dword [KeyBufferTail], ebx
        LD or, eax, eax
        ret
loc_B2CAC:
        LD xor, eax, eax
        mov al, byte [byte_D2D06]
        or al, byte [byte_D2D12]
        and al, 1
        LD or, eax, eax
        ret
KeyDown:
        push ebp
        LD mov, ebp, esp
        mov ebx, dword [byte ebp+08h]
        movzx eax, byte [dword ebx+KeyStateTable]
        leave
        ret
sub_B2CCD:
        movzx eax, ax
        int 16h
        movzx eax, ax
        ret
        db 00h,00h
FatalError:
        pop eax
        cmp dword [dword_D2F74], byte 0
        jne short loc_B2D11
        cmp dword [GraphicsReady], byte 0
        je short loc_B2D01
        call SetScreenTarget
        push byte 0
        push byte 0
        call sub_93170
        add esp, byte 8
        call WaitKey
loc_B2D01:
        call RestoreTextMode
        call PrintfSaveRegs
        call dword [bailout_vec]
loc_B2D11:
        push dword [dword_D2F74]
        call RestoreTextMode
        call PrintfSaveRegs
        call dword [bailout_vec]
sub_B2D27:
        ret
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov dword [dword_D2F74], eax
        leave
        ret
        db 00h,00h,00h
