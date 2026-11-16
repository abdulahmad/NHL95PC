; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_8FFD4 progbits alloc exec nowrite align=1
extern __CMain, __FiniRtns, __InitRtns, _Extender, _ExtenderSubtype, _osmajor, _osminor, FpuFlags
extern _dynend, _curbrk, _LpCmdLine, _LpPgmName, _STACKLOW, _STACKTOP, _Envptr, kaufmfont
extern ___begtext, stackarea, EmuHookFlags, _psp, __no87, _Envptr_w4
global start, __saved_DS, __saved_DS, __saved_DS, WriteConsoleMessage, WriteConsoleMessage, __GETDS, __STOSB
global __STOSD
;-----------------------------------------------------------------------------
; start                                                         8FFD4  library
; Program entry point: the C run-time start-up
;-----------------------------------------------------------------------------
start:
        jmp short __saved_DS+06h
        push edi
        inc ecx
        push esp
        inc ebx
        dec edi
        dec ebp
        and byte [byte ebx+02Fh], al
        inc ebx
        sub ebp, dword [ebx]
        xor esi, dword [edx]
        and byte [byte edx+075h], dl
        outsb
        sub eax, 656D6954h
        and byte [byte ebx+079h], dh
        jae short __saved_DS+01Eh
        db 065h,06Dh                            ; insn: insd
        and byte [cs:eax], ch
        db 063h,029h                            ; insn: arpl (nasm 3 adds 66h)
        and byte [byte ebx+06Fh], al
        db 070h,079h                            ; insn: raw (target 90077 unlabelled)
        db 072h,069h                            ; insn: raw (target 90069 unlabelled)
        db 067h,068h,074h,020h,062h,079h        ; insn: push 79622074h
        and byte [byte edi+041h], dl
        push esp
        inc ebx
        dec edi
        dec ebp
        and byte [byte ecx+06Eh], cl
        db 074h,065h                            ; insn: raw (target 90077 unlabelled)
        jb short __saved_DS+03Ah
        popa
        je short __saved_DS+038h
        outsd
        outsb
        popa
        insb
        and byte [byte ebx+06Fh], al
        jb short __saved_DS+048h
        and byte [cs:ecx], dh
        cmp dword [eax], edi
        cmp byte [034393931h], ch
        and byte [byte cs:ecx+06Ch], al
        insb
        and byte [byte edx+069h], dh
        db 067h,068h,074h,073h,020h,072h        ; insn: push 72207374h
        db 065h,073h, __saved_DS+059h-($+3)
        jb short __saved_DS+06Ch
        db 065h,064h,02Eh,08Dh,040h,00h         ; insn: lea eax,[eax]
        dd ___begtext
;-----------------------------------------------------------------------------
; __saved_DS                                                           90048  
; C run-time: the data segment saved at start-up for interrupt handlers
;-----------------------------------------------------------------------------
__saved_DS:
        add byte [eax], al
        db 063h,06Fh,06Eh                       ; insn: arpl (nasm 3 adds 66h)
        db 00h
        sti
        and esp, byte 0FFFFFFFCh
        mov ebx, esp
        mov dword [_STACKTOP], ebx
        mov dword [_curbrk], ebx
        mov ax, 24h
        db 066h
        db 0A3h
        dd _psp
        mov ebx, 50484152h
        sub eax, eax
        mov ah, 30h
        int 21h
        mov byte [_osmajor], al
        mov byte [_osminor], ah
        mov ecx, eax
        sub esi, esi
        mov edi, 81h
        shr eax, 10h
        cmp ax, 4458h
        jne short .1
        sub bl, 30h
        mov al, bl
        mov ah, 0
        push eax
        o16 mov es, word [_psp]
        mov ebx, dword [es:05Ch]
        add ebx, 0FFFh
        and ebx, 0FFFFF000h
        mov dword [_curbrk], ebx
        shr ebx, 0Ch
        mov ax, ds
        mov es, eax
        mov ah, 4Ah
        int 21h
        pop eax
        mov bx, ds
        mov cx, 2Ch
        jmp short .2
.1:
        cmp ax, 4243h
        jne short .3
        mov dword [FpuFlags], edx
        mov esi, edx
        mov edx, dword [byte esi+01Ch]
        mov ebx, esp
        sub ebx, edx
        mov ah, 4Ah
        int 21h
        mov bx, ds
        o16 mov word [_psp], ds
        mov eax, dword [byte esi+010h]
        add edi, eax
        sub esi, esi
        mov si, word [byte eax+02Ch]
        shl esi, 4
        mov cx, ds
        mov al, 9
        mov ah, 0
.2:
        jmp short .7
.3:
        mov dx, 78h
        mov ax, 0FF00h
        int 21h
        cmp al, 0
        je short .6
        mov ax, gs
        cmp ax, byte 0
        je short .4
        mov word [EmuHookFlags], ax
.4:
        mov ax, 6
        mov bx, ds
        int 31h
        mov al, 1
        mov ah, 0
        or dx, cx
        je short .5
        mov ah, 1
.5:
        o16 mov word [_psp], es
        db 066h,026h,08Bh,0Dh,02Ch,00h,00h,00h  ; insn: mov cx,[es:2Ch]
        jmp short .7
.6:
        mov dx, ds
        mov cx, 24h
        mov ds, ecx
        mov cx, 2Ch
        mov ds, edx
        mov bx, 17h
        mov al, 0
        mov ah, 0
.7:
        mov byte [_Extender], al
        mov byte [_ExtenderSubtype], ah
        mov es, ebx
        db 066h,026h,08Ch,01Dh                  ; insn: o16 mov [es:80048h],ds
        dd __saved_DS
        mov dword [_Envptr], esi
        mov word [_Envptr_w4], cx
        push esi
        o16 mov es, word [_psp]
        db 03Eh,0BAh                            ; insn: mov edx,37B88h
        dd stackarea
        add edx, byte 0Fh
        and dl, 0F0h
        sub ecx, ecx
        mov cl, byte [byte es:edi-01h]
        cld
        mov al, 20h
        repe scasb
        lea esi, [byte edi-01h]
        mov edi, edx
        mov bx, es
        mov dx, ds
        mov ds, ebx
        mov es, edx
        je short .8
        inc ecx
        rep movsb
.8:
        sub al, al
        stosb
        stosb
        pop esi
        dec edi
        push edi
        push edx
        o16 mov ds, word [es:_Envptr_w4]
        sub ebp, ebp
.9:
        mov eax, dword [esi]
        or eax, 20202020h
        cmp eax, 37386F6Eh
        jne short .10
        cmp byte [byte esi+04h], 3Dh
        jne short .10
        inc ebp
.10:
        cmp byte [esi], 0
        lodsb
        jne short .10
        cmp byte [esi], 0
        jne short .9
        lodsb
        inc esi
        inc esi
.11:
        cmp byte [esi], 0
        movsb
        jne short .11
        pop ds
        pop esi
        mov ebx, esp
        mov word [__no87], bp
        mov dword [_STACKLOW], edi
        mov dword [_dynend], ebx
        db 03Eh,0B9h                            ; insn: mov ecx,37B88h
        dd stackarea
        db 03Eh,0BFh                            ; insn: mov edi,18B68h
        dd kaufmfont
        sub ecx, edi
        cmp byte [_Extender], 1
        jne short .12
        cmp ecx, 1000h
        jbe short .12
        mov ecx, 1000h
.12:
        mov dl, cl
        shr ecx, 2
        sub eax, eax
        rep stosd
        mov cl, dl
        and cl, 3
        rep stosb
        db 03Eh,0B8h                            ; insn: mov eax,37B88h
        dd stackarea
        add eax, byte 0Fh
        and al, 0F0h
        mov dword [_LpCmdLine], eax
        mov dword [_LpPgmName], esi
        mov eax, 0FFh
        call __InitRtns
        sub ebp, ebp
        call __CMain
        jmp short WriteConsoleMessage+023h
;-----------------------------------------------------------------------------
; WriteConsoleMessage                          90267  95 PC, medium confidence
; Writes a message to the console through DOS before exit
;-----------------------------------------------------------------------------
WriteConsoleMessage:
        push edx
        push eax
        db 0BAh                                 ; insn: mov edx,8004Ah
        dd __saved_DS+02h
        mov ax, 3D01h
        int 21h
        mov bx, ax
        pop edx
        mov esi, edx
        cld
.1:
        lodsb
        cmp al, 0
        jne short .1
        mov ecx, esi
        sub ecx, edx
        dec ecx
        mov ah, 40h
        int 21h
        pop eax
        push eax
        mov eax, 0
        mov edx, 0FFh
        call __FiniRtns
        pop eax
        mov ah, 4Ch
        int 21h
        nop
;-----------------------------------------------------------------------------
; __GETDS                                                         902A0  95 PC
; Watcom cstart __GETDS: o16 mov ds,[cs:__saved_DS] (the word at __saved_DS in
; the cstart code) / ret, right after cstart's int 21h/4Ch exit; called first
;
; by interrupt handlers (TimerISR, the GUS, MPU-401 and EACSNDF IRQ
;
; handlers, the input_joystick_misc handler at B300C)
;-----------------------------------------------------------------------------
__GETDS:                                        ; used by AdlibClose, AdlibDetect, AdlibInit ...
        db 066h,02Eh,08Eh,01Dh                  ; insn: o16 mov ds,[cs:80048h]
        dd __saved_DS
        ret
        db 00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; __STOSB                                                       902B0  library
; Run-time library: fills bytes (memset helper)
;-----------------------------------------------------------------------------
__STOSB:
        or ecx, ecx
        je short .3
        cmp byte [eax], dl
.1:
        test al, 3
        je short .2
        mov byte [eax], dl
        inc eax
        ror edx, 8
        dec ecx
        jne short .1
.2:
        push ecx
        shr ecx, 2
        call __STOSD
        pop ecx
        and ecx, byte 3
        je short .3
        mov byte [eax], dl
        dec ecx
        je short .3
        mov byte [byte eax+01h], dh
        dec ecx
        je short .3
        mov byte [byte eax+02h], dl
.3:
        ret
        db 090h,090h,090h,090h,090h,090h
;-----------------------------------------------------------------------------
; __STOSD                                                       902E7  library
; Run-time library: fills dwords (memset helper)
;-----------------------------------------------------------------------------
__STOSD:
        or ecx, ecx
        je short .7
.1:
        test al, 1Fh
        je short .2
        mov dword [eax], edx
        lea eax, [byte eax+04h]
        dec ecx
        jne short .1
.2:
        push ecx
        shr ecx, 2
        je short .6
        dec ecx
        je short .5
.3:
        mov dword [eax], edx
        mov dword [byte eax+04h], edx
        dec ecx
        mov dword [byte eax+08h], edx
        mov dword [byte eax+0Ch], edx
        je short .4
        cmp byte [byte eax+020h], dl
        mov dword [byte eax+010h], edx
        mov dword [byte eax+014h], edx
        dec ecx
        mov dword [byte eax+018h], edx
        mov dword [byte eax+01Ch], edx
        lea eax, [byte eax+020h]
        jne short .3
        lea eax, [byte eax-010h]
.4:
        lea eax, [byte eax+010h]
.5:
        mov dword [eax], edx
        mov dword [byte eax+04h], edx
        mov dword [byte eax+08h], edx
        mov dword [byte eax+0Ch], edx
        lea eax, [byte eax+010h]
.6:
        pop ecx
        and ecx, byte 3
        je short .7
        mov dword [eax], edx
        lea eax, [byte eax+04h]
        dec ecx
        je short .7
        mov dword [eax], edx
        lea eax, [byte eax+04h]
        dec ecx
        je short .7
        mov dword [eax], edx
        lea eax, [byte eax+04h]
.7:
        ret
        db 00h
