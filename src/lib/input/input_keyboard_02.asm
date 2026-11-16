; Reading the keyboard.
bits 32
%include "hockey.inc"
section s_B29F0 progbits alloc exec nowrite align=1
extern __GETDS, bailout_vec, byte_D2C5C, byte_D2CD4, KeyStateTable, byte_D2CF9, byte_D2D06, byte_D2D12
extern byte_D2D14, byte_D2D2F, byte_D2D7C, byte_D2DD7, byte_D2E32, byte_D2E8D, byte_D2EE8, BiosKeyFunc
extern KeyBuffer, KeyBufferHead, KeyBufferTail, KeyBufferMask, dword_D2D5C, dword_D2D62, dword_D2D68, FatalErrorHook
extern GraphicsReady, PrintBoxedText, DosGetVector, DosSetVector, AddExitHandler, PrintfSaveRegs, RestoreTextMode, SetScreenTarget
extern WaitKey, word_D2D60, word_D2D66, word_D2D6C, word_D2D6E
global InstallKeyboardHandler, RemoveKeyboardHandler, KeyboardIrqHandler, IretStub, Int16Handler, Int16Service, KeyDown, BiosKeyCall
global FatalError, FatalErrorEnd
InstallKeyboardHandler:
        cmp word [word_D2D6E], byte 0
        jne near .1
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
        mov eax, KeyboardIrqHandler
        call DosSetVector
        mov dx, cs
        mov ebx, 16h
        mov eax, Int16Handler
        mov dx, cs
        mov ebx, 23h
        mov eax, IretStub
        call DosSetVector
        pop eax
        out 21h, al
        mov ebx, Int16Service
        mov dword [BiosKeyFunc], ebx
        push RemoveKeyboardHandler
        call AddExitHandler
        add esp, byte 4
.1:
        ret
RemoveKeyboardHandler:
        cmp word [word_D2D6E], byte 0
        je short .1
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
        mov ebx, BiosKeyCall
        mov dword [BiosKeyFunc], ebx
        popa
.1:
        ret
KeyboardIrqHandler:
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
        jns short .1
        mov byte [dword ebx+byte_D2C5C], 0
        mov al, 20h
        out 20h, al
        pop ds
        pop ebx
        pop eax
        iret
.1:
        mov byte [dword ebx+KeyStateTable], 1
        mov al, 20h
        out 20h, al
        cmp ebx, byte 3Ah
        je short .5
        test byte [byte_D2D14], 1
        jne near .10
        test byte [byte_D2CF9], 1
        jne short .8
        test byte [byte_D2D06], 1
        jne short .7
        test byte [byte_D2D12], 1
        jne short .7
        test byte [byte_D2CD4], 1
        jne short .12
        mov al, byte [dword ebx+byte_D2D7C]
.2:
        cmp al, 80h
        jae short .6
.3:
        LD or, eax, eax
        je short .4
        mov ebx, dword [KeyBufferHead]
        mov dword [nosplit ebx*4+KeyBuffer], eax
        add ebx, byte 1
        and ebx, dword [KeyBufferMask]
        mov dword [KeyBufferHead], ebx
.4:
        pop ds
        pop ebx
        pop eax
        iret
.5:
        xor dword [byte_D2CD4], byte 1
        mov al, 0EDh
        out 60h, al
        mov al, byte [byte_D2CD4]
        shl al, 2
        out 60h, al
        jmp short .4
.6:
        LD mov, ah, al
        LD xor, al, al
        cmp ah, 90h
        jb short .3
        and ah, 7Fh
        jmp short .3
.7:
        mov al, byte [dword ebx+byte_D2DD7]
        jmp short .2
.8:
        mov al, byte [dword ebx+byte_D2E8D]
.9:
        jmp short .2
.10:
        test byte [byte_D2CF9], 1
.11:
        mov al, byte [dword ebx+byte_D2EE8]
        jmp short .2
.12:
        mov al, byte [dword ebx+byte_D2E32]
        jmp short .2
        test byte [byte_D2D2F], 1
        je short .11
        jmp short .9
IretStub:
        db 0CFh
Int16Handler:
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
        jne short .1
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
.1:
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
        je short .3
        cmp ah, 10h
        je short .3
        cmp ah, 1
        je short .2
        cmp ah, 11h
        je short .2
        cmp ah, 2
        je short .4
        cmp ah, 12h
        je short .4
.1:
        LD xor, eax, eax
        LD or, eax, eax
        ret
.2:
        mov ebx, dword [KeyBufferTail]
        cmp ebx, dword [KeyBufferHead]
        je short .1
        mov eax, dword [nosplit ebx*4+KeyBuffer]
        LD or, eax, eax
        ret
.3:
        mov ebx, dword [KeyBufferTail]
        cmp ebx, dword [KeyBufferHead]
        je short .3
        mov eax, dword [nosplit ebx*4+KeyBuffer]
        add ebx, byte 1
        and ebx, dword [KeyBufferMask]
        mov dword [KeyBufferTail], ebx
        LD or, eax, eax
        ret
.4:
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
BiosKeyCall:
        movzx eax, ax
        int 16h
        movzx eax, ax
        ret
        db 00h,00h
FatalError:
        pop eax
        cmp dword [FatalErrorHook], byte 0
        jne short .2
        cmp dword [GraphicsReady], byte 0
        je short .1
        call SetScreenTarget
        push byte 0
        push byte 0
        call PrintBoxedText
        add esp, byte 8
        call WaitKey
.1:
        call RestoreTextMode
        call PrintfSaveRegs
        call dword [bailout_vec]
.2:
        push dword [FatalErrorHook]
        call RestoreTextMode
        call PrintfSaveRegs
        call dword [bailout_vec]
FatalErrorEnd:
        ret
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov dword [FatalErrorHook], eax
        leave
        ret
        db 00h,00h,00h
