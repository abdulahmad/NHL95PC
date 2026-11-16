; Opening and reading a file through the EA file library.
bits 32
%include "hockey.inc"
section s_B3B00 progbits alloc exec nowrite align=1
extern str_OpenhandleSFILEERROR, ResourceArchiveName, ArchiveHandle, ArchiveOpenFn, ArchiveCount, ResourceArchive, dword_D44AC, dword_D4530
extern PrintfSavedEbx, PrintfSavedEcx, PrintfSavedEdx, PrintfSavedEsi, PrintfSavedEdi, PrintfSavedReturn, FatalError, slowtickcount
extern sprintf_, AngleFromDelta, sub_B4A60, sub_B4A66, unk_D4448, unk_D44B0, unk_D44CE
global DosCallSplitDx, DosOpenFile, DosOpenReadOnly, CreateHandle, openhandle, loc_B3B6E, loc_B3BB9, loc_B3BEE
global loc_B3C2B, loc_B3C53, DosCloseFile, loc_B3C6E, sub_B3C70, DosReadFile, loc_B3C76, loc_B3C85
global loc_B3C9C, loc_B3CAF, loc_B3CB1, DosSeekFile, FindFirstFile, loc_B3CF4, loc_B3D02, loc_B3D08
global loc_B3D0A, loc_B3D22, loc_B3D26, sub_B3D2A, sub_B3D46, sub_B3D56, sub_B3D64, DebugLineCount
global loc_B3D85, vecdist, loc_B3DAB, loc_B3DB9, loc_B3DD4, loc_B3DDD, loc_B3DF1, sub_B3DFC
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
        jmp short loc_B3B6E
DosOpenReadOnly:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        mov dword [byte ebp-04h], 0
        mov dword [byte ebp-08h], 3D00h
        jmp short loc_B3B6E
CreateHandle:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        mov dword [byte ebp-04h], 0
        mov dword [byte ebp-08h], 3C00h
        jmp short loc_B3B6E
openhandle:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        mov dword [byte ebp-04h], 1
        mov dword [byte ebp-08h], 3D00h
loc_B3B6E:
        mov ebx, dword [byte ebp+0Ch]
        mov dword [ebx], 0
        mov edx, dword [byte ebp+08h]
        mov eax, dword [byte ebp-08h]
        LD xor, ecx, ecx
        int 21h
        jb short loc_B3BB9
        mov ebx, dword [byte ebp+0Ch]
        mov dword [ebx], eax
        LD mov, ebx, eax
        db 0B8h,02h,042h,00h,00h                ; insn: mov eax,4202h
        LD xor, edx, edx
        call DosCallSplitDx
        jb short loc_B3BB9
        db 08Bh,05Dh,014h                       ; insn: mov ebx,[ebp+14h]
        db 089h,03h                             ; insn: mov [ebx],eax
        mov ebx, dword [byte ebp+0Ch]
        mov ebx, dword [ebx]
        mov eax, 4200h
        LD xor, edx, edx
        call DosCallSplitDx
        jb short loc_B3BB9
        mov ebx, dword [byte ebp+010h]
        LD xor, eax, eax
        mov dword [ebx], eax
        leave
        ret
loc_B3BB9:
        cmp byte [ResourceArchiveName], 0
        je short loc_B3C2B
        mov edx, ResourceArchiveName
        mov eax, dword [byte ebp-08h]
        LD xor, ecx, ecx
        int 21h
        jb short loc_B3C2B
        mov ebx, dword [byte ebp+0Ch]
        mov dword [ebx], eax
        LD mov, ebx, eax
        mov edx, dword [ArchiveHandle]
        cmp byte [edx], 0
        jne short loc_B3BEE
        mov ecx, dword [ResourceArchive]
        mov ah, 3Fh
        int 21h
        jb short loc_B3C2B
loc_B3BEE:
        push dword [byte ebp+08h]
        push dword [ArchiveHandle]
        call dword [ArchiveOpenFn]
        add esp, byte 8
        LD or, eax, eax
        je short loc_B3C2B
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
        jb short loc_B3C2B
        leave
        ret
loc_B3C2B:
        mov ebx, dword [byte ebp+0Ch]
        mov eax, dword [ebx]
        mov dword [ebx], 0
        push eax
        call DosCloseFile
        add esp, byte 4
        cmp dword [byte ebp-04h], byte 0
        jne short loc_B3C53
        mov ebx, dword [byte ebp+014h]
        LD xor, eax, eax
        mov dword [ebx], eax
        mov ebx, dword [byte ebp+010h]
        mov dword [ebx], eax
        leave
        ret
loc_B3C53:
        push dword [byte ebp+08h]
        push str_OpenhandleSFILEERROR
        call FatalError
DosCloseFile:
        push ebp
        LD mov, ebp, esp
        mov ebx, dword [byte ebp+08h]
        LD or, ebx, ebx
        je short loc_B3C6E
        mov ah, 3Eh
        int 21h
loc_B3C6E:
        leave
        ret
sub_B3C70:
        mov ah, 40h
        jmp short loc_B3C76
DosReadFile:
        mov ah, 3Fh
loc_B3C76:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        mov dword [byte ebp-08h], eax
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
loc_B3C85:
        mov eax, 1
        mov edx, dword [byte ebp-04h]
        mov ecx, 4000h
        sub dword [byte ebp+010h], ecx
        jge short loc_B3C9C
        add ecx, dword [byte ebp+010h]
        jle short loc_B3CB1
loc_B3C9C:
        mov ebx, dword [byte ebp+08h]
        mov eax, dword [byte ebp-08h]
        int 21h
        jb short loc_B3CAF
        add dword [byte ebp-04h], 4000h
        jmp short loc_B3C85
loc_B3CAF:
        LD xor, eax, eax
loc_B3CB1:
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
        jb short loc_B3D26
        mov edi, unk_D4448
        mov dword [dword_D44AC], edi
        mov esi, dword [byte ebp+08h]
        mov ecx, 57h
loc_B3CF4:
        lodsb
        stosb
        cmp al, 0
        je short loc_B3D0A
        cmp al, 3Ah
        je short loc_B3D02
        cmp al, 5Ch
        jne short loc_B3D08
loc_B3D02:
        mov dword [dword_D44AC], edi
loc_B3D08:
        loop loc_B3CF4
loc_B3D0A:
        mov esi, unk_D44CE
        mov edi, dword [dword_D44AC]
        mov ecx, 0Dh
        cld
        rep movsb
        mov eax, unk_D4448
loc_B3D22:
        pop edi
        pop esi
        leave
        ret
loc_B3D26:
        LD xor, eax, eax
        jmp short loc_B3D22
sub_B3D2A:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov edx, unk_D44B0
        mov ah, 1Ah
        int 21h
        mov ah, 4Fh
        int 21h
        jb short loc_B3D26
        jmp short loc_B3D0A
        mov eax, dword [slowtickcount]
        ret
sub_B3D46:
        mov eax, dword [byte esp+04h]
        add eax, dword [slowtickcount]
        mov dword [dword_D4530], eax
        ret
sub_B3D56:
        mov eax, dword [slowtickcount]
        sub eax, dword [dword_D4530]
        js short sub_B3D56
        ret
sub_B3D64:
        mov ebx, dword [slowtickcount]
        sub ebx, dword [dword_D4530]
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
loc_B3D85:
        mov eax, dword [slowtickcount]
        sub eax, dword [byte ebp-04h]
        js short loc_B3D85
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
        jge short loc_B3DAB
        neg eax
loc_B3DAB:
        cmp eax, 100h
        jle short loc_B3DB9
        neg eax
        add eax, 200h
loc_B3DB9:
        cmp eax, 80h
        jg short loc_B3DDD
        push eax
        call sub_B4A66
        add esp, byte 4
        LD mov, ebx, eax
        mov eax, dword [byte ebp+08h]
        LD or, eax, eax
        jge short loc_B3DD4
        neg eax
loc_B3DD4:
        LD xor, edx, edx
        shl eax, 10h
        div ebx
        leave
        ret
loc_B3DDD:
        push eax
        call sub_B4A60
        add esp, byte 4
        LD mov, ebx, eax
        mov eax, dword [byte ebp+0Ch]
        LD or, eax, eax
        jge short loc_B3DF1
        neg eax
loc_B3DF1:
        LD xor, edx, edx
        shl eax, 10h
        div ebx
        leave
        ret
        db 00h,00h
sub_B3DFC:
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
