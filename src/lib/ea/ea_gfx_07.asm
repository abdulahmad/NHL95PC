; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_91CE7 progbits alloc exec nowrite align=1
extern __doopen_, close_file_
global freopen_
;-----------------------------------------------------------------------------
; freopen_                                                        91CE7  95 PC
; Run-time library freopen: closes a stream and opens a file on it again
;-----------------------------------------------------------------------------
freopen_:
        push ecx
        push esi
        mov esi, eax
        mov eax, ebx
        call close_file_
        mov ecx, eax
        test eax, eax
        je short .1
        and dword [byte eax+0Ch], 4000h
        mov eax, esi
        xor ebx, ebx
        call __doopen_
.1:
        pop esi
        pop ecx
        ret
