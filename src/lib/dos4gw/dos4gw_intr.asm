; DOS/4GW glue: intr and _DoINTR, interrupt calls through a register block.
bits 32
%include "hockey.inc"
section s_A18FB progbits alloc exec nowrite align=1
global _DoINTR_, IntrLoadRegs, IntrStubs, __Slash_C_
;-----------------------------------------------------------------------------
; _DoINTR_                                                      A18FB  library
; Run-time library: the intr call helper
;-----------------------------------------------------------------------------
_DoINTR_:
        pusha
        push gs
        push fs
        push es
        push ds
        push edx
        call IntrLoadRegs
        push ebx
        push ds
        push ebp
        mov ebp, esp
        mov ebx, dword [byte ebp+0Ch]
        mov ds, word [byte ebp+010h]
        mov dword [ebx], eax
        pushf
        pop eax
        mov word [byte ebx+024h], ax
        mov dword [byte ebx+08h], ecx
        mov dword [byte ebx+0Ch], edx
        mov dword [byte ebx+014h], esi
        mov dword [byte ebx+018h], edi
        pop dword [byte ebx+010h]
        pop eax
        mov word [byte ebx+01Ch], ax
        pop dword [byte ebx+04h]
        o16 mov word [byte ebx+01Eh], es
        o16 mov word [byte ebx+020h], fs
        o16 mov word [byte ebx+022h], gs
        add esp, byte 8
        pop es
        pop fs
        pop gs
        popa
        ret
;-----------------------------------------------------------------------------
; IntrLoadRegs                                                    A1948  95 PC
; Loads the full register set from a REGPACK and selects the interrupt stub
; to call
;-----------------------------------------------------------------------------
IntrLoadRegs:
        and eax, 0FFh
        lea eax, [eax+eax*2]
        db 02Eh,08Dh,080h
        dd IntrStubs
        push eax
        mov ebx, edx
        push dword [byte ebx+01Ch]
        mov eax, dword [ebx]
        mov ecx, dword [byte ebx+08h]
        mov edx, dword [byte ebx+0Ch]
        mov esi, dword [byte ebx+014h]
        mov edi, dword [byte ebx+018h]
        mov ebp, dword [byte ebx+010h]
        mov es, word [byte ebx+01Eh]
        mov fs, word [byte ebx+020h]
        mov gs, word [byte ebx+022h]
        mov ebx, dword [byte ebx+04h]
        pop ds
        ret
IntrStubs:                                      ; used by IntrLoadRegs, IntrLoadSegRegs
        db 0CDh,00h,0C3h,0CDh,01h,0C3h,0CDh,02h,0C3h,0CCh,090h,0C3h,0CDh,04h,0C3h,0CDh
        db 05h,0C3h,0CDh,06h,0C3h,0CDh,07h,0C3h,0CDh,08h,0C3h,0CDh,09h,0C3h,0CDh,0Ah
        db 0C3h,0CDh,0Bh,0C3h,0CDh,0Ch,0C3h,0CDh,0Dh,0C3h,0CDh,0Eh,0C3h,0CDh,0Fh,0C3h
        db 0CDh,010h,0C3h,0CDh,011h,0C3h,0CDh,012h,0C3h,0CDh,013h,0C3h,0CDh,014h,0C3h,0CDh
        db 015h,0C3h,0CDh,016h,0C3h,0CDh,017h,0C3h,0CDh,018h,0C3h,0CDh,019h,0C3h,0CDh,01Ah
        db 0C3h,0CDh,01Bh,0C3h,0CDh,01Ch,0C3h,0CDh,01Dh,0C3h,0CDh,01Eh,0C3h,0CDh,01Fh,0C3h
        db 0CDh,020h,0C3h,0CDh,021h,0C3h,0CDh,022h,0C3h,0CDh,023h,0C3h,0CDh,024h,0C3h,0CDh
        db 025h,0C3h,0CDh,026h,0C3h,0CDh,027h,0C3h,0CDh,028h,0C3h,0CDh,029h,0C3h,0CDh,02Ah
        db 0C3h,0CDh,02Bh,0C3h,0CDh,02Ch,0C3h,0CDh,02Dh,0C3h,0CDh,02Eh,0C3h,0CDh,02Fh,0C3h
        db 0CDh,030h,0C3h,0CDh,031h,0C3h,0CDh,032h,0C3h,0CDh,033h,0C3h,0CDh,034h,0C3h,0CDh
        db 035h,0C3h,0CDh,036h,0C3h,0CDh,037h,0C3h,0CDh,038h,0C3h,0CDh,039h,0C3h,0CDh,03Ah
        db 0C3h,0CDh,03Bh,0C3h,0CDh,03Ch,0C3h,0CDh,03Dh,0C3h,0CDh,03Eh,0C3h,0CDh,03Fh,0C3h
        db 0CDh,040h,0C3h,0CDh,041h,0C3h,0CDh,042h,0C3h,0CDh,043h,0C3h,0CDh,044h,0C3h,0CDh
        db 045h,0C3h,0CDh,046h,0C3h,0CDh,047h,0C3h,0CDh,048h,0C3h,0CDh,049h,0C3h,0CDh,04Ah
        db 0C3h,0CDh,04Bh,0C3h,0CDh,04Ch,0C3h,0CDh,04Dh,0C3h,0CDh,04Eh,0C3h,0CDh,04Fh,0C3h
        db 0CDh,050h,0C3h,0CDh,051h,0C3h,0CDh,052h,0C3h,0CDh,053h,0C3h,0CDh,054h,0C3h,0CDh
        db 055h,0C3h,0CDh,056h,0C3h,0CDh,057h,0C3h,0CDh,058h,0C3h,0CDh,059h,0C3h,0CDh,05Ah
        db 0C3h,0CDh,05Bh,0C3h,0CDh,05Ch,0C3h,0CDh,05Dh,0C3h,0CDh,05Eh,0C3h,0CDh,05Fh,0C3h
        db 0CDh,060h,0C3h,0CDh,061h,0C3h,0CDh,062h,0C3h,0CDh,063h,0C3h,0CDh,064h,0C3h,0CDh
        db 065h,0C3h,0CDh,066h,0C3h,0CDh,067h,0C3h,0CDh,068h,0C3h,0CDh,069h,0C3h,0CDh,06Ah
        db 0C3h,0CDh,06Bh,0C3h,0CDh,06Ch,0C3h,0CDh,06Dh,0C3h,0CDh,06Eh,0C3h,0CDh,06Fh,0C3h
        db 0CDh,070h,0C3h,0CDh,071h,0C3h,0CDh,072h,0C3h,0CDh,073h,0C3h,0CDh,074h,0C3h,0CDh
        db 075h,0C3h,0CDh,076h,0C3h,0CDh,077h,0C3h,0CDh,078h,0C3h,0CDh,079h,0C3h,0CDh,07Ah
        db 0C3h,0CDh,07Bh,0C3h,0CDh,07Ch,0C3h,0CDh,07Dh,0C3h,0CDh,07Eh,0C3h,0CDh,07Fh,0C3h
        db 0CDh,080h,0C3h,0CDh,081h,0C3h,0CDh,082h,0C3h,0CDh,083h,0C3h,0CDh,084h,0C3h,0CDh
        db 085h,0C3h,0CDh,086h,0C3h,0CDh,087h,0C3h,0CDh,088h,0C3h,0CDh,089h,0C3h,0CDh,08Ah
        db 0C3h,0CDh,08Bh,0C3h,0CDh,08Ch,0C3h,0CDh,08Dh,0C3h,0CDh,08Eh,0C3h,0CDh,08Fh,0C3h
        db 0CDh,090h,0C3h,0CDh,091h,0C3h,0CDh,092h,0C3h,0CDh,093h,0C3h,0CDh,094h,0C3h,0CDh
        db 095h,0C3h,0CDh,096h,0C3h,0CDh,097h,0C3h,0CDh,098h,0C3h,0CDh,099h,0C3h,0CDh,09Ah
        db 0C3h,0CDh,09Bh,0C3h,0CDh,09Ch,0C3h,0CDh,09Dh,0C3h,0CDh,09Eh,0C3h,0CDh,09Fh,0C3h
        db 0CDh,0A0h,0C3h,0CDh,0A1h,0C3h,0CDh,0A2h,0C3h,0CDh,0A3h,0C3h,0CDh,0A4h,0C3h,0CDh
        db 0A5h,0C3h,0CDh,0A6h,0C3h,0CDh,0A7h,0C3h,0CDh,0A8h,0C3h,0CDh,0A9h,0C3h,0CDh,0AAh
        db 0C3h,0CDh,0ABh,0C3h,0CDh,0ACh,0C3h,0CDh,0ADh,0C3h,0CDh,0AEh,0C3h,0CDh,0AFh,0C3h
        db 0CDh,0B0h,0C3h,0CDh,0B1h,0C3h,0CDh,0B2h,0C3h,0CDh,0B3h,0C3h,0CDh,0B4h,0C3h,0CDh
        db 0B5h,0C3h,0CDh,0B6h,0C3h,0CDh,0B7h,0C3h,0CDh,0B8h,0C3h,0CDh,0B9h,0C3h,0CDh,0BAh
        db 0C3h,0CDh,0BBh,0C3h,0CDh,0BCh,0C3h,0CDh,0BDh,0C3h,0CDh,0BEh,0C3h,0CDh,0BFh,0C3h
        db 0CDh,0C0h,0C3h,0CDh,0C1h,0C3h,0CDh,0C2h,0C3h,0CDh,0C3h,0C3h,0CDh,0C4h,0C3h,0CDh
        db 0C5h,0C3h,0CDh,0C6h,0C3h,0CDh,0C7h,0C3h,0CDh,0C8h,0C3h,0CDh,0C9h,0C3h,0CDh,0CAh
        db 0C3h,0CDh,0CBh,0C3h,0CDh,0CCh,0C3h,0CDh,0CDh,0C3h,0CDh,0CEh,0C3h,0CDh,0CFh,0C3h
        db 0CDh,0D0h,0C3h,0CDh,0D1h,0C3h,0CDh,0D2h,0C3h,0CDh,0D3h,0C3h,0CDh,0D4h,0C3h,0CDh
        db 0D5h,0C3h,0CDh,0D6h,0C3h,0CDh,0D7h,0C3h,0CDh,0D8h,0C3h,0CDh,0D9h,0C3h,0CDh,0DAh
        db 0C3h,0CDh,0DBh,0C3h,0CDh,0DCh,0C3h,0CDh,0DDh,0C3h,0CDh,0DEh,0C3h,0CDh,0DFh,0C3h
        db 0CDh,0E0h,0C3h,0CDh,0E1h,0C3h,0CDh,0E2h,0C3h,0CDh,0E3h,0C3h,0CDh,0E4h,0C3h,0CDh
        db 0E5h,0C3h,0CDh,0E6h,0C3h,0CDh,0E7h,0C3h,0CDh,0E8h,0C3h,0CDh,0E9h,0C3h,0CDh,0EAh
        db 0C3h,0CDh,0EBh,0C3h,0CDh,0ECh,0C3h,0CDh,0EDh,0C3h,0CDh,0EEh,0C3h,0CDh,0EFh,0C3h
        db 0CDh,0F0h,0C3h,0CDh,0F1h,0C3h,0CDh,0F2h,0C3h,0CDh,0F3h,0C3h,0CDh,0F4h,0C3h,0CDh
        db 0F5h,0C3h,0CDh,0F6h,0C3h,0CDh,0F7h,0C3h,0CDh,0F8h,0C3h,0CDh,0F9h,0C3h,0CDh,0FAh
        db 0C3h,0CDh,0FBh,0C3h,0CDh,0FCh,0C3h,0CDh,0FDh,0C3h,0CDh,0FEh,0C3h,0CDh,0FFh,0C3h
;-----------------------------------------------------------------------------
; __Slash_C_                                                    A1C7C  library
; C run-time: returns the switch character used to build the COMMAND.COM /C
; argument
;-----------------------------------------------------------------------------
__Slash_C_:
        push ebx
        mov ebx, eax
        test dl, dl
        je short .1
        mov byte [eax], 2Fh
        jmp short .2
.1:
        push edx
        mov ah, 37h
        mov al, 0
        int 21h
        mov al, dl
        mov ah, 0
        pop edx
        mov byte [ebx], al
.2:
        mov byte [byte ebx+01h], 63h
        mov eax, ebx
        mov byte [byte ebx+02h], 0
        pop ebx
        ret
