; The EA debug console.
bits 32
%include "hockey.inc"
section s_93938 progbits alloc exec nowrite align=1
extern _dos_getdate_, _dos_gettime_, ClearScreen, DebugLogOn, DebugMode, DebugShowLines, fclose_, FindFirstFile
extern fopen_, fputs_, j___fprtf_, PollHotkeys, ReturnFalse, sprintf_, str_2d02d02d, str_Apr2
extern str_Asterisks, str_Aug2, str_CLOSED, str_DATES, str_DateStampFmt, str_DBUGTXT, str_Dec2, str_Feb3
extern str_FILES, str_Fs, str_Jan2, str_Jul2, str_Jun2, str_Mar2, str_May3, str_Nov2
extern str_Oct2, str_Sep2, str_TIMES, str_TIMES2, str_Wt2, ToUpperChar, vsprintf_
global DebugLogOpen, DebugLogClose, DebugLog, DebugLogPrintf, FindWildcardDigits, FormatDateStamp, MemMapRulePtr, MonthNameTable
global DebugWaitKey, DebugGetKey
;-----------------------------------------------------------------------------
; DebugLogOpen                                    93938  95 PC, low confidence
; Opens the debug log file unless it is already open
;-----------------------------------------------------------------------------
DebugLogOpen:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, 0B0h
        cmp dword [DebugLogOn], byte 0
        jne near .7
        mov esi, eax
        mov edi, esp
        push edi
.1:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je short .2
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short .1
.2:
        pop edi
        mov edi, esp
        sub ecx, ecx
        dec ecx
        xor eax, eax
        repne scasb
        not ecx
        dec ecx
        test cx, cx
        jle short .3
        movsx eax, cx
        mov dl, byte [byte esp+eax-01h]
        cmp dl, 5Ch
        je short .3
        cmp dl, 3Ah
        je short .3
        mov byte [esp+eax], 5Ch
        xor bh, bh
        mov byte [byte esp+eax+01h], bh
.3:
        mov esi, str_DBUGTXT
        mov edi, esp
        push edi
        LD sub, ecx, ecx
        dec ecx
        mov al, 0
        repne scasb
        dec edi
.4:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je short .5
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short .4
.5:
        pop edi
        mov eax, esp
        call FindWildcardDigits
        mov edx, str_Wt2
        mov eax, esp
        call fopen_
        mov dword [DebugLogOn], eax
        test eax, eax
        je short .6
        lea edx, [dword esp+09Ch]
        lea eax, [dword esp+088h]
        call FormatDateStamp
        mov eax, esp
        push eax
        push str_FILES
        call DebugLog
        add esp, byte 8
        lea eax, [dword esp+088h]
        push eax
        push str_DATES
        call DebugLog
        add esp, byte 8
        lea eax, [dword esp+09Ch]
        push eax
        push str_TIMES
        call DebugLog
        add esp, byte 8
        jmp short .7
.6:
        call fclose_
.7:
        add esp, 0B0h
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
;-----------------------------------------------------------------------------
; DebugLogClose                                93A40  95 PC, medium confidence
; Writes the closing date and time to the debug log and closes it
;-----------------------------------------------------------------------------
DebugLogClose:
        push ebx
        push ecx
        push edx
        sub esp, byte 28h
        cmp dword [DebugLogOn], byte 0
        je short .1
        mov edx, esp
        lea eax, [byte esp+014h]
        call FormatDateStamp
        push str_CLOSED
        call DebugLog
        add esp, byte 4
        lea eax, [byte esp+014h]
        push eax
        push str_DATES
        call DebugLog
        add esp, byte 8
        mov eax, esp
        push eax
        push str_TIMES2
        call DebugLog
        add esp, byte 8
        mov eax, dword [DebugLogOn]
        call fclose_
        xor ebx, ebx
        mov dword [DebugLogOn], ebx
.1:
        add esp, byte 28h
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; DebugLog                                     93AA4  95 PC, medium confidence
; Prints a formatted line to the debug log file when the debug level is 2 or
; more
;-----------------------------------------------------------------------------
DebugLog:
        sub esp, byte 4
        cmp dword [DebugMode], byte 2
        jl short .1
        mov ebx, dword [DebugLogOn]
        test ebx, ebx
        je short .1
        lea eax, [byte esp+0Ch]
        mov dword [esp], eax
        mov eax, ebx
        mov ebx, esp
        mov edx, dword [byte esp+08h]
        call j___fprtf_
        xor ecx, ecx
        mov dword [esp], ecx
.1:
        add esp, byte 4
        ret
        db 090h
;-----------------------------------------------------------------------------
; DebugLogPrintf                               93AD8  95 PC, medium confidence
; Formats a line with vsprintf and writes it to the debug log
;-----------------------------------------------------------------------------
DebugLogPrintf:
        sub esp, 104h
        cmp dword [DebugMode], byte 2
        jl short .2
        lea eax, [dword esp+010Ch]
        mov dword [dword esp+0100h], eax
        lea ebx, [dword esp+0100h]
        mov edx, dword [dword esp+0108h]
        mov eax, esp
        call vsprintf_
        xor ebx, ebx
        mov dword [dword esp+0100h], ebx
        mov ecx, dword [DebugLogOn]
        test ecx, ecx
        je short .1
        mov edx, ecx
        mov eax, esp
        call fputs_
.1:
        mov eax, esp
        call DebugShowLines
.2:
        add esp, 104h
        ret
;-----------------------------------------------------------------------------
; FindWildcardDigits                           93B34  95 PC, medium confidence
; Finds the run of ? characters in a file name pattern
;-----------------------------------------------------------------------------
FindWildcardDigits:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov dword [esp], eax
        xor edi, edi
        mov esi, eax
        cmp byte [eax], 3Fh
        je short .2
.1:
        cmp byte [esi], 0
        je short .2
        inc esi
        inc edi
        cmp byte [esi], 3Fh
        jne short .1
.2:
        mov ebp, dword [esp]
        add ebp, edi
        cmp byte [byte ebp+00h], 0
        je short .3
        cmp byte [byte ebp+01h], 3Fh
        je short .4
.3:
        xor eax, eax
        jmp short .8
.4:
        xor esi, esi
.5:
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        mov ebx, 0Ah
        idiv ebx
        add eax, byte 30h
        mov byte [byte ebp+00h], al
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        add edx, byte 30h
        mov byte [byte ebp+01h], dl
        mov edx, dword [esp]
        push edx
        call FindFirstFile
        add esp, byte 4
        test eax, eax
        je short .6
        inc esi
        cmp esi, byte 64h
        jl short .5
.6:
        cmp esi, byte 64h
        jl short .7
        add edi, dword [esp]
        mov byte [byte edi+01h], 78h
        mov al, byte [byte edi+01h]
        mov byte [edi], al
        mov eax, 2
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.7:
        mov eax, 1
.8:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; FormatDateStamp                              93BD4  95 PC, medium confidence
; Formats the current DOS date and time as a short stamp
;-----------------------------------------------------------------------------
FormatDateStamp:
        push ebx
        push ecx
        push esi
        sub esp, byte 0Ch
        mov ebx, eax
        mov ecx, edx
        mov eax, esp
        call _dos_getdate_
        lea eax, [byte esp+08h]
        call _dos_gettime_
        xor edx, edx
        mov dx, word [byte esp+02h]
        mov esi, 64h
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        push edx
        xor eax, eax
        mov al, byte [byte esp+05h]
        mov edx, dword [nosplit eax*4+DebugLogOn]
        push edx
        xor eax, eax
        mov al, byte [byte esp+08h]
        push eax
        push str_DateStampFmt
        push ebx
        call sprintf_
        add esp, byte 14h
        xor eax, eax
        mov al, byte [byte esp+0Ah]
        push eax
        xor eax, eax
        mov al, byte [byte esp+0Dh]
        push eax
        xor eax, eax
        mov al, byte [byte esp+010h]
        push eax
        push str_2d02d02d
        push ecx
        call sprintf_
        add esp, byte 14h
        add esp, byte 0Ch
        pop esi
        pop ecx
        pop ebx
        ret
        db 00h
MemMapRulePtr:                                  ; used by DumpShapesList, WriteMemMap
        dd str_Asterisks
MonthNameTable:                                 ; used by FormatDateTime
        dd str_Fs
        dd str_Jan2
        dd str_Feb3
        dd str_Mar2
        dd str_Apr2
        dd str_May3
        dd str_Jun2
        dd str_Jul2
        dd str_Aug2
        dd str_Sep2
        dd str_Oct2
        dd str_Nov2
        dd str_Dec2
;-----------------------------------------------------------------------------
; DebugWaitKey                                    93C88  95 PC, low confidence
; Waits for a key in the debug viewers and returns it in upper case
;-----------------------------------------------------------------------------
DebugWaitKey:
        push ebx
        push ecx
        push edx
        call PollHotkeys
        push eax
        call ToUpperChar
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; DebugGetKey                                  93CA0  95 PC, medium confidence
; Debug viewers: polls the hotkeys and returns the key pressed in upper case
;-----------------------------------------------------------------------------
DebugGetKey:
        push ebx
        push ecx
        push edx
        push eax
        call ClearScreen
        add esp, byte 4
        call ReturnFalse
        pop edx
        pop ecx
        pop ebx
        ret
