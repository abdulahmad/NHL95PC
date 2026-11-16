; Reading a packed file as blocks.
bits 32
%include "hockey.inc"
section s_93308 progbits alloc exec nowrite align=1
extern str_SavefileblockaOPENFAILEDFOR, DebugRow, byte_D4545, byte_D4546, DebugMode, DebugScreenBase, DebugLineWidth, FatalError
extern sub_8DBD4, MemDescSize, bcopy, CreateHandle, DosCloseFile, sub_B3C70, ZeroMem, vsprintf_
global SaveDataFile, sub_9333C, sub_93354, savefileblocka, loc_933C7, loc_933CB, loc_933E8, imul32
global sub_933FB, IntSqrt, loc_9348D, loc_934A9, loc_934C0, loc_934C1, loc_934DC, loc_934F2
global SortIndices, loc_93558, loc_93565, loc_93570, loc_935B4, loc_935C1, loc_935CF, DebugPrintf
global loc_93622, DebugSetLine, loc_93671, loc_936A4, unk_936AC, sub_936C0, loc_936E8, loc_93705
global loc_9374E, loc_9377C, loc_937A8, loc_937E5, loc_9380C, loc_93818, loc_9382A, loc_9382F
global loc_93839, DebugScrollUp, loc_938C1, DebugClearScreen, loc_938D9, loc_938EA, DebugSetRow, loc_93906
global DebugSetAttr, sub_93914, loc_93922, sub_93924
SaveDataFile:
        sub esp, byte 28h
        mov eax, dword [byte esp+030h]
        mov dword [esp], eax
        mov eax, dword [byte esp+034h]
        mov dword [byte esp+014h], eax
        xor edx, edx
        mov dword [byte esp+018h], edx
        mov ebx, dword [byte esp+038h]
        push ebx
        lea eax, [byte esp+04h]
        push eax
        mov ecx, dword [byte esp+034h]
        push ecx
        call savefileblocka
        add esp, byte 0Ch
        add esp, byte 28h
        ret
        db 090h
sub_9333C:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call savefileblocka
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
sub_93354:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call savefileblocka
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
savefileblocka:
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov esi, dword [byte esp+020h]
        push esi
        call MemDescSize
        mov edi, eax
        add esp, byte 4
        push esi
        call sub_8DBD4
        mov esi, eax
        add esp, byte 4
        mov eax, esp
        push eax
        lea eax, [byte esp+08h]
        push eax
        lea eax, [byte esp+010h]
        push eax
        mov edx, dword [byte esp+028h]
        push edx
        call CreateHandle
        add esp, byte 10h
        mov ebx, dword [byte esp+08h]
        test ebx, ebx
        jne short loc_933CB
        cmp dword [byte esp+024h], byte 0
        je short loc_933C7
        mov ebp, dword [byte esp+01Ch]
        push ebp
        push str_SavefileblockaOPENFAILEDFOR
        call FatalError
        add esp, byte 8
loc_933C7:
        xor eax, eax
        jmp short loc_933E8
loc_933CB:
        push edi
        push esi
        push ebx
        call sub_B3C70
        add esp, byte 0Ch
        mov esi, dword [byte esp+08h]
        push esi
        call DosCloseFile
        add esp, byte 4
        mov eax, 1
loc_933E8:
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        ret
        db 00h
imul32:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        imul edx
        ret
sub_933FB:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mul edx
        ret
        mov eax, dword [byte esp+04h]
        cdq
        mov ebx, dword [byte esp+08h]
        idiv ebx
        ret
        mov eax, dword [byte esp+04h]
        LD xor, edx, edx
        mov ebx, dword [byte esp+08h]
        div ebx
        ret
        mov eax, dword [byte esp+04h]
        cdq
        mov ebx, dword [byte esp+08h]
        idiv ebx
        ret
        mov edx, dword [byte esp+04h]
        LD xor, eax, eax
        mov ebx, dword [byte esp+08h]
        div ebx
        shr eax, 0Ch
        ret
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        imul edx
        idiv ebx
        ret
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        div ebx
        ret
        mov eax, dword [byte esp+04h]
        LD mov, ebx, eax
        mov edx, 1
        mov eax, 0
        idiv ebx
        ret
        db 00h,00h
IntSqrt:
        mov eax, dword [byte esp+04h]
        cmp eax, 10000h
        jae short loc_934F2
        cmp eax, 930h
        ja short loc_934C1
        LD mov, edx, eax
        shr edx, 1
        je short loc_934C0
        mov eax, 0FFFFFFFAh
loc_9348D:
        add eax, byte 10h
        LD sub, edx, eax
        js short loc_934A9
        add eax, byte 10h
        LD sub, edx, eax
        js short loc_934A9
        add eax, byte 10h
        LD sub, edx, eax
        js short loc_934A9
        add eax, byte 10h
        LD sub, edx, eax
        jns short loc_9348D
loc_934A9:
        LD add, edx, eax
        sub eax, byte 6
        shr eax, 2
        LD sub, edx, eax
        js short loc_934C0
        inc eax
        LD sub, edx, eax
        js short loc_934C0
        inc eax
        LD sub, edx, eax
        js short loc_934C0
        inc eax
loc_934C0:
        ret
loc_934C1:
        LD mov, ecx, eax
        LD mov, bl, ah
        add bl, 30h
        jb short loc_934DC
        div bl
        LD add, bl, al
        LD mov, ax, cx
        rcr bl, 1
        div bl
        LD add, al, bl
        rcr al, 1
        LD xor, ah, ah
        ret
loc_934DC:
        LD mov, ebx, eax
        shr ebx, 9
        add bx, 80h
        LD xor, edx, edx
        div bx
        LD add, ax, bx
        rcr ax, 1
        ret
loc_934F2:
        push edi
        LD mov, edi, eax
        shr edi, 10h
        LD mov, ecx, eax
        LD mov, edx, edi
        LD mov, ebx, edx
        add bh, 8
        div bx
        LD add, ebx, eax
        shr bx, 1
        LD mov, edx, edi
        LD mov, eax, ecx
        div bx
        LD add, ebx, eax
        shr bx, 1
        LD mov, edx, edi
        LD mov, eax, ecx
        div bx
        LD add, ebx, eax
        shr bx, 1
        LD mov, edx, edi
        LD mov, eax, ecx
        div bx
        LD add, eax, ebx
        shr ax, 1
        movzx eax, ax
        pop edi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
SortIndices:
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov eax, dword [byte esp+018h]
        sar eax, 1
        mov dword [byte esp+04h], eax
        test eax, eax
        jle near loc_935CF
loc_93558:
        mov eax, dword [byte esp+04h]
        mov dword [esp], eax
        cmp eax, dword [byte esp+018h]
        jge short loc_935C1
loc_93565:
        mov eax, dword [esp]
        sub eax, dword [byte esp+04h]
        test eax, eax
        jl short loc_935B4
loc_93570:
        mov edi, dword [byte esp+04h]
        add edi, eax
        shl edi, 2
        mov ebx, dword [byte esp+01Ch]
        add ebx, edi
        lea esi, [nosplit eax*4+00h]
        mov edx, dword [byte esp+01Ch]
        add edx, esi
        mov ecx, dword [edx]
        cmp ecx, dword [ebx]
        jge short loc_935B4
        mov ecx, dword [edx]
        mov ebp, dword [ebx]
        mov dword [edx], ebp
        mov dword [ebx], ecx
        mov ebx, dword [byte esp+020h]
        add esi, ebx
        mov ecx, dword [esi]
        mov edx, ebx
        mov ebx, dword [edx+edi]
        mov dword [esi], ebx
        mov dword [edx+edi], ecx
        sub eax, dword [byte esp+04h]
        test eax, eax
        jge short loc_93570
loc_935B4:
        mov edi, dword [esp]
        inc edi
        mov dword [esp], edi
        cmp edi, dword [byte esp+018h]
        jl short loc_93565
loc_935C1:
        mov ebx, dword [byte esp+04h]
        sar ebx, 1
        mov dword [byte esp+04h], ebx
        test ebx, ebx
        jg short loc_93558
loc_935CF:
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
DebugPrintf:
        sub esp, 104h
        cmp dword [DebugMode], byte 2
        jl short loc_93622
        lea eax, [dword esp+010Ch]
        mov dword [dword esp+0100h], eax
        lea ebx, [dword esp+0100h]
        mov edx, dword [dword esp+0108h]
        mov eax, esp
        call vsprintf_
        xor ebx, ebx
        mov dword [dword esp+0100h], ebx
        mov eax, esp
        call sub_936C0
loc_93622:
        add esp, 104h
        ret
        db 08Dh,040h,00h
DebugSetLine:
        push esi
        sub esp, 104h
        mov ebx, dword [dword esp+010Ch]
        mov edx, dword [dword esp+0110h]
        cmp dword [DebugMode], byte 2
        jl short loc_936A4
        test ebx, ebx
        jl short loc_93671
        cmp ebx, byte 50h
        jge short loc_93671
        test edx, edx
        jl short loc_93671
        cmp edx, byte 19h
        jge short loc_93671
        lea eax, [nosplit edx*4+00h]
        add eax, edx
        shl eax, 4
        add eax, ebx
        add eax, eax
        mov dword [DebugLineWidth], eax
loc_93671:
        lea eax, [dword esp+0118h]
        mov dword [dword esp+0100h], eax
        lea ebx, [dword esp+0100h]
        mov edx, dword [dword esp+0114h]
        mov eax, esp
        call vsprintf_
        xor esi, esi
        mov dword [dword esp+0100h], esi
        mov eax, esp
        call sub_936C0
loc_936A4:
        add esp, 104h
        pop esi
        ret
unk_936AC:
        dd loc_9377C
        dd loc_937A8
        dd loc_937E5
        dd loc_9380C
        dd loc_93818
sub_936C0:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov edi, eax
        sub ecx, ecx
        dec ecx
        xor eax, eax
        repne scasb
        not ecx
        dec ecx
        mov ebp, ecx
        xor ah, ah
        mov byte [esp], ah
        xor edi, edi
        test ecx, ecx
        jle near loc_93839
loc_936E8:
        cmp byte [esp], 0Eh
        jne short loc_93705
        xor eax, eax
        mov al, byte [esi]
        push eax
        call DebugSetAttr
        add esp, byte 4
        xor bh, bh
        mov byte [esp], bh
        jmp near loc_9382F
loc_93705:
        mov al, byte [esi]
        mov byte [esp], al
        cmp al, 20h
        jb short loc_9374E
        call DebugScrollUp
        xor dh, dh
        mov dl, byte [byte_D4545]
        shl edx, 8
        xor ah, ah
        mov al, byte [esp]
        add edx, eax
        mov eax, dword [DebugScreenBase]
        mov ebx, dword [DebugLineWidth]
        add eax, ebx
        mov word [eax], dx
        lea ecx, [byte ebx+02h]
        mov dword [DebugLineWidth], ecx
        inc esi
        inc edi
        cmp edi, ebp
        jl short loc_936E8
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
loc_9374E:
        sub al, 8
        cmp al, 4
        ja near loc_9382F
        and eax, 0FFh
        lea ebx, [nosplit eax*4+00h]
        mov eax, dword [DebugLineWidth]
        mov edx, eax
        sar edx, 1Fh
        mov ecx, 0A0h
        idiv ecx
        jmp dword [dword cs:ebx+unk_936AC]
loc_9377C:
        mov ebx, dword [DebugLineWidth]
        cmp ebx, byte 2
        jl near loc_9382F
        lea ecx, [byte ebx-02h]
        mov dword [DebugLineWidth], ecx
        inc esi
        inc edi
        cmp edi, ebp
        jl near loc_936E8
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
loc_937A8:
        cmp byte [byte_D4546], 1
        jbe near loc_9382F
        imul ebx, eax, dword 0A0h
        mov edx, dword [DebugLineWidth]
        sub edx, ebx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edx, eax
        xor ecx, ecx
        mov cl, byte [byte_D4546]
        sar edx, 1Fh
        idiv ecx
        inc eax
        imul eax, ecx
        add eax, eax
        add eax, ebx
        jmp short loc_9382A
loc_937E5:
        inc eax
        mov dword [DebugLineWidth], eax
        imul eax, ecx
        mov dword [DebugLineWidth], eax
        call DebugScrollUp
        inc esi
        inc edi
        cmp edi, ebp
        jl near loc_936E8
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
loc_9380C:
        xor eax, eax
        mov al, byte [DebugRow]
        imul eax, ecx
        jmp short loc_9382A
loc_93818:
        call DebugClearScreen
        xor eax, eax
        mov al, byte [DebugRow]
        imul eax, dword 0A0h
loc_9382A:
        mov dword [DebugLineWidth], eax
loc_9382F:
        inc esi
        inc edi
        cmp edi, ebp
        jl near loc_936E8
loc_93839:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
DebugScrollUp:
        push ebx
        push ecx
        push edx
        cmp dword [DebugLineWidth], 0FA0h
        jl short loc_938C1
        xor edx, edx
        mov dl, byte [DebugRow]
        mov eax, 19h
        sub eax, edx
        lea ebx, [byte eax-01h]
        lea eax, [nosplit ebx*4+00h]
        add eax, ebx
        shl eax, 5
        push eax
        lea eax, [nosplit edx*4+00h]
        add eax, edx
        shl eax, 5
        mov ebx, dword [DebugScreenBase]
        add eax, ebx
        push eax
        inc edx
        lea eax, [nosplit edx*4+00h]
        add eax, edx
        shl eax, 5
        add eax, ebx
        push eax
        call bcopy
        add esp, byte 0Ch
        push dword 0A0h
        mov eax, dword [DebugScreenBase]
        add eax, 0F00h
        push eax
        call ZeroMem
        add esp, byte 8
        mov dword [DebugLineWidth], 0F00h
loc_938C1:
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
DebugClearScreen:
        mov ebx, dword [DebugScreenBase]
        cmp dword [DebugMode], byte 2
        jl short loc_938EA
        xor eax, eax
loc_938D9:
        mov dword [ebx+eax], 0
        add eax, byte 4
        cmp eax, 0FA0h
        jl short loc_938D9
loc_938EA:
        mov dword [DebugScreenBase], ebx
        ret
        db 08Dh,040h,00h
DebugSetRow:
        mov eax, dword [byte esp+04h]
        test eax, eax
        jl short loc_93906
        cmp eax, byte 18h
        jg short loc_93906
        mov byte [DebugRow], al
loc_93906:
        ret
        db 090h
DebugSetAttr:
        mov al, byte [byte esp+04h]
        mov byte [byte_D4545], al
        ret
        db 08Bh,0C0h
sub_93914:
        mov eax, dword [byte esp+04h]
        cmp eax, byte 1
        jl short loc_93922
        mov byte [byte_D4546], al
loc_93922:
        ret
        db 090h
sub_93924:
        mov eax, dword [byte esp+04h]
        shl eax, 0Fh
        add eax, 0B0000h
        mov dword [DebugScreenBase], eax
        ret
        db 08Bh,0C0h
