; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_8FFD4 progbits alloc exec nowrite align=1
extern __CMain, __FiniRtns, __InitRtns, _Extender, _ExtenderSubtype, _osmajor, _osminor, dword_D41F4
extern _dynend, _curbrk, _LpCmdLine, _LpPgmName, _STACKLOW, _STACKTOP, _Envptr, kaufmfont
extern ___begtext, stackarea, word_D41F8, _psp, __no87, _Envptr_w4
global start, __saved_DS, loc_9004A, loc_9004E, loc_90066, loc_90080, loc_90082, loc_90090
global loc_900A1, loc_900B4, loc_900D0, loc_90108, loc_9010A, loc_90127, loc_9013B, loc_9014C
global loc_90163, loc_901B8, loc_901CA, loc_901DF, loc_901ED, loc_9022E, loc_90265, sub_90267
global loc_9027B, loc_9028A, __GETDS, __STOSB, loc_902B6, loc_902C3, loc_902E0, __STOSD
global loc_902EB, loc_902F7, loc_90300, loc_90326, loc_90329, loc_90337, loc_90352
start:
        jmp short loc_9004E
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
        jae short loc_90066
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
        jb short loc_90082
        popa
        je short loc_90080
        outsd
        outsb
        popa
        insb
        and byte [byte ebx+06Fh], al
        jb short loc_90090
        and byte [cs:ecx], dh
        cmp dword [eax], edi
        cmp byte [034393931h], ch
        and byte [byte cs:ecx+06Ch], al
        insb
        and byte [byte edx+069h], dh
        db 067h,068h,074h,073h,020h,072h        ; insn: push 72207374h
        db 065h,073h, loc_900A1-($+3)
        jb short loc_900B4
        db 065h,064h,02Eh,08Dh,040h,00h         ; insn: lea eax,[eax]
        dd ___begtext
__saved_DS:
        add byte [eax], al
loc_9004A:
        db 063h,06Fh,06Eh                       ; insn: arpl (nasm 3 adds 66h)
        db 00h
loc_9004E:
        sti
        and esp, byte 0FFFFFFFCh
        mov ebx, esp
        mov dword [_STACKTOP], ebx
        mov dword [_curbrk], ebx
        mov ax, 24h
        db 066h
        db 0A3h
loc_90066:
        dd _psp
        mov ebx, 50484152h
        sub eax, eax
        mov ah, 30h
        int 21h
        mov byte [_osmajor], al
        mov byte [_osminor], ah
loc_90080:
        mov ecx, eax
loc_90082:
        sub esi, esi
        mov edi, 81h
        shr eax, 10h
        cmp ax, 4458h
loc_90090:
        jne short loc_900D0
        sub bl, 30h
        mov al, bl
        mov ah, 0
        push eax
        o16 mov es, word [_psp]
loc_900A1:
        mov ebx, dword [es:05Ch]
        add ebx, 0FFFh
        and ebx, 0FFFFF000h
loc_900B4:
        mov dword [_curbrk], ebx
        shr ebx, 0Ch
        mov ax, ds
        mov es, eax
        mov ah, 4Ah
        int 21h
        pop eax
        mov bx, ds
        mov cx, 2Ch
        jmp short loc_90108
loc_900D0:
        cmp ax, 4243h
        jne short loc_9010A
        mov dword [dword_D41F4], edx
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
loc_90108:
        jmp short loc_90163
loc_9010A:
        mov dx, 78h
        mov ax, 0FF00h
        int 21h
        cmp al, 0
        je short loc_9014C
        mov ax, gs
        cmp ax, byte 0
        je short loc_90127
        mov word [word_D41F8], ax
loc_90127:
        mov ax, 6
        mov bx, ds
        int 31h
        mov al, 1
        mov ah, 0
        or dx, cx
        je short loc_9013B
        mov ah, 1
loc_9013B:
        o16 mov word [_psp], es
        db 066h,026h,08Bh,0Dh,02Ch,00h,00h,00h  ; insn: mov cx,[es:2Ch]
        jmp short loc_90163
loc_9014C:
        mov dx, ds
        mov cx, 24h
        mov ds, ecx
        mov cx, 2Ch
        mov ds, edx
        mov bx, 17h
        mov al, 0
        mov ah, 0
loc_90163:
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
        je short loc_901B8
        inc ecx
        rep movsb
loc_901B8:
        sub al, al
        stosb
        stosb
        pop esi
        dec edi
        push edi
        push edx
        o16 mov ds, word [es:_Envptr_w4]
        sub ebp, ebp
loc_901CA:
        mov eax, dword [esi]
        or eax, 20202020h
        cmp eax, 37386F6Eh
        jne short loc_901DF
        cmp byte [byte esi+04h], 3Dh
        jne short loc_901DF
        inc ebp
loc_901DF:
        cmp byte [esi], 0
        lodsb
        jne short loc_901DF
        cmp byte [esi], 0
        jne short loc_901CA
        lodsb
        inc esi
        inc esi
loc_901ED:
        cmp byte [esi], 0
        movsb
        jne short loc_901ED
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
        jne short loc_9022E
        cmp ecx, 1000h
        jbe short loc_9022E
        mov ecx, 1000h
loc_9022E:
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
loc_90265:
        jmp short loc_9028A
sub_90267:
        push edx
        push eax
        db 0BAh                                 ; insn: mov edx,8004Ah
        dd loc_9004A
        mov ax, 3D01h
        int 21h
        mov bx, ax
        pop edx
        mov esi, edx
        cld
loc_9027B:
        lodsb
        cmp al, 0
        jne short loc_9027B
        mov ecx, esi
        sub ecx, edx
        dec ecx
        mov ah, 40h
        int 21h
        pop eax
loc_9028A:
        push eax
        mov eax, 0
        mov edx, 0FFh
        call __FiniRtns
        pop eax
        mov ah, 4Ch
        int 21h
        nop
__GETDS:
        db 066h,02Eh,08Eh,01Dh                  ; insn: o16 mov ds,[cs:80048h]
        dd __saved_DS
        ret
        db 00h,00h,00h,00h,00h,00h,00h
__STOSB:
        or ecx, ecx
        je short loc_902E0
        cmp byte [eax], dl
loc_902B6:
        test al, 3
        je short loc_902C3
        mov byte [eax], dl
        inc eax
        ror edx, 8
        dec ecx
        jne short loc_902B6
loc_902C3:
        push ecx
        shr ecx, 2
        call __STOSD
        pop ecx
        and ecx, byte 3
        je short loc_902E0
        mov byte [eax], dl
        dec ecx
        je short loc_902E0
        mov byte [byte eax+01h], dh
        dec ecx
        je short loc_902E0
        mov byte [byte eax+02h], dl
loc_902E0:
        ret
        db 090h,090h,090h,090h,090h,090h
__STOSD:
        or ecx, ecx
        je short loc_90352
loc_902EB:
        test al, 1Fh
        je short loc_902F7
        mov dword [eax], edx
        lea eax, [byte eax+04h]
        dec ecx
        jne short loc_902EB
loc_902F7:
        push ecx
        shr ecx, 2
        je short loc_90337
        dec ecx
        je short loc_90329
loc_90300:
        mov dword [eax], edx
        mov dword [byte eax+04h], edx
        dec ecx
        mov dword [byte eax+08h], edx
        mov dword [byte eax+0Ch], edx
        je short loc_90326
        cmp byte [byte eax+020h], dl
        mov dword [byte eax+010h], edx
        mov dword [byte eax+014h], edx
        dec ecx
        mov dword [byte eax+018h], edx
        mov dword [byte eax+01Ch], edx
        lea eax, [byte eax+020h]
        jne short loc_90300
        lea eax, [byte eax-010h]
loc_90326:
        lea eax, [byte eax+010h]
loc_90329:
        mov dword [eax], edx
        mov dword [byte eax+04h], edx
        mov dword [byte eax+08h], edx
        mov dword [byte eax+0Ch], edx
        lea eax, [byte eax+010h]
loc_90337:
        pop ecx
        and ecx, byte 3
        je short loc_90352
        mov dword [eax], edx
        lea eax, [byte eax+04h]
        dec ecx
        je short loc_90352
        mov dword [eax], edx
        lea eax, [byte eax+04h]
        dec ecx
        je short loc_90352
        mov dword [eax], edx
        lea eax, [byte eax+04h]
loc_90352:
        ret
        db 00h
