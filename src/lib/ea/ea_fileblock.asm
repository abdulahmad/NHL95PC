; Reading a packed file as blocks.
bits 32
%include "hockey.inc"
section s_93308 progbits alloc exec nowrite align=1
extern str_SavefileblockaOPENFAILEDFOR, DebugRow, DebugBackColor, DebugTabWidth, DebugMode, DebugScreenBase, DebugLineWidth, FatalError
extern MemDescPtr, MemDescSize, bcopy, CreateHandle, DosCloseFile, DosWriteFile, ZeroMem, vsprintf_
global SaveDataFile, SaveFileBlockErr, SaveFileBlockQuiet, savefileblocka, imul32, umul32, IntSqrt, SortIndices
global DebugPrintf, DebugSetLine, DebugShowLinesJumpTable, DebugShowLines, DebugShowLines, DebugScrollUp, DebugClearScreen, DebugSetRow
global DebugSetAttr, DebugSetTabWidth, DebugSetPage
;-----------------------------------------------------------------------------
; SaveDataFile                                 93308  95 PC, medium confidence
; Saves a memory block to a file
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; SaveFileBlockErr                                9333C  95 PC, low confidence
; Saves a memory block to a file with the error message
;-----------------------------------------------------------------------------
SaveFileBlockErr:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call savefileblocka
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; SaveFileBlockQuiet                              93354  95 PC, low confidence
; Saves a memory block to a file without the error message
;-----------------------------------------------------------------------------
SaveFileBlockQuiet:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call savefileblocka
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; savefileblocka                                                  9336C  95 PC
; Prints its own name: "savefileblocka - OPEN FAILED FOR FILE <%s>"
;-----------------------------------------------------------------------------
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
        call MemDescPtr
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
        jne short .2
        cmp dword [byte esp+024h], byte 0
        je short .1
        mov ebp, dword [byte esp+01Ch]
        push ebp
        push str_SavefileblockaOPENFAILEDFOR
        call FatalError
        add esp, byte 8
.1:
        xor eax, eax
        jmp short .3
.2:
        push edi
        push esi
        push ebx
        call DosWriteFile
        add esp, byte 0Ch
        mov esi, dword [byte esp+08h]
        push esi
        call DosCloseFile
        add esp, byte 4
        mov eax, 1
.3:
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        ret
        db 00h
;-----------------------------------------------------------------------------
; imul32                                       933F0  95 PC, medium confidence
; EA math helper (cdecl): returns [esp+4]*[esp+8] signed (imul edx);
; skatetopuck squares x and y with it
;-----------------------------------------------------------------------------
imul32:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        imul edx
        ret
;-----------------------------------------------------------------------------
; umul32                                       933FB  95 PC, medium confidence
; Unsigned 32-bit multiply; followed by the unlabelled divide helpers
;-----------------------------------------------------------------------------
umul32:
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
;-----------------------------------------------------------------------------
; IntSqrt                                      93470  95 PC, medium confidence
; Returns the integer square root of a number
;-----------------------------------------------------------------------------
IntSqrt:
        mov eax, dword [byte esp+04h]
        cmp eax, 10000h
        jae short .6
        cmp eax, 930h
        ja short .4
        LD mov, edx, eax
        shr edx, 1
        je short .3
        mov eax, 0FFFFFFFAh
.1:
        add eax, byte 10h
        LD sub, edx, eax
        js short .2
        add eax, byte 10h
        LD sub, edx, eax
        js short .2
        add eax, byte 10h
        LD sub, edx, eax
        js short .2
        add eax, byte 10h
        LD sub, edx, eax
        jns short .1
.2:
        LD add, edx, eax
        sub eax, byte 6
        shr eax, 2
        LD sub, edx, eax
        js short .3
        inc eax
        LD sub, edx, eax
        js short .3
        inc eax
        LD sub, edx, eax
        js short .3
        inc eax
.3:
        ret
.4:
        LD mov, ecx, eax
        LD mov, bl, ah
        add bl, 30h
        jb short .5
        div bl
        LD add, bl, al
        LD mov, ax, cx
        rcr bl, 1
        div bl
        LD add, al, bl
        rcr al, 1
        LD xor, ah, ah
        ret
.5:
        LD mov, ebx, eax
        shr ebx, 9
        add bx, 80h
        LD xor, edx, edx
        div bx
        LD add, ax, bx
        rcr ax, 1
        ret
.6:
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
;-----------------------------------------------------------------------------
; SortIndices                                  93540  95 PC, medium confidence
; Sort library: sort n indices by their keys (n, keys, idx)
;-----------------------------------------------------------------------------
SortIndices:
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov eax, dword [byte esp+018h]
        sar eax, 1
        mov dword [byte esp+04h], eax
        test eax, eax
        jle near .6
.1:
        mov eax, dword [byte esp+04h]
        mov dword [esp], eax
        cmp eax, dword [byte esp+018h]
        jge short .5
.2:
        mov eax, dword [esp]
        sub eax, dword [byte esp+04h]
        test eax, eax
        jl short .4
.3:
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
        jge short .4
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
        jge short .3
.4:
        mov edi, dword [esp]
        inc edi
        mov dword [esp], edi
        cmp edi, dword [byte esp+018h]
        jl short .2
.5:
        mov ebx, dword [byte esp+04h]
        sar ebx, 1
        mov dword [byte esp+04h], ebx
        test ebx, ebx
        jg short .1
.6:
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; DebugPrintf                                                     935E0  95 PC
; Vsprintf into a 100h stack buffer and pass it to DebugShowLines only when
; DebugMode >= 2 (debug level); DebugMonitor/DumpStatsLog use it
;
; for their debug text
;-----------------------------------------------------------------------------
DebugPrintf:
        sub esp, 104h
        cmp dword [DebugMode], byte 2
        jl short .1
        lea eax, [dword esp+010Ch]
        mov dword [dword esp+0100h], eax
        lea ebx, [dword esp+0100h]
        mov edx, dword [dword esp+0108h]
        mov eax, esp
        call vsprintf_
        xor ebx, ebx
        mov dword [dword esp+0100h], ebx
        mov eax, esp
        call DebugShowLines
.1:
        add esp, 104h
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; DebugSetLine                                 9362C  95 PC, medium confidence
; Formats a debug message into one of the on-screen debug lines
;-----------------------------------------------------------------------------
DebugSetLine:
        push esi
        sub esp, 104h
        mov ebx, dword [dword esp+010Ch]
        mov edx, dword [dword esp+0110h]
        cmp dword [DebugMode], byte 2
        jl short .2
        test ebx, ebx
        jl short .1
        cmp ebx, byte 50h
        jge short .1
        test edx, edx
        jl short .1
        cmp edx, byte 19h
        jge short .1
        lea eax, [nosplit edx*4+00h]
        add eax, edx
        shl eax, 4
        add eax, ebx
        add eax, eax
        mov dword [DebugLineWidth], eax
.1:
        lea eax, [dword esp+0118h]
        mov dword [dword esp+0100h], eax
        lea ebx, [dword esp+0100h]
        mov edx, dword [dword esp+0114h]
        mov eax, esp
        call vsprintf_
        xor esi, esi
        mov dword [dword esp+0100h], esi
        mov eax, esp
        call DebugShowLines
.2:
        add esp, 104h
        pop esi
        ret
DebugShowLinesJumpTable:                        ; jump table for the switch cases of DebugShowLines
        dd DebugShowLines+0BCh
        dd DebugShowLines+0E8h
        dd DebugShowLines+0125h
        dd DebugShowLines+014Ch
        dd DebugShowLines+0158h
;-----------------------------------------------------------------------------
; DebugShowLines                               936C0  95 PC, medium confidence
; Writes a string to the debug monitor handling control characters and
; scrolling
;-----------------------------------------------------------------------------
DebugShowLines:
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
        jle near .6
.1:
        cmp byte [esp], 0Eh
        jne short .2
        xor eax, eax
        mov al, byte [esi]
        push eax
        call DebugSetAttr
        add esp, byte 4
        xor bh, bh
        mov byte [esp], bh
        jmp near .5
.2:
        mov al, byte [esi]
        mov byte [esp], al
        cmp al, 20h
        jb short .3
        call DebugScrollUp
        xor dh, dh
        mov dl, byte [DebugBackColor]
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
        jl short .1
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        sub al, 8
        cmp al, 4
        ja near .5
        and eax, 0FFh
        lea ebx, [nosplit eax*4+00h]
        mov eax, dword [DebugLineWidth]
        mov edx, eax
        sar edx, 1Fh
        mov ecx, 0A0h
        idiv ecx
        jmp dword [dword cs:ebx+DebugShowLinesJumpTable]
        mov ebx, dword [DebugLineWidth]
        cmp ebx, byte 2
        jl near .5
        lea ecx, [byte ebx-02h]
        mov dword [DebugLineWidth], ecx
        inc esi
        inc edi
        cmp edi, ebp
        jl near .1
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        cmp byte [DebugTabWidth], 1
        jbe near .5
        imul ebx, eax, dword 0A0h
        mov edx, dword [DebugLineWidth]
        sub edx, ebx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edx, eax
        xor ecx, ecx
        mov cl, byte [DebugTabWidth]
        sar edx, 1Fh
        idiv ecx
        inc eax
        imul eax, ecx
        add eax, eax
        add eax, ebx
        jmp short .4
        inc eax
        mov dword [DebugLineWidth], eax
        imul eax, ecx
        mov dword [DebugLineWidth], eax
        call DebugScrollUp
        inc esi
        inc edi
        cmp edi, ebp
        jl near .1
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        xor eax, eax
        mov al, byte [DebugRow]
        imul eax, ecx
        jmp short .4
        call DebugClearScreen
        xor eax, eax
        mov al, byte [DebugRow]
        imul eax, dword 0A0h
.4:
        mov dword [DebugLineWidth], eax
.5:
        inc esi
        inc edi
        cmp edi, ebp
        jl near .1
.6:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
;-----------------------------------------------------------------------------
; DebugScrollUp                                93844  95 PC, medium confidence
; Scrolls the debug monochrome screen up a line
;-----------------------------------------------------------------------------
DebugScrollUp:
        push ebx
        push ecx
        push edx
        cmp dword [DebugLineWidth], 0FA0h
        jl short .1
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
.1:
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; DebugClearScreen                             938C8  95 PC, medium confidence
; Clears the debug monochrome screen
;-----------------------------------------------------------------------------
DebugClearScreen:
        mov ebx, dword [DebugScreenBase]
        cmp dword [DebugMode], byte 2
        jl short .2
        xor eax, eax
.1:
        mov dword [ebx+eax], 0
        add eax, byte 4
        cmp eax, 0FA0h
        jl short .1
.2:
        mov dword [DebugScreenBase], ebx
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; DebugSetRow                                  938F4  95 PC, medium confidence
; Sets the debug screen's output row (0 to 24)
;-----------------------------------------------------------------------------
DebugSetRow:
        mov eax, dword [byte esp+04h]
        test eax, eax
        jl short .1
        cmp eax, byte 18h
        jg short .1
        mov byte [DebugRow], al
.1:
        ret
        db 090h
;-----------------------------------------------------------------------------
; DebugSetAttr                                 93908  95 PC, medium confidence
; Sets the debug screen's text attribute
;-----------------------------------------------------------------------------
DebugSetAttr:
        mov al, byte [byte esp+04h]
        mov byte [DebugBackColor], al
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; DebugSetTabWidth                                93914  95 PC, low confidence
; Sets the debug monitor tab width when it is at least 1
;-----------------------------------------------------------------------------
DebugSetTabWidth:
        mov eax, dword [byte esp+04h]
        cmp eax, byte 1
        jl short .1
        mov byte [DebugTabWidth], al
.1:
        ret
        db 090h
;-----------------------------------------------------------------------------
; DebugSetPage                                    93924  95 PC, low confidence
; Points the debug monitor at a 32K page of monochrome video memory
;-----------------------------------------------------------------------------
DebugSetPage:
        mov eax, dword [byte esp+04h]
        shl eax, 0Fh
        add eax, 0B0000h
        mov dword [DebugScreenBase], eax
        ret
        db 08Bh,0C0h
