; The high-level sound library. Starting a driver and playing a sample.
bits 32
%include "hockey.inc"
section s_90354 progbits alloc exec nowrite align=1
global ShapeBankCount, ShapeBankEntry, loc_90370, sub_90373, loc_9038D
ShapeBankCount:
        mov ebx, dword [byte esp+04h]
        mov eax, dword [byte ebx+08h]
        ret
ShapeBankEntry:
        mov eax, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov ecx, dword [byte eax+08h]
        LD cmp, ebx, ecx
        jae short loc_90370
        add eax, dword [byte eax+ebx*8+014h]
        ret
loc_90370:
        LD xor, eax, eax
        ret
sub_90373:
        mov ebx, dword [byte esp+04h]
        mov eax, dword [byte esp+08h]
        mov edx, dword [byte esp+0Ch]
        mov ecx, dword [byte ebx+08h]
        LD cmp, eax, ecx
        jae short loc_9038D
        mov eax, dword [byte ebx+eax*8+010h]
        mov dword [edx], eax
        ret
loc_9038D:
        LD xor, eax, eax
        mov dword [edx], eax
        ret
