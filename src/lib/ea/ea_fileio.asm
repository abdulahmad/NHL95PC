; Opening and reading a file through the EA file library.
bits 32
%include "hockey.inc"
section s_B3B00 progbits alloc exec nowrite align=1
extern str_OpenhandleSFILEERROR, ResourceArchiveName, ArchiveHandle, ArchiveOpenFn, ArchiveCount, ResourceArchive, dword_D44AC, SlowDeadline
extern PrintfSavedEbx, PrintfSavedEcx, PrintfSavedEdx, PrintfSavedEsi, PrintfSavedEdi, PrintfSavedReturn, FatalError, slowtickcount
extern sprintf_, AngleFromDelta, TableSin, TableCos, unk_D4448, unk_D44B0, unk_D44CE
global DosCallSplitDx, DosOpenFile, DosOpenReadOnly, CreateHandle, openhandle, DosCloseFile, DosWriteFile, DosReadFile
global DosSeekFile, FindFirstFile, FindFirstFile, FindNextFile, SetSlowDeadline, WaitSlowDeadline, SlowDeadlinePassed, DebugLineCount
global vecdist, SprintfSaveRegs
DosCallSplitDx:
        push ecx
        push edx
        LD mov, ecx, edx
        shr ecx, 10h
        movzx edx, dx
        int 21h
        pushf
        shl edx, 10h
        LD mov, dx, ax
        LD mov, eax, edx
        popf
        pop edx
        pop ecx
        ret
DosOpenFile:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        mov eax, dword [byte ebp+018h]
        mov dword [byte ebp-04h], eax
        mov dword [byte ebp-08h], 3D00h
        jmp short openhandle+014h
DosOpenReadOnly:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        mov dword [byte ebp-04h], 0
        mov dword [byte ebp-08h], 3D00h
        jmp short openhandle+014h
CreateHandle:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        mov dword [byte ebp-04h], 0
        mov dword [byte ebp-08h], 3C00h
        jmp short openhandle+014h
openhandle:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        mov dword [byte ebp-04h], 1
        mov dword [byte ebp-08h], 3D00h
        mov ebx, dword [byte ebp+0Ch]
        mov dword [ebx], 0
        mov edx, dword [byte ebp+08h]
        mov eax, dword [byte ebp-08h]
        LD xor, ecx, ecx
        int 21h
        jb short .1
        mov ebx, dword [byte ebp+0Ch]
        mov dword [ebx], eax
        LD mov, ebx, eax
        db 0B8h,02h,042h,00h,00h                ; insn: mov eax,4202h
        LD xor, edx, edx
        call DosCallSplitDx
        jb short .1
        db 08Bh,05Dh,014h                       ; insn: mov ebx,[ebp+14h]
        db 089h,03h                             ; insn: mov [ebx],eax
        mov ebx, dword [byte ebp+0Ch]
        mov ebx, dword [ebx]
        mov eax, 4200h
        LD xor, edx, edx
        call DosCallSplitDx
        jb short .1
        mov ebx, dword [byte ebp+010h]
        LD xor, eax, eax
        mov dword [ebx], eax
        leave
        ret
.1:
        cmp byte [ResourceArchiveName], 0
        je short .3
        mov edx, ResourceArchiveName
        mov eax, dword [byte ebp-08h]
        LD xor, ecx, ecx
        int 21h
        jb short .3
        mov ebx, dword [byte ebp+0Ch]
        mov dword [ebx], eax
        LD mov, ebx, eax
        mov edx, dword [ArchiveHandle]
        cmp byte [edx], 0
        jne short .2
        mov ecx, dword [ResourceArchive]
        mov ah, 3Fh
        int 21h
        jb short .3
.2:
        push dword [byte ebp+08h]
        push dword [ArchiveHandle]
        call dword [ArchiveOpenFn]
        add esp, byte 8
        LD or, eax, eax
        je short .3
        mov ebx, dword [byte ebp+010h]
        mov dword [ebx], eax
        mov ebx, dword [ArchiveCount]
        mov ecx, dword [ebx]
        mov ebx, dword [byte ebp+014h]
        mov dword [ebx], ecx
        LD mov, edx, eax
        mov eax, 4200h
        mov ebx, dword [byte ebp+0Ch]
        mov ebx, dword [ebx]
        call DosCallSplitDx
        jb short .3
        leave
        ret
.3:
        mov ebx, dword [byte ebp+0Ch]
        mov eax, dword [ebx]
        mov dword [ebx], 0
        push eax
        call DosCloseFile
        add esp, byte 4
        cmp dword [byte ebp-04h], byte 0
        jne short .4
        mov ebx, dword [byte ebp+014h]
        LD xor, eax, eax
        mov dword [ebx], eax
        mov ebx, dword [byte ebp+010h]
        mov dword [ebx], eax
        leave
        ret
.4:
        push dword [byte ebp+08h]
        push str_OpenhandleSFILEERROR
        call FatalError
DosCloseFile:
        push ebp
        LD mov, ebp, esp
        mov ebx, dword [byte ebp+08h]
        LD or, ebx, ebx
        je short .1
        mov ah, 3Eh
        int 21h
.1:
        leave
        ret
DosWriteFile:
        mov ah, 40h
        jmp short DosReadFile+02h
DosReadFile:
        mov ah, 3Fh
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        mov dword [byte ebp-08h], eax
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
.1:
        mov eax, 1
        mov edx, dword [byte ebp-04h]
        mov ecx, 4000h
        sub dword [byte ebp+010h], ecx
        jge short .2
        add ecx, dword [byte ebp+010h]
        jle short .4
.2:
        mov ebx, dword [byte ebp+08h]
        mov eax, dword [byte ebp-08h]
        int 21h
        jb short .3
        add dword [byte ebp-04h], 4000h
        jmp short .1
.3:
        LD xor, eax, eax
.4:
        leave
        ret
DosSeekFile:
        push ebp
        LD mov, ebp, esp
        mov ebx, dword [byte ebp+08h]
        mov eax, 4200h
        mov edx, dword [byte ebp+0Ch]
        call DosCallSplitDx
        leave
        ret
FindFirstFile:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov edx, unk_D44B0
        mov ah, 1Ah
        int 21h
        mov edx, dword [byte ebp+08h]
        mov cl, 6
        mov ah, 4Eh
        int 21h
        jb short FindFirstFile+05Eh
        mov edi, unk_D4448
        mov dword [dword_D44AC], edi
        mov esi, dword [byte ebp+08h]
        mov ecx, 57h
.1:
        lodsb
        stosb
        cmp al, 0
        je short FindFirstFile+042h
        cmp al, 3Ah
        je short .2
        cmp al, 5Ch
        jne short .3
.2:
        mov dword [dword_D44AC], edi
.3:
        loop .1
        mov esi, unk_D44CE
        mov edi, dword [dword_D44AC]
        mov ecx, 0Dh
        cld
        rep movsb
        mov eax, unk_D4448
.4:
        pop edi
        pop esi
        leave
        ret
        LD xor, eax, eax
        jmp short .4
FindNextFile:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov edx, unk_D44B0
        mov ah, 1Ah
        int 21h
        mov ah, 4Fh
        int 21h
        jb short FindFirstFile+05Eh
        jmp short FindFirstFile+042h
        mov eax, dword [slowtickcount]
        ret
SetSlowDeadline:
        mov eax, dword [byte esp+04h]
        add eax, dword [slowtickcount]
        mov dword [SlowDeadline], eax
        ret
WaitSlowDeadline:
        mov eax, dword [slowtickcount]
        sub eax, dword [SlowDeadline]
        js short WaitSlowDeadline
        ret
SlowDeadlinePassed:
        mov ebx, dword [slowtickcount]
        sub ebx, dword [SlowDeadline]
        LD sbb, eax, eax
        inc eax
        ret
DebugLineCount:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFFCh
        mov eax, dword [slowtickcount]
        add eax, dword [byte ebp+08h]
        mov dword [byte ebp-04h], eax
.1:
        mov eax, dword [slowtickcount]
        sub eax, dword [byte ebp-04h]
        js short .1
        leave
        ret
        db 00h,00h,00h
vecdist:
        push ebp
        LD mov, ebp, esp
        push dword [byte ebp+08h]
        push dword [byte ebp+0Ch]
        call AngleFromDelta
        add esp, byte 8
        LD or, eax, eax
        jge short .1
        neg eax
.1:
        cmp eax, 100h
        jle short .2
        neg eax
        add eax, 200h
.2:
        cmp eax, 80h
        jg short .4
        push eax
        call TableCos
        add esp, byte 4
        LD mov, ebx, eax
        mov eax, dword [byte ebp+08h]
        LD or, eax, eax
        jge short .3
        neg eax
.3:
        LD xor, edx, edx
        shl eax, 10h
        div ebx
        leave
        ret
.4:
        push eax
        call TableSin
        add esp, byte 4
        LD mov, ebx, eax
        mov eax, dword [byte ebp+0Ch]
        LD or, eax, eax
        jge short .5
        neg eax
.5:
        LD xor, edx, edx
        shl eax, 10h
        div ebx
        leave
        ret
        db 00h,00h
SprintfSaveRegs:
        mov dword [PrintfSavedEbx], ebx
        mov dword [PrintfSavedEcx], ecx
        mov dword [PrintfSavedEdx], edx
        mov dword [PrintfSavedEsi], esi
        mov dword [PrintfSavedEdi], edi
        pop dword [PrintfSavedReturn]
        call sprintf_
        push dword [PrintfSavedReturn]
        mov ebx, dword [PrintfSavedEbx]
        mov ecx, dword [PrintfSavedEcx]
        mov edx, dword [PrintfSavedEdx]
        mov esi, dword [PrintfSavedEsi]
        mov edi, dword [PrintfSavedEdi]
        ret
