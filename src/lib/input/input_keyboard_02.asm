; Reading the keyboard.
bits 32
%include "hockey.inc"
section s_B29F0 progbits alloc exec nowrite align=1
extern __GETDS, bailout_vec, KeyReleaseBase, CapsLockState, KeyStateTable
extern KeyMapNormal, KeyMapShift, KeyMapCaps, KeyMapCtrl, KeyMapAlt, BiosKeyFunc
extern KeyBuffer, KeyBufferHead, KeyBufferTail, KeyBufferMask, SavedKbdVecOffset, SavedInt16Offset, SavedRealKbdOffset, FatalErrorHook
extern GraphicsReady, PrintBoxedText, DosGetVector, DosSetVector, AddExitHandler, PrintfSaveRegs, RestoreTextMode, SetScreenTarget
extern WaitKey, SavedKbdVecSelector, SavedInt16Selector, SavedRealKbdSegment, KbdDataSelector
global InstallKeyboardHandler, RemoveKeyboardHandler, KeyboardIrqHandler, IretStub, Int16Handler, Int16Service, KeyDown, BiosKeyCall
global FatalError, FatalErrorEnd
;-----------------------------------------------------------------------------
; InstallKeyboardHandler                       B29F0  95 PC, medium confidence
; Hooks INT 9, 16h and 23h and registers the removal at exit
;-----------------------------------------------------------------------------
InstallKeyboardHandler:
        cmp word [KbdDataSelector], byte 0
        jne near .1
        o16 mov word [KbdDataSelector], ds
        in al, 21h
        push eax
        or al, 3
        out 21h, al
        mov ebx, 9
        call DosGetVector
        mov dword [SavedKbdVecOffset], eax
        mov word [SavedKbdVecSelector], dx
        mov ebx, 16h
        call DosGetVector
        mov dword [SavedInt16Offset], eax
        mov word [SavedInt16Selector], dx
        mov ebx, 23h
        call DosGetVector
        mov dword [SavedRealKbdOffset], eax
        mov word [SavedRealKbdSegment], dx
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
;-----------------------------------------------------------------------------
; RemoveKeyboardHandler                        B2A9B  95 PC, medium confidence
; Restores the INT 9, 16h and 23h vectors
;-----------------------------------------------------------------------------
RemoveKeyboardHandler:
        cmp word [KbdDataSelector], byte 0
        je short .1
        mov word [KbdDataSelector], 0
        pusha
        in al, 21h
        push eax
        or al, 3
        out 21h, al
        mov ebx, 9
        mov eax, dword [SavedKbdVecOffset]
        mov dx, word [SavedKbdVecSelector]
        call DosSetVector
        mov ebx, 16h
        mov eax, dword [SavedInt16Offset]
        mov dx, word [SavedInt16Selector]
        mov ebx, 23h
        mov eax, dword [SavedRealKbdOffset]
        mov dx, word [SavedRealKbdSegment]
        call DosSetVector
        and byte [0417h], 0F0h
        pop eax
        out 21h, al
        mov ebx, BiosKeyCall
        mov dword [BiosKeyFunc], ebx
        popa
.1:
        ret
;-----------------------------------------------------------------------------
; KeyboardIrqHandler                           B2B0A  95 PC, medium confidence
; INT 9 handler that reads scan codes into the key table
;-----------------------------------------------------------------------------
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
        dd KbdDataSelector
        LD or, bl, bl
        jns short .1
        mov byte [dword ebx+KeyReleaseBase], 0
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
        test byte [KeyStateTable+038h], 1
        jne near .10
        test byte [KeyStateTable+01Dh], 1
        jne short .8
        test byte [KeyStateTable+02Ah], 1
        jne short .7
        test byte [KeyStateTable+036h], 1
        jne short .7
        test byte [CapsLockState], 1
        jne short .12
        mov al, byte [dword ebx+KeyMapNormal]
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
        xor dword [CapsLockState], byte 1
        mov al, 0EDh
        out 60h, al
        mov al, byte [CapsLockState]
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
        mov al, byte [dword ebx+KeyMapShift]
        jmp short .2
.8:
        mov al, byte [dword ebx+KeyMapCtrl]
.9:
        jmp short .2
.10:
        test byte [KeyStateTable+01Dh], 1
.11:
        mov al, byte [dword ebx+KeyMapAlt]
        jmp short .2
.12:
        mov al, byte [dword ebx+KeyMapCaps]
        jmp short .2
        test byte [KeyStateTable+053h], 1
        je short .11
        jmp short .9
IretStub:                                       ; used by InstallKeyboardHandler
        db 0CFh
;-----------------------------------------------------------------------------
; Int16Handler                                                    B2C01  95 PC
; Keyboard: BIOS keyboard service replacement that reads from the game's key
; buffer
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; Int16Service                                 B2C4A  95 PC, medium confidence
; Keyboard: handles the BIOS keyboard read and status calls
;-----------------------------------------------------------------------------
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
        mov al, byte [KeyStateTable+02Ah]
        or al, byte [KeyStateTable+036h]
        and al, 1
        LD or, eax, eax
        ret
;-----------------------------------------------------------------------------
; KeyDown                                      B2CBE  95 PC, medium confidence
; Keyboard library: is this key down
;-----------------------------------------------------------------------------
KeyDown:
        push ebp
        LD mov, ebp, esp
        mov ebx, dword [byte ebp+08h]
        movzx eax, byte [dword ebx+KeyStateTable]
        leave
        ret
;-----------------------------------------------------------------------------
; BiosKeyCall                                  B2CCD  95 PC, medium confidence
; Calls BIOS INT 16h with ax
;-----------------------------------------------------------------------------
BiosKeyCall:
        movzx eax, ax
        int 16h
        movzx eax, ax
        ret
        db 00h,00h
;-----------------------------------------------------------------------------
; FatalError                                   B2CD8  95 PC, medium confidence
; Fatal-error exit, never returns: drops its return address, optionally shows
; a message (PrintBoxedText + WaitKey), shuts down
;
; and jumps through bailout_vec; callers push short code strings like 'e1'
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; FatalErrorEnd                                   B2D27  95 PC, low confidence
; Unreached return after FatalError; the hook setter follows unlabelled
;-----------------------------------------------------------------------------
FatalErrorEnd:
        ret
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov dword [FatalErrorHook], eax
        leave
        ret
        db 00h,00h,00h
