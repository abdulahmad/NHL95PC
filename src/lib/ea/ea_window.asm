; On-screen windows.
bits 32
%include "hockey.inc"
section s_8E7A0 progbits alloc exec nowrite align=1
extern str_SUBWINDOW, str_SubwindowdefadrOUTOFROW, TextFirstChar, byte_D42C1, TextCharW, TextCharH, TextSpacing, TextFontH
extern TextFontAscent, dword_D42AC, TextOriginX, dword_D42B4, TextShadowOn, TextFontTag, TextWidthTable, TextCursorX
extern TextCursorY, dword_D42D4, TextTop, TextRight, TextBottom, FatalError, fontcolor, TextFont
extern AllocMemBlock, AllocMemBlockEx, FindCachedFile, FillRowTable, LoadFileCached, DosOpenFile, DosCloseFile, DosReadFile
extern ZeroMem
global subwindowdefadr, LoadFileCachedQuiet, LoadBank, LoadFileCachedFlag, str_LocateshapeSHAPENOTFOUND, OpenArtArchiveErr, OpenArtArchive, OpenArtArchiveFlag
global LoadDataFileErr, LoadFileAllocQuiet, LoadDataFileExt, TextSetColors, TextSetCursor, TextSaveState, TextRestoreState, TextSetFont
subwindowdefadr:
        push esi
        push edi
        push ebp
        mov ebp, dword [byte esp+010h]
        push byte 0
        push byte 30h
        push str_SUBWINDOW
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        mov edi, eax
        push byte 30h
        push eax
        call ZeroMem
        add esp, byte 8
        mov eax, dword [byte esp+01Ch]
        mov dword [byte esi+020h], eax
        mov dword [byte esi+010h], eax
        mov dword [byte esi+01Ch], eax
        mov eax, dword [byte esp+020h]
        mov dword [byte esi+04h], eax
        mov dword [byte esi+014h], eax
        mov eax, dword [byte ebp+00h]
        mov dword [esi], eax
        mov eax, dword [byte ebp+02Ch]
        mov dword [byte esi+02Ch], eax
        mov edx, dword [byte esp+018h]
        mov eax, dword [byte ebp+028h]
        mov eax, dword [eax+edx*4]
        add eax, dword [byte esp+014h]
        mov edx, dword [esi]
        mov ebx, dword [byte esp+020h]
        call FillRowTable
        mov dword [byte esi+028h], eax
        test eax, eax
        jne short .1
        push str_SubwindowdefadrOUTOFROW
        call FatalError
        add esp, byte 4
.1:
        mov eax, edi
        pop ebp
        pop edi
        pop esi
        ret
LoadFileCachedQuiet:
        push ebp
        LD mov, ebp, esp
        LD xor, eax, eax
        jmp short .1
        push ebp
        LD mov, ebp, esp
        mov eax, 1
.1:
        push eax
        push dword [byte ebp+0Ch]
        db 0FFh,075h,08h                        ; insn: push dword [ebp+8]
        db 0E8h                                 ; insn: call 00098E50h
        dd LoadFileCached-$-4
        add esp, byte 0Ch
        leave
        ret
LoadBank:
        push ebp
        LD mov, ebp, esp
        mov eax, 1
        jmp short .1
        push ebp
        LD mov, ebp, esp
        LD xor, eax, eax
        jmp short .1
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+010h]
.1:
        push eax
        push dword [byte ebp+0Ch]
        push dword [byte ebp+08h]
        call LoadFileCached
        add esp, byte 0Ch
        LD or, eax, eax
        je short .2
        mov eax, dword [eax]
.2:
        leave
        ret
LoadFileCachedFlag:
        jmp near LoadFileCached
        db 00h
str_LocateshapeSHAPENOTFOUND:
        db 06Ch,06Fh,063h,061h,074h,065h,073h,068h,061h,070h,065h,020h,02Dh,020h,027h,025h
        db 02Dh,034h,02Eh,034h,073h,027h,020h,053h,048h,041h,050h,045h,020h,04Eh,04Fh,054h
        db 020h,046h,04Fh,055h,04Eh,044h,0Dh,0Ah,00h,00h,00h,00h,00h,00h,00h,00h
OpenArtArchiveErr:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call OpenArtArchiveFlag
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
OpenArtArchive:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call OpenArtArchiveFlag
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
OpenArtArchiveFlag:
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        mov ecx, dword [byte esp+0Ch]
        push ecx
        call LoadDataFileExt
        add esp, byte 0Ch
        test eax, eax
        je short .1
        mov eax, dword [eax]
.1:
        ret
        db 08Bh,0C0h
LoadDataFileErr:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call LoadDataFileExt
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
LoadFileAllocQuiet:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call LoadDataFileExt
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
LoadDataFileExt:
        push esi
        push edi
        sub esp, byte 0Ch
        mov esi, dword [byte esp+018h]
        push esi
        call FindCachedFile
        add esp, byte 4
        test eax, eax
        jne near .3
        mov edx, dword [byte esp+020h]
        push edx
        lea eax, [byte esp+0Ch]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        push esi
        call DosOpenFile
        add esp, byte 14h
        mov ebx, dword [byte esp+08h]
        test ebx, ebx
        jne short .1
        xor eax, eax
        jmp short .3
.1:
        mov ecx, dword [byte esp+020h]
        push ecx
        mov edi, dword [byte esp+020h]
        push edi
        push ebx
        push esi
        call AllocMemBlockEx
        mov esi, eax
        add esp, byte 10h
        test eax, eax
        jne short .2
        mov esi, dword [esp]
        push esi
        call DosCloseFile
        add esp, byte 4
        xor eax, eax
        add esp, byte 0Ch
        pop edi
        pop esi
        ret
.2:
        mov eax, dword [byte esp+08h]
        push eax
        mov edx, dword [esi]
        push edx
        mov ebx, dword [byte esp+08h]
        push ebx
        call DosReadFile
        add esp, byte 0Ch
        mov ecx, dword [esp]
        push ecx
        call DosCloseFile
        add esp, byte 4
        mov eax, esi
.3:
        add esp, byte 0Ch
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h
TextSetColors:
        mov eax, dword [byte esp+04h]
        mov dword [fontcolor], eax
        mov eax, dword [byte esp+08h]
        mov dword [dword_D42AC], eax
        ret
        db 090h
TextSetCursor:
        mov eax, dword [byte esp+04h]
        mov dword [TextOriginX], eax
        mov eax, dword [byte esp+08h]
        mov dword [dword_D42B4], eax
        ret
        db 090h
TextSaveState:
        push esi
        push edi
        mov ecx, 10h
        mov edi, dword [byte esp+0Ch]
        mov esi, TextFont
        rep movsd
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
TextRestoreState:
        push esi
        push edi
        mov ecx, 10h
        mov edi, TextFont
        mov esi, dword [byte esp+0Ch]
        rep movsd
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
TextSetFont:
        mov edx, dword [byte esp+04h]
        mov eax, edx
        mov dword [TextFont], edx
        mov ebx, dword [edx]
        mov dword [TextFontTag], ebx
        mov bl, byte [byte edx+04h]
        mov byte [TextFirstChar], bl
        mov bl, byte [byte edx+05h]
        mov byte [byte_D42C1], bl
        mov bl, byte [byte edx+06h]
        mov byte [TextCharW], bl
        mov bl, byte [byte edx+07h]
        mov byte [TextCharH], bl
        mov bl, byte [byte edx+08h]
        mov byte [TextSpacing], bl
        mov bl, byte [byte edx+09h]
        mov byte [TextFontH], bl
        mov bl, byte [byte edx+0Ah]
        mov byte [TextFontAscent], bl
        xor ebx, ebx
        mov dword [TextShadowOn], ebx
        mov ebx, dword [byte edx+010h]
        sar ebx, 10h
        test ebx, ebx
        je short .1
        add edx, ebx
        jmp short .2
.1:
        xor edx, edx
.2:
        mov dword [TextWidthTable], edx
        mov edx, dword [byte eax+014h]
        shl edx, 10h
        sar edx, 10h
        test edx, edx
        je short .3
        add edx, eax
.3:
        mov dword [TextCursorX], edx
        mov edx, dword [byte eax+014h]
        sar edx, 10h
        test edx, edx
        je short .4
        add edx, eax
.4:
        mov dword [TextCursorY], edx
        mov edx, dword [byte eax+018h]
        shl edx, 10h
        sar edx, 10h
        test edx, edx
        je short .5
        add edx, eax
.5:
        mov dword [dword_D42D4], edx
        mov edx, dword [byte eax+018h]
        sar edx, 10h
        test edx, edx
        je short .6
        add edx, eax
.6:
        mov dword [TextTop], edx
        mov edx, dword [byte eax+01Ch]
        lea ebx, [eax+edx]
        mov dword [TextRight], ebx
        add eax, byte 20h
        mov dword [TextBottom], eax
        ret
