; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_A18D6 progbits alloc exec nowrite align=1
extern IntrStubs
global IntrLoadSegRegs
;-----------------------------------------------------------------------------
; IntrLoadSegRegs                              A18D6  95 PC, medium confidence
; Loads the register set and segment registers for a protected-mode interrupt
; call
;-----------------------------------------------------------------------------
IntrLoadSegRegs:
        lea esi, [esi+esi*2]
        lea eax, [dword cs:esi+IntrStubs]
        push eax
        mov es, word [ebx]
        mov bp, word [byte ebx+06h]
        mov eax, dword [edi]
        mov ebx, dword [byte edi+04h]
        mov ecx, dword [byte edi+08h]
        mov edx, dword [byte edi+0Ch]
        mov esi, dword [byte edi+010h]
        mov edi, dword [byte edi+014h]
        mov ds, ebp
        ret
