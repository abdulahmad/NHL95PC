; Watcom floating-point emulator.
bits 32
%include "hockey.inc"
section s_A3274 progbits alloc exec nowrite align=1
extern __GETDS, _dos_setvect_, str_RATIONALDOS4G, Hook387Flag, Hook387Saved, FpeHandler, EmuTrapFrame, Hook387Save
global unk_A3274, unk_A3278, unk_A327C, EmuRegRing, EmuRegLastSlot, EmuRegSlots, EmuRegTagMasks, unk_A32D0
global unk_A32D4, unk_A32D6, EmuCompareCcBits, unk_A3322, EmuEaModRmTable, EmuEaSibTable, EmuOpcodeJumpTable, EmuModRmJumpTable
global __int7_pl3, __int7_X32VM, __int7, EmuTrapExit, RoundToSingle, RoundToDouble, RoundToDouble_32, RoundToDouble_32
global RaiseFpuError, EaEax, EaEcx, EaEdx, EaEbx, EaEsp, EaDisp32, EaEsi
global EaEdi, EaEaxDisp8, EaEcxDisp8, EaEdxDisp8, EaEbxDisp8, EaEspDisp8, EaEbpDisp8, EaEsiDisp8
global EaEdiDisp8, EaEaxDisp32, EaEcxDisp32, EaEdxDisp32, EaEbxDisp32, EaEspDisp32, EaEbpDisp32, EaEsiDisp32
global EaEdiDisp32, EaSib, EmuUnsupported, EmuFaddM32, EmuFmulM32, EmuFcomM32, EmuFcompM32, EmuFsubM32
global EmuFsubrM32, EmuFdivM32, EmuFdivrM32, EmuFldM32, EmuFstM32, EmuFstpM32, EmuFldenv, EmuFldcw
global EmuFstenv, EmuFstcw, EmuFiaddM32, EmuFimulM32, EmuFicomM32, EmuFicompM32, EmuFisubM32, EmuFisubrM32
global EmuFidivM32, EmuFidivrM32, EmuFildM32, EmuFistM32, EmuFistpM32, EmuFaddM64, EmuFmulM64, EmuFcomM64
global EmuFcompM64, EmuFsubM64, EmuFsubrM64, EmuFdivM64, EmuFdivrM64, EmuFldM80, EmuFldM64, EmuFstM64
global EmuFstpM80, EmuFstpM64, EmuFrstor, EmuFsave, EmuFstswM16, EmuFiaddM16, EmuFimulM16, EmuFicomM16
global EmuFicompM16, EmuFisubM16, EmuFisubrM16, EmuFidivM16, EmuFidivrM16, EmuFildM16, EmuFistM16, EmuFistpM16
global EmuFbld, EmuFildM64, EmuFbstp, EmuFistpM64, EmuReservedOp, EmuDispatchD9Reg, EmuDispatchD9RegJumpTable, EmuFaddSt
global EmuFmulSt, EmuFcomSt, EmuFcompSt, EmuFsubSt, EmuFsubrSt, EmuFdivSt, EmuFdivrSt, EmuFldSt
global EmuFxch, EmuFtstFxam, EmuFtstFxamJumpTable, EmuSignOps, EmuSignOpsJumpTable, EmuLogOps, EmuLogOpsJumpTable, EmuRemOps
global EmuRemOpsJumpTable, EmuFucompp, EmuFucomppJumpTable, EmuDispatchDBReg, EmuDispatchDBRegJumpTable, EmuDispatchDBRegJumpTable, EmuFaddToSt, EmuFmulToSt
global EmuFsubrToSt, EmuFsubToSt, EmuFdivrToSt, EmuFdivToSt, EmuFfree, EmuFstSt, EmuFucom, EmuFucomp
global EmuFstpSt, EmuFaddp, EmuFmulp, EmuFcompp, EmuFcomppJumpTable, EmuFsubrp, EmuFsubp, EmuFdivrp
global EmuFdivp, EmuDispatchDFReg, EmuDispatchDFRegJumpTable, EmuDispatchDFRegJumpTable, EmuSub, EmuAdd, AddExtRaw, AddMantissas
global EmuCompare, EmuDiv, DivideMantissas, EmuMul, MultiplyMantissas, StoreM32IntTrunc, StoreM32Int, Emu387LdToInt
global LoadM32Int, Emu387IntToLd, LoadM64Real, StoreM32Real, StoreM64Real, LoadM32Real, EmuMantissaMasks, ExtToInt
global EmuRemPolyCoefs, EmuRemainder, RemainderStep, EmuRoundInt, RoundMantissa, EmuExamine, EmuLog2PolyNum, EmuLog2PolyDen
global AddOne, EmuLog2, Log2Core, EmuSinPolyCoefs, EmuCosPolyCoefs, EmuSinCosTermCounts, SinCosCore, EmuSin
global EmuCos, EmuTan, EmuTan_E, EmuAtan, EmuExp2, PolyEvalExt, PolyEval, PolyEvalOdd
global __hook387, __unhook387, EmuNoOp, __init_80x87
unk_A3274:
        db 00h,00h,00h,00h
unk_A3278:
        db 00h,00h,00h,00h
unk_A327C:
        db 00h,00h
EmuRegRing:
        db 0Ah,00h
EmuRegLastSlot:
        db 046h,00h
EmuRegSlots:
        db 00h,00h,00h,00h,00h,00h,014h,00h,00h,00h,00h,08h,01h,00h,00h,00h
        db 01Eh,00h,0Ah,00h,00h,010h,02h,00h,00h,00h,028h,00h,014h,00h,00h,018h
        db 03h,00h,00h,00h,032h,00h,01Eh,00h,00h,020h,04h,00h,00h,00h,03Ch,00h
        db 028h,00h,00h,028h,05h,00h,00h,00h,046h,00h,032h,00h,00h,030h,06h,00h
        db 00h,00h,00h,00h,03Ch,00h,00h,038h,07h,00h,00h,00h
EmuRegTagMasks:
        db 0FCh,0FFh
unk_A32D0:
        db 01h,00h,00h,00h
unk_A32D4:
        db 02h,00h
unk_A32D6:
        db 03h,00h,0F3h,0FFh,04h,00h,00h,00h,08h,00h,0Ch,00h,0CFh,0FFh,010h,00h
        db 00h,00h,020h,00h,030h,00h,03Fh,0FFh,040h,00h,00h,00h,080h,00h,0C0h,00h
        db 0FFh,0FCh,00h,01h,00h,00h,00h,02h,00h,03h,0FFh,0F3h,00h,04h,00h,00h
        db 00h,08h,00h,0Ch,0FFh,0CFh,00h,010h,00h,00h,00h,020h,00h,030h,0FFh,03Fh
        db 00h,040h,00h,00h,00h,080h,00h,0C0h
EmuCompareCcBits:
        db 01h,040h,00h,045h
unk_A3322:
        db 00h,02h,040h,042h,01h,03h,041h,043h,087h,0DBh
EmuEaModRmTable:
        dd EaEax
        dd EaEcx
        dd EaEdx
        dd EaEbx
        dd EaSib
        dd EaDisp32
        dd EaEsi
        dd EaEdi
        dd EaEaxDisp8
        dd EaEcxDisp8
        dd EaEdxDisp8
        dd EaEbxDisp8
        dd EaSib
        dd EaEbpDisp8
        dd EaEsiDisp8
        dd EaEdiDisp8
        dd EaEaxDisp32
        dd EaEcxDisp32
        dd EaEdxDisp32
        dd EaEbxDisp32
        dd EaSib
        dd EaEbpDisp32
        dd EaEsiDisp32
        dd EaEdiDisp32
EmuEaSibTable:
        dd EaEax
        dd EaEcx
        dd EaEdx
        dd EaEbx
        dd EaEsp
        dd EaDisp32
        dd EaEsi
        dd EaEdi
        dd EaEaxDisp8
        dd EaEcxDisp8
        dd EaEdxDisp8
        dd EaEbxDisp8
        dd EaEspDisp8
        dd EaEbpDisp8
        dd EaEsiDisp8
        dd EaEdiDisp8
        dd EaEaxDisp32
        dd EaEcxDisp32
        dd EaEdxDisp32
        dd EaEbxDisp32
        dd EaEspDisp32
        dd EaEbpDisp32
        dd EaEsiDisp32
        dd EaEdiDisp32
EmuOpcodeJumpTable:
        dd EmuFaddM32
        dd EmuFldM32
        dd EmuFiaddM32
        dd EmuFildM32
        dd EmuFaddM64
        dd EmuFldM64
        dd EmuFiaddM16
        dd EmuFildM16
        dd EmuFmulM32
        dd EmuUnsupported
        dd EmuFimulM32
        dd EmuUnsupported
        dd EmuFmulM64
        dd EmuUnsupported
        dd EmuFimulM16
        dd EmuUnsupported
        dd EmuFcomM32
        dd EmuFstM32
        dd EmuFicomM32
        dd EmuFistM32
        dd EmuFcomM64
        dd EmuFstM64
        dd EmuFicomM16
        dd EmuFistM16
        dd EmuFcompM32
        dd EmuFstpM32
        dd EmuFicompM32
        dd EmuFistpM32
        dd EmuFcompM64
        dd EmuFstpM64
        dd EmuFicompM16
        dd EmuFistpM16
        dd EmuFsubM32
        dd EmuFldenv
        dd EmuFisubM32
        dd EmuUnsupported
        dd EmuFsubM64
        dd EmuFrstor
        dd EmuFisubM16
        dd EmuFbld
        dd EmuFsubrM32
        dd EmuFldcw
        dd EmuFisubrM32
        dd EmuFldM80
        dd EmuFsubrM64
        dd EmuUnsupported
        dd EmuFisubrM16
        dd EmuFildM64
        dd EmuFdivM32
        dd EmuFstenv
        dd EmuFidivM32
        dd EmuUnsupported
        dd EmuFdivM64
        dd EmuFsave
        dd EmuFidivM16
        dd EmuFbstp
        dd EmuFdivrM32
        dd EmuFstcw
        dd EmuFidivrM32
        dd EmuFstpM80
        dd EmuFdivrM64
        dd EmuFstswM16
        dd EmuFidivrM16
        dd EmuFistpM64
EmuModRmJumpTable:
        dd EmuFaddSt
        dd EmuFldSt
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuFaddToSt
        dd EmuFfree
        dd EmuFaddp
        dd EmuFfree
        dd EmuFmulSt
        dd EmuFxch
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuFmulToSt
        dd EmuFxch
        dd EmuFmulp
        dd EmuFxch
        dd EmuFcomSt
        dd EmuDispatchD9Reg
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuFcomSt
        dd EmuFstSt
        dd EmuReservedOp
        dd EmuFstSt
        dd EmuFcompSt
        dd EmuFstpSt
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuFcompSt
        dd EmuFstpSt
        dd EmuFcompp
        dd EmuFstpSt
        dd EmuFsubSt
        dd EmuFtstFxam
        dd EmuReservedOp
        dd EmuDispatchDBReg
        dd EmuFsubrToSt
        dd EmuFucom
        dd EmuFsubrp
        dd EmuDispatchDFReg
        dd EmuFsubrSt
        dd EmuSignOps
        dd EmuFucompp
        dd EmuReservedOp
        dd EmuFsubToSt
        dd EmuFucomp
        dd EmuFsubp
        dd EmuReservedOp
        dd EmuFdivSt
        dd EmuLogOps
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuFdivrToSt
        dd EmuReservedOp
        dd EmuFdivrp
        dd EmuReservedOp
        dd EmuFdivrSt
        dd EmuRemOps
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuFdivToSt
        dd EmuReservedOp
        dd EmuFdivp
        dd EmuReservedOp
__int7_pl3:
        sti
        pusha
        LD mov, ebp, esp
        push dword [byte ebp+040h]
        push dword [byte ebp+044h]
        mov cx, word [byte ebp+03Ch]
        mov word [byte ebp-06h], cx
        mov ecx, dword [byte ebp+038h]
        mov dword [byte ebp+0Ch], ecx
        call EmuTrapExit
        pop ds
        pop es
        popa
        iret
        db 087h,0DBh,090h
__int7_X32VM:
        sti
        mov eax, dword [byte esp+0Ch]
        push dword [byte ss:eax+014h]
        push dword [byte ss:eax+010h]
        push eax
        push eax
        push eax
        push dword [ss:eax]
        push ecx
        push edx
        push ebx
        push dword [byte ss:eax+01Ch]
        LD mov, eax, ebp
        push eax
        push esi
        push edi
        push es
        push ds
        mov word [byte esp+02h], ss
        call EmuTrapExit
        pop ds
        pop es
        pop edi
        pop esi
        pop eax
        LD mov, ebp, eax
        pop eax
        pop ebx
        pop edx
        pop ecx
        pop eax
        xchg eax, dword [esp]
        pop dword [ss:eax]
        add esp, byte 8
        pop dword [byte ss:eax+010h]
        add esp, byte 4
        mov eax, dword [ss:eax]
        iret
        db 087h,0DBh
__int7:
        sti
        sub esp, byte 0Ch
        push eax
        LD mov, eax, esp
        add eax, byte 1Ch
        push ecx
        push edx
        push ebx
        push eax
        push ebp
        push esi
        push edi
        push es
        push ds
        mov word [byte esp+02h], ss
        call EmuTrapExit
        pop ds
        pop es
        popa
        add esp, byte 0Ch
        iret
        db 090h
EmuTrapExit:
        LD mov, ebp, esp
        mov esi, dword [byte ebp+038h]
        mov ds, word [byte ebp+03Ch]
        mov cx, word [byte ebp+04h]
        mov dx, word [byte ebp+06h]
        mov al, byte [esi]
        cmp al, 9Bh
        jbe near .3
.1:
        LD mov, bl, al
        and bl, 0F8h
        cmp bl, 0D8h
        jne near .13
        mov ah, byte [byte esi+01h]
        add esi, byte 2
        and al, 7
        cmp ah, 0C0h
        jae near .11
        LD mov, bl, ah
        LD mov, bh, ah
        shr bh, 3
        and ebx, 1807h
        LD or, bl, bh
        mov bh, 0
        call dword [nosplit cs:ebx*4+EmuEaModRmTable]
        mov es, cx
        mov dword [byte ebp+038h], esi
        LD mov, esi, ebx
        LD mov, bl, ah
        and ebx, byte 38h
        LD or, bl, al
        call __GETDS
        lea ebp, [EmuTrapFrame]
        mov edi, dword [byte ds:ebp+04h]
        and edi, 3800h
        shr edi, 0Bh
        lea edi, [edi+edi*4]
        LD add, edi, edi
        jmp dword [nosplit cs:ebx*4+EmuOpcodeJumpTable]
.2:
        mov al, byte [esi]
        cmp al, 9Bh
        ja short .1
.3:
        je short .4
        cmp al, 26h
        je short .8
        cmp al, 2Eh
        je short .5
        cmp al, 36h
        je short .7
        cmp al, 3Eh
        je short .6
        cmp al, 64h
        je short .9
        cmp al, 65h
        je short .10
        cmp al, 66h
        je short .4
        cmp al, 67h
        jne near .1
.4:
        inc esi
        jmp short .2
.5:
        mov cx, word [byte ebp+03Ch]
        LD mov, edx, ecx
        inc esi
        jmp short .2
.6:
        mov cx, word [byte ebp+04h]
        LD mov, edx, ecx
        inc esi
        jmp short .2
.7:
        mov cx, word [byte ebp+06h]
        LD mov, edx, ecx
        inc esi
        jmp short .2
.8:
        mov cx, word [byte ebp+08h]
        LD mov, edx, ecx
        inc esi
        jmp short .2
.9:
        mov cx, fs
        LD mov, edx, ecx
        inc esi
        jmp short .2
.10:
        mov cx, gs
        LD mov, edx, ecx
        inc esi
        jmp short .2
.11:
        mov dword [byte ebp+038h], esi
        call __GETDS
        lea ebp, [EmuTrapFrame]
        LD mov, dl, ah
        and edx, byte 38h
        LD or, dl, al
        mov edi, dword [byte ds:ebp+04h]
        and edi, 3800h
        shr edi, 0Bh
        LD mov, bl, ah
        and ebx, byte 7
        LD mov, esi, ebx
        cmp ax, 0F801h
        jne short .12
        mov si, 1
.12:
        LD add, esi, edi
        and esi, byte 7
        lea edi, [edi+edi*4]
        LD add, edi, edi
        lea esi, [esi+esi*4]
        LD add, esi, esi
        jmp dword [nosplit cs:edx*4+EmuModRmJumpTable]
.13:
        ret
RoundToSingle:
        lea ebx, [byte edi+ebp+01Ch]
        mov edx, 0FFFFFF00h
        mov eax, dword [byte ebx+04h]
        shl eax, 19h
        jae short .2
        jne short .1
        cmp dword [ebx], byte 0
        jne short .1
        LD add, edx, edx
.1:
        add dword [byte ebx+04h], 100h
        jae short .2
        mov dword [byte ebx+04h], 80000000h
        inc word [byte ebx+08h]
.2:
        and dword [byte ebx+04h], edx
        mov dword [ebx], 0
        jmp near EmuTrapExit
RoundToDouble:
        lea ebx, [byte edi+ebp+01Ch]
        mov edx, 0FFFFF800h
        mov eax, dword [ebx]
        shl eax, 16h
        jae short .2
        jne short .1
        LD add, edx, edx
.1:
        add dword [ebx], 800h
        adc dword [byte ebx+04h], byte 0
        jae short .2
        mov dword [byte ebx+04h], 80000000h
        inc word [byte ebx+08h]
.2:
        and dword [ebx], edx
        jmp near EmuTrapExit
RoundToDouble_32:
        inc eax
        mov dx, word [byte ds:ebp+04h]
        and dx, 0B8FFh
        or dh, byte [dword cs:eax+EmuCompareCcBits]
        mov word [byte ds:ebp+04h], dx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+EmuRegRing]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp near EmuTrapExit
        inc eax
        mov dx, word [byte ds:ebp+04h]
        and dx, 0B8FFh
        or dh, byte [dword cs:eax+EmuCompareCcBits]
        mov word [byte ds:ebp+04h], dx
        jmp near EmuTrapExit
RaiseFpuError:
        or byte [byte ds:ebp+04h], al
        test byte [byte ds:ebp+00h], al
        jne short .1
        push esi
        push edi
        push ecx
        push es
        push ds
        sub esp, byte 6Ch
        mov cx, ss
        mov es, cx
        LD mov, esi, ebp
        LD mov, edi, esp
        mov ecx, 1Bh
        cld
        rep movsd
        movzx eax, ah
        call dword [FpeHandler]
        mov cx, ds
        mov es, cx
        mov cx, ss
        mov ds, cx
        LD mov, edi, ebp
        LD mov, esi, esp
        mov ecx, 1Bh
        cld
        rep movsd
        add esp, byte 6Ch
        pop ds
        pop es
        pop ecx
        pop edi
        pop esi
.1:
        ret
EaEax:
        LD xor, ebx, ebx
        add ebx, dword [byte ebp+028h]
        ret
EaEcx:
        LD xor, ebx, ebx
        add ebx, dword [byte ebp+024h]
        ret
EaEdx:
        LD xor, ebx, ebx
        add ebx, dword [byte ebp+020h]
        ret
EaEbx:
        LD xor, ebx, ebx
        add ebx, dword [byte ebp+01Ch]
        ret
EaEsp:
        LD xor, ebx, ebx
        add ebx, dword [byte ebp+018h]
        LD mov, ecx, edx
        ret
EaDisp32:
        mov ebx, dword [esi]
        add esi, byte 4
        ret
EaEsi:
        LD xor, ebx, ebx
        add ebx, dword [byte ebp+010h]
        ret
EaEdi:
        LD xor, ebx, ebx
        add ebx, dword [byte ebp+0Ch]
        ret
EaEaxDisp8:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+028h]
        ret
EaEcxDisp8:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+024h]
        ret
EaEdxDisp8:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+020h]
        ret
EaEbxDisp8:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+01Ch]
        ret
EaEspDisp8:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+018h]
        LD mov, ecx, edx
        ret
EaEbpDisp8:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+014h]
        LD mov, ecx, edx
        ret
EaEsiDisp8:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+010h]
        ret
EaEdiDisp8:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+0Ch]
        ret
EaEaxDisp32:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+028h]
        ret
EaEcxDisp32:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+024h]
        ret
EaEdxDisp32:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+020h]
        ret
EaEbxDisp32:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+01Ch]
        ret
EaEspDisp32:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+018h]
        LD mov, ecx, edx
        ret
EaEbpDisp32:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+014h]
        LD mov, ecx, edx
        ret
EaEsiDisp32:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+010h]
        ret
EaEdiDisp32:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+0Ch]
        ret
EaSib:
        mov bl, byte [esi]
        inc esi
        push ebx
        and bl, 7
        LD mov, bh, ah
        shr bh, 3
        and bh, 18h
        LD or, bl, bh
        mov bh, 0
        call dword [nosplit cs:ebx*4+EmuEaSibTable]
        pop edx
        push ecx
        LD mov, ecx, edx
        and dl, 38h
        cmp dl, 20h
        je short .1
        shr edx, 1
        neg edx
        mov edx, dword [byte ebp+edx+028h]
        shr cl, 6
        shl edx, cl
        LD add, ebx, edx
.1:
        pop ecx
        ret
EmuUnsupported:
        jmp near EmuTrapExit
EmuFaddM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuAdd
        jmp dword [byte ds:ebp+076h]
EmuFmulM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuMul
        jmp dword [byte ds:ebp+076h]
EmuFcomM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near RoundToDouble_32+052h
EmuFcompM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near RoundToDouble_32
EmuFsubM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
EmuFsubrM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Real
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
EmuFdivM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
EmuFdivrM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Real
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
EmuFldM32:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov eax, dword [es:esi]
        lea edx, [byte edi+ebp+01Ch]
        call LoadM32Real
        jmp near EmuTrapExit
EmuFstM32:
        lea eax, [byte edi+ebp+01Ch]
        call StoreM32Real
        mov dword [es:esi], eax
        jmp near EmuTrapExit
EmuFstpM32:
        lea eax, [byte edi+ebp+01Ch]
        call StoreM32Real
        mov dword [es:esi], eax
        jmp near RoundToDouble_32+017h
EmuFldenv:
        mov ecx, 7
        push ds
        push es
        mov ax, es
        mov dx, ds
        mov es, dx
        mov ds, ax
        LD mov, edi, ebp
        rep movsd
        pop es
        pop ds
        jmp near EmuTrapExit
EmuFldcw:
        mov ax, word [es:esi]
        mov word [byte ds:ebp+00h], ax
        and ax, 300h
        cmp ax, 300h
        jne short .1
        lea edx, [EmuTrapExit]
        mov dword [byte ds:ebp+076h], edx
        jmp short .3
.1:
        cmp ax, 200h
        jne short .2
        lea edx, [RoundToDouble]
        mov dword [byte ds:ebp+076h], edx
        jmp short .3
.2:
        lea edx, [RoundToSingle]
        mov dword [byte ds:ebp+076h], edx
.3:
        jmp near EmuTrapExit
EmuFstenv:
        mov ecx, 7
        LD mov, ebx, edi
        LD mov, edi, esi
        LD mov, esi, ebp
        rep movsd
        LD mov, edi, ebx
        jmp near EmuTrapExit
EmuFstcw:
        mov ax, word [byte ds:ebp+00h]
        mov word [es:esi], ax
        jmp near EmuTrapExit
EmuFiaddM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuAdd
        jmp dword [byte ds:ebp+076h]
EmuFimulM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuMul
        jmp dword [byte ds:ebp+076h]
EmuFicomM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near RoundToDouble_32+052h
EmuFicompM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near RoundToDouble_32
EmuFisubM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
EmuFisubrM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
EmuFidivM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
EmuFidivrM32:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
EmuFildM32:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov eax, dword [es:esi]
        lea edx, [byte edi+ebp+01Ch]
        call LoadM32Int
        jmp near EmuTrapExit
EmuFistM32:
        lea ebx, [byte edi+ebp+01Ch]
        push dword [ebx]
        push dword [byte ebx+04h]
        push dword [byte ebx+06h]
        lea eax, [byte edi+ebp+01Ch]
        mov dx, word [byte ds:ebp+00h]
        and dx, 0C00h
        call ExtToInt
        lea eax, [byte edi+ebp+01Ch]
        call StoreM32Int
        mov dword [es:esi], eax
        lea ebx, [byte edi+ebp+01Ch]
        pop dword [byte ebx+06h]
        pop dword [byte ebx+04h]
        pop dword [ebx]
        jmp near EmuTrapExit
EmuFistpM32:
        lea eax, [byte edi+ebp+01Ch]
        mov dx, word [byte ds:ebp+00h]
        and dx, 0C00h
        call ExtToInt
        lea eax, [byte edi+ebp+01Ch]
        call StoreM32Int
        mov dword [es:esi], eax
        jmp near RoundToDouble_32+017h
EmuFaddM64:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuAdd
        jmp dword [byte ds:ebp+076h]
EmuFmulM64:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuMul
        jmp dword [byte ds:ebp+076h]
EmuFcomM64:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near RoundToDouble_32+052h
EmuFcompM64:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near RoundToDouble_32
EmuFsubM64:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
EmuFsubrM64:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
EmuFdivM64:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
EmuFdivrM64:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
EmuFldM80:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov eax, dword [es:esi]
        mov dword [byte edi+ebp+01Ch], eax
        mov eax, dword [byte es:esi+04h]
        mov dword [byte edi+ebp+020h], eax
        mov ax, word [byte es:esi+08h]
        mov word [byte edi+ebp+024h], ax
        jmp near EmuTrapExit
EmuFldM64:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte edi+ebp+01Ch]
        call LoadM64Real
        jmp near EmuTrapExit
EmuFstM64:
        lea eax, [byte edi+ebp+01Ch]
        call StoreM64Real
        mov dword [es:esi], eax
        mov dword [byte es:esi+04h], edx
        jmp near EmuTrapExit
EmuFstpM80:
        mov eax, dword [byte edi+ebp+01Ch]
        mov dword [es:esi], eax
        mov eax, dword [byte edi+ebp+020h]
        mov dword [byte es:esi+04h], eax
        mov ax, word [byte edi+ebp+024h]
        mov word [byte es:esi+08h], ax
        jmp near RoundToDouble_32+017h
EmuFstpM64:
        lea eax, [byte edi+ebp+01Ch]
        call StoreM64Real
        mov dword [es:esi], eax
        mov dword [byte es:esi+04h], edx
        jmp near RoundToDouble_32+017h
EmuFrstor:
        mov ecx, 7
        push ds
        push es
        mov ax, es
        mov dx, ds
        mov es, dx
        mov ds, ax
        LD mov, edi, ebp
        rep movsd
        mov ebx, dword [byte es:ebp+04h]
        and ebx, 3800h
        shr ebx, 0Bh
        lea ebx, [ebx+ebx*4]
        LD add, ebx, ebx
        mov ecx, 8
.1:
        lea edi, [byte ebp+ebx+01Ch]
        movsd
        movsd
        movsw
        movzx ebx, word [dword cs:ebx+EmuRegRing]
        loop .1
        pop es
        pop ds
        jmp near EmuTrapExit
EmuFsave:
        mov ecx, 7
        LD mov, ebx, edi
        LD mov, edi, esi
        LD mov, esi, ebp
        rep movsd
        mov ecx, 8
.1:
        lea esi, [byte ebx+ebp+01Ch]
        movsd
        movsd
        movsw
        movzx ebx, word [dword cs:ebx+EmuRegRing]
        loop .1
        LD mov, edi, ebx
        jmp near EmuDispatchDBRegJumpTable+02Ch
EmuFstswM16:
        mov ax, word [byte ds:ebp+04h]
        mov word [es:esi], ax
        jmp near EmuTrapExit
EmuFiaddM16:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuAdd
        jmp dword [byte ds:ebp+076h]
EmuFimulM16:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuMul
        jmp dword [byte ds:ebp+076h]
EmuFicomM16:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near RoundToDouble_32+052h
EmuFicompM16:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near RoundToDouble_32
EmuFisubM16:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
EmuFisubrM16:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
EmuFidivM16:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
EmuFidivrM16:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
EmuFildM16:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov ax, word [es:esi]
        cwde
        lea edx, [byte edi+ebp+01Ch]
        call LoadM32Int
        jmp near EmuTrapExit
EmuFistM16:
        lea ebx, [byte edi+ebp+01Ch]
        push dword [ebx]
        push dword [byte ebx+04h]
        push dword [byte ebx+06h]
        lea eax, [byte edi+ebp+01Ch]
        mov dx, word [byte ds:ebp+00h]
        and dx, 0C00h
        call ExtToInt
        lea eax, [byte edi+ebp+01Ch]
        call StoreM32Int
        LD mov, edx, eax
        cwde
        LD cmp, eax, edx
        je short .1
        mov ax, 8000h
.1:
        mov word [es:esi], ax
        lea ebx, [byte edi+ebp+01Ch]
        pop dword [byte ebx+06h]
        pop dword [byte ebx+04h]
        pop dword [ebx]
        jmp near EmuTrapExit
EmuFistpM16:
        lea eax, [byte edi+ebp+01Ch]
        mov dx, word [byte ds:ebp+00h]
        and dx, 0C00h
        call ExtToInt
        lea eax, [byte edi+ebp+01Ch]
        call StoreM32Int
        LD mov, edx, eax
        cwde
        LD cmp, eax, edx
        je short .1
        mov ax, 8000h
.1:
        mov word [es:esi], ax
        jmp near RoundToDouble_32+017h
EmuFbld:
        jmp near EmuTrapExit
EmuFildM64:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov eax, dword [es:esi]
        lea edx, [byte edi+ebp+01Ch]
        call Emu387IntToLd
        jmp near EmuTrapExit
EmuFbstp:
        jmp near RoundToDouble_32+017h
EmuFistpM64:
        lea eax, [byte edi+ebp+01Ch]
        mov dx, word [byte ds:ebp+00h]
        and dx, 0C00h
        call ExtToInt
        lea eax, [byte edi+ebp+01Ch]
        call Emu387LdToInt
        mov dword [es:esi], eax
        jmp near RoundToDouble_32+017h
EmuReservedOp:
        jmp near EmuTrapExit
EmuDispatchD9Reg:
        jmp dword [nosplit cs:ebx*4+EmuDispatchD9RegJumpTable]
EmuDispatchD9RegJumpTable:
        dd .1
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
.1:
        jmp near EmuTrapExit
EmuFaddSt:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuAdd
        jmp dword [byte ds:ebp+076h]
EmuFmulSt:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuMul
        jmp dword [byte ds:ebp+076h]
EmuFcomSt:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        call EmuCompare
        jmp near RoundToDouble_32+052h
EmuFcompSt:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        call EmuCompare
        jmp near RoundToDouble_32
EmuFsubSt:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
EmuFsubrSt:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
EmuFdivSt:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
EmuFdivrSt:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
EmuFldSt:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov eax, dword [byte esi+ebp+01Ch]
        mov dword [byte edi+ebp+01Ch], eax
        mov eax, dword [byte esi+ebp+020h]
        mov dword [byte edi+ebp+020h], eax
        mov ax, word [byte esi+ebp+024h]
        mov word [byte edi+ebp+024h], ax
        jmp near EmuTrapExit
EmuFxch:
        lea ebx, [byte edi+ebp+01Ch]
        lea esi, [byte esi+ebp+01Ch]
        mov eax, dword [esi]
        xchg eax, dword [ebx]
        mov dword [esi], eax
        mov eax, dword [byte esi+04h]
        xchg eax, dword [byte ebx+04h]
        mov dword [byte esi+04h], eax
        mov ax, word [byte esi+08h]
        xchg ax, word [byte ebx+08h]
        mov word [byte esi+08h], ax
        jmp near EmuTrapExit
EmuFtstFxam:
        jmp dword [nosplit cs:ebx*4+EmuFtstFxamJumpTable]
EmuFtstFxamJumpTable:
        dd .1
        dd .2
        dd EmuReservedOp
        dd EmuReservedOp
        dd .3
        dd .4
        dd EmuReservedOp
        dd EmuReservedOp
.1:
        lea eax, [byte edi+ebp+01Ch]
        xor byte [byte eax+09h], 80h
        jmp near EmuTrapExit
.2:
        lea eax, [byte edi+ebp+01Ch]
        and byte [byte eax+09h], 7Fh
        jmp near EmuTrapExit
.3:
        mov eax, dword [cs:unk_A3274]
        mov dword [byte ds:ebp+06Ch], eax
        mov eax, dword [cs:unk_A3278]
        mov dword [byte ds:ebp+070h], eax
        mov ax, word [cs:unk_A327C]
        mov word [byte ds:ebp+074h], ax
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near RoundToDouble_32+052h
.4:
        lea eax, [byte edi+ebp+01Ch]
        call EmuExamine
        jmp near EmuTrapExit
EmuSignOps:
        jmp dword [nosplit cs:ebx*4+EmuSignOpsJumpTable]
EmuSignOpsJumpTable:
        dd .1
        dd .2
        dd .3
        dd .4
        dd .5
        dd .6
        dd .7
        dd EmuReservedOp
.1:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        LD sub, eax, eax
        mov dword [esi], eax
        mov dword [byte esi+04h], 80000000h
        mov word [byte esi+08h], 3FFFh
        jmp near EmuTrapExit
.2:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        mov dword [esi], 0CD1B8AFEh
        mov dword [byte esi+04h], 0D49A784Bh
        mov word [byte esi+08h], 4000h
        jmp near EmuTrapExit
.3:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        mov dword [esi], 5C17F0BCh
        mov dword [byte esi+04h], 0B8AA3B29h
        mov word [byte esi+08h], 3FFFh
        jmp near EmuTrapExit
.4:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        mov dword [esi], 2168C235h
        mov dword [byte esi+04h], 0C900DAA2h
        mov word [byte esi+08h], 4000h
        jmp near EmuTrapExit
.5:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        mov dword [esi], 0FBCFF799h
        mov dword [byte esi+04h], 9A209A84h
        mov word [byte esi+08h], 3FFDh
        jmp near EmuTrapExit
.6:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        mov dword [esi], 0D1CF79ACh
        mov dword [byte esi+04h], 0B17217F7h
        mov word [byte esi+08h], 3FFEh
        jmp near EmuTrapExit
.7:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        LD sub, eax, eax
        mov dword [esi], eax
        mov dword [byte esi+04h], eax
        mov word [byte esi+08h], ax
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D0]
        or word [byte ds:ebp+08h], bx
        jmp near EmuTrapExit
EmuLogOps:
        jmp dword [nosplit cs:ebx*4+EmuLogOpsJumpTable]
EmuLogOpsJumpTable:
        dd .1
        dd .2
        dd .3
        dd EmuDispatchDFRegJumpTable+020h
        dd EmuDispatchDFRegJumpTable+069h
        dd EmuDispatchDFRegJumpTable+0CEh
        dd .4
        dd .5
.1:
        lea eax, [byte edi+ebp+01Ch]
        call EmuAtan
        jmp dword [byte ds:ebp+076h]
.2:
        lea eax, [byte edi+ebp+01Ch]
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+EmuRegRing]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        lea edx, [byte edi+ebp+01Ch]
        call EmuLog2
        jmp dword [byte ds:ebp+076h]
.3:
        lea eax, [byte edi+ebp+01Ch]
        call EmuTan
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        LD sub, eax, eax
        mov dword [esi], eax
        mov dword [byte esi+04h], 80000000h
        mov word [byte esi+08h], 3FFFh
        jmp near EmuTrapExit
.4:
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp near EmuTrapExit
.5:
        movzx edi, word [dword cs:edi+EmuRegRing]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp near EmuTrapExit
EmuRemOps:
        jmp dword [nosplit cs:ebx*4+EmuRemOpsJumpTable]
EmuRemOpsJumpTable:
        dd .1
        dd .2
        dd .3
        dd .4
        dd EmuDispatchDFRegJumpTable+0F8h
        dd EmuDispatchDFRegJumpTable+0110h
        dd .5
        dd .6
.1:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        call EmuRoundInt
        and eax, byte 7
        mov dx, word [byte ds:ebp+04h]
        and dx, 0B8FFh
        or dh, byte [dword cs:eax+unk_A3322]
        mov word [byte ds:ebp+04h], dx
        jmp dword [byte ds:ebp+076h]
.2:
        lea eax, [byte edi+ebp+01Ch]
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+EmuRegRing]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        lea edx, [byte edi+ebp+01Ch]
        call AddOne
        jmp dword [byte ds:ebp+076h]
.3:
        lea eax, [byte edi+ebp+01Ch]
        call EmuExp2
        jmp dword [byte ds:ebp+076h]
.4:
        lea ebx, [byte edi+ebp+01Ch]
        push dword [ebx]
        push dword [byte ebx+04h]
        push dword [byte ebx+06h]
        lea eax, [byte edi+ebp+01Ch]
        call EmuSin
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        lea ebx, [byte edi+ebp+01Ch]
        pop dword [byte ebx+06h]
        pop dword [byte ebx+04h]
        pop dword [ebx]
        lea eax, [byte edi+ebp+01Ch]
        call EmuCos
        jmp near EmuTrapExit
.5:
        lea eax, [byte edi+ebp+01Ch]
        call EmuSin
        jmp dword [byte ds:ebp+076h]
.6:
        lea eax, [byte edi+ebp+01Ch]
        call EmuCos
        jmp dword [byte ds:ebp+076h]
EmuFucompp:
        jmp dword [nosplit cs:ebx*4+EmuFucomppJumpTable]
EmuFucomppJumpTable:
        dd EmuReservedOp
        dd .1
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
.1:
        mov eax, dword [byte edi+ebp+01Ch]
        mov dword [byte ds:ebp+06Ch], eax
        mov eax, dword [byte edi+ebp+020h]
        mov dword [byte ds:ebp+070h], eax
        mov ax, word [byte edi+ebp+024h]
        mov word [byte ds:ebp+074h], ax
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+EmuRegRing]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        call EmuCompare
        jmp near RoundToDouble_32
EmuDispatchDBReg:
        jmp dword [nosplit cs:ebx*4+EmuDispatchDBRegJumpTable]
EmuDispatchDBRegJumpTable:
        dd EmuReservedOp
        dd EmuReservedOp
        dd .1
        dd EmuDispatchDBRegJumpTable+02Ch
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
.1:
        and word [byte ds:ebp+04h], 7F00h
        jmp near EmuTrapExit
        mov word [byte ds:ebp+00h], 33Fh
        mov word [byte ds:ebp+04h], 0
        mov word [byte ds:ebp+08h], 0FFFFh
        lea edx, [EmuTrapExit]
        mov dword [byte ds:ebp+076h], edx
        LD sub, edi, edi
        jmp near EmuTrapExit
EmuFaddToSt:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuAdd
        jmp dword [byte ds:ebp+076h]
EmuFmulToSt:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuMul
        jmp dword [byte ds:ebp+076h]
EmuFsubrToSt:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
EmuFsubToSt:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
EmuFdivrToSt:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
EmuFdivToSt:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
EmuFfree:
        mov bx, word [dword cs:esi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:esi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        jmp near EmuTrapExit
EmuFstSt:
        mov eax, dword [byte edi+ebp+01Ch]
        mov dword [byte esi+ebp+01Ch], eax
        mov eax, dword [byte edi+ebp+020h]
        mov dword [byte esi+ebp+020h], eax
        mov ax, word [byte edi+ebp+024h]
        mov word [byte esi+ebp+024h], ax
        mov bx, word [dword cs:esi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        jmp near EmuTrapExit
EmuFucom:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        call EmuCompare
        jmp near RoundToDouble_32+052h
EmuFucomp:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        call EmuCompare
        jmp near RoundToDouble_32
EmuFstpSt:
        mov eax, dword [byte edi+ebp+01Ch]
        mov dword [byte esi+ebp+01Ch], eax
        mov eax, dword [byte edi+ebp+020h]
        mov dword [byte esi+ebp+020h], eax
        mov ax, word [byte edi+ebp+024h]
        mov word [byte esi+ebp+024h], ax
        mov bx, word [dword cs:esi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        jmp near RoundToDouble_32+017h
EmuFaddp:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuAdd
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+EmuRegRing]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp dword [byte ds:ebp+076h]
EmuFmulp:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuMul
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+EmuRegRing]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp dword [byte ds:ebp+076h]
EmuFcompp:
        jmp dword [nosplit cs:ebx*4+EmuFcomppJumpTable]
EmuFcomppJumpTable:
        dd EmuReservedOp
        dd .1
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
.1:
        mov eax, dword [byte edi+ebp+01Ch]
        mov dword [byte ds:ebp+06Ch], eax
        mov eax, dword [byte edi+ebp+020h]
        mov dword [byte ds:ebp+070h], eax
        mov ax, word [byte edi+ebp+024h]
        mov word [byte ds:ebp+074h], ax
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+EmuRegRing]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        call EmuCompare
        jmp near RoundToDouble_32
EmuFsubrp:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuSub
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+EmuRegRing]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp dword [byte ds:ebp+076h]
EmuFsubp:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuSub
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+EmuRegRing]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp dword [byte ds:ebp+076h]
EmuFdivrp:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuDiv
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+EmuRegRing]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp dword [byte ds:ebp+076h]
EmuFdivp:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuDiv
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+EmuRegRing]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp dword [byte ds:ebp+076h]
EmuDispatchDFReg:
        jmp dword [nosplit cs:ebx*4+EmuDispatchDFRegJumpTable]
EmuDispatchDFRegJumpTable:
        dd .6
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        dd EmuReservedOp
        lea edx, [byte edi+ebp+01Ch]
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+EmuRegRing]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        lea eax, [byte edi+ebp+01Ch]
        LD mov, ebx, eax
        call EmuRemainder
        jmp dword [byte ds:ebp+076h]
        lea esi, [byte edi+ebp+01Ch]
        movzx edi, word [dword cs:edi+EmuRegLastSlot]
        mov bx, word [dword cs:edi+EmuRegSlots]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+EmuRegTagMasks]
        and word [byte ds:ebp+08h], bx
        lea ebx, [byte edi+ebp+01Ch]
        mov eax, dword [esi]
        mov dword [ebx], eax
        mov eax, dword [byte esi+04h]
        mov dword [byte ebx+04h], eax
        mov ax, word [byte esi+08h]
        LD mov, dx, ax
        and dx, 8000h
        or dx, 3FFFh
        mov word [byte ebx+08h], dx
        and ax, 7FFFh
        sub ax, 3FFFh
        cwde
        LD mov, edx, esi
        call StoreM32Int
        jmp near EmuTrapExit
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        call EmuRoundInt
        and eax, byte 7
        mov dx, word [byte ds:ebp+04h]
        and dx, 0B8FFh
        or dh, byte [dword cs:eax+unk_A3322]
        mov word [byte ds:ebp+04h], dx
        jmp dword [byte ds:ebp+076h]
        lea eax, [byte edi+ebp+01Ch]
        mov dx, word [byte ds:ebp+00h]
        and dx, 0C00h
        call ExtToInt
        jmp near EmuTrapExit
        LD mov, esi, edi
        movzx edi, word [dword cs:edi+EmuRegRing]
        lea eax, [byte edi+ebp+01Ch]
        mov cx, word [byte eax+08h]
        call StoreM32Int
        LD mov, edi, esi
        lea ebx, [byte edi+ebp+01Ch]
        LD mov, edx, eax
        cwde
        LD cmp, eax, edx
        je short .3
        LD or, ch, ch
        jns short .1
        LD sub, dx, dx
        LD sub, cx, cx
        jmp short .2
.1:
        mov dx, 7FFFh
        mov cx, word [byte ebx+08h]
        and cx, 8000h
.2:
        jmp short .5
.3:
        mov dx, word [byte ebx+08h]
        LD mov, cx, dx
        and cx, 8000h
        and dx, 7FFFh
        LD add, dx, ax
        jns short .5
        LD or, ah, ah
        jns short .4
        LD sub, dx, dx
        LD sub, cx, cx
        jmp short .5
.4:
        mov dx, 7FFFh
.5:
        LD or, dx, cx
        mov word [byte ebx+08h], dx
        jmp near EmuTrapExit
.6:
        mov ax, word [byte ds:ebp+04h]
        LD mov, ebp, esp
        mov word [byte ebp+028h], ax
        jmp near EmuTrapExit
EmuSub:
        push esi
        push ecx
        push ebx
        mov si, word [byte edx+08h]
        xor si, 8000h
        jmp short EmuAdd+07h
EmuAdd:
        push esi
        push ecx
        push ebx
        mov si, word [byte edx+08h]
        mov ecx, dword [byte edx+04h]
        mov ebx, dword [edx]
        shl esi, 10h
        mov si, word [byte eax+08h]
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        call AddMantissas
        pop ebx
        mov dword [ebx], eax
        mov dword [byte ebx+04h], edx
        mov word [byte ebx+08h], si
        pop ecx
        pop esi
        ret
AddExtRaw:
        push esi
        push ecx
        push ebx
        mov si, word [byte esp+018h]
        mov ecx, dword [byte esp+014h]
        mov ebx, dword [byte esp+010h]
        shl esi, 10h
        mov si, word [byte eax+08h]
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        call AddMantissas
        pop ebx
        mov dword [ebx], eax
        mov dword [byte ebx+04h], edx
        mov word [byte ebx+08h], si
        pop ecx
        pop esi
        ret 0Ch
AddMantissas:
        LD or, eax, eax
        jne short .3
        LD or, edx, edx
        jne short .3
        LD add, si, si
        jne short .2
        shr esi, 10h
        LD mov, eax, ebx
        LD mov, edx, ecx
        LD add, esi, esi
        LD or, bx, si
        LD or, ebx, edx
        je short .1
        shr esi, 1
.1:
        ret
.2:
        rcr si, 1
.3:
        LD or, ecx, ecx
        jne short .4
        LD or, ebx, ebx
        jne short .4
        test esi, 7FFF0000h
        jne short .4
        ret
.4:
        push ebp
        push edi
        db 087h,0CEh                            ; insn: xchg ecx,esi
        LD mov, edi, ecx
        rol edi, 10h
        sar edi, 10h
        sar ecx, 10h
        and edi, 80007FFFh
        and ecx, 80007FFFh
        LD mov, ebp, ecx
        rol edi, 10h
        rol ecx, 10h
        LD add, cx, di
        rol edi, 10h
        rol ecx, 10h
        LD sub, cx, di
        je short .6
        jae short .5
        LD mov, ebp, edi
        neg cx
        xchg ebx, eax
        db 087h,0D6h                            ; insn: xchg edx,esi
.5:
        cmp cx, byte 40h
        jbe short .6
        LD add, ebp, ebp
        rcr bp, 1
        LD mov, eax, ebx
        LD mov, edx, esi
        LD mov, esi, ebp
        pop edi
        pop ebp
        ret
.6:
        mov ch, 0
        LD or, ecx, ecx
        jns short .7
        mov ch, 0FFh
        neg esi
        neg ebx
        sbb esi, byte 0
        xor ebp, 80000000h
.7:
        LD sub, edi, edi
        cmp cl, 0
        je short .10
        push ebx
        LD sub, ebx, ebx
        cmp cl, 20h
        jb short .9
        LD or, eax, eax
        setne bl
        LD mov, edi, ebx
        LD sub, ebx, ebx
        cmp cl, 40h
        jne short .8
        LD or, edi, edx
        LD sub, edx, edx
.8:
        LD mov, eax, edx
        LD sub, edx, edx
.9:
        shrd ebx, eax, cl
        LD or, edi, ebx
        LD sub, ebx, ebx
        shrd eax, edx, cl
        shrd edx, ebx, cl
        pop ebx
.10:
        LD add, eax, ebx
        LD adc, edx, esi
        adc ch, 0
        jns short .12
        cmp cl, 40h
        jne short .11
        test edi, 7FFFFFFFh
        setne bl
        shr ebx, 1
        adc eax, byte 0
        adc edx, byte 0
        adc ch, 0
.11:
        neg edx
        neg eax
        sbb edx, byte 0
        mov ch, 0
        xor ebp, 80000000h
.12:
        LD mov, ebx, eax
        LD or, bl, ch
        LD or, ebx, edx
        je short .17
        LD or, bp, bp
        je short .18
        cmp ch, 0
        jne short .14
        rol edi, 1
        ror edi, 1
.13:
        dec bp
        je short .18
        LD adc, eax, eax
        LD adc, edx, edx
        jae short .13
.14:
        inc bp
        cmp bp, 7FFFh
        je near .19
        stc
        rcr edx, 1
        rcr eax, 1
        jae short .16
        LD add, edi, edi
        jne short .15
        ror eax, 1
        rol eax, 1
.15:
        adc eax, byte 0
        adc edx, byte 0
        jae short .16
        rcr edx, 1
        rcr eax, 1
        inc bp
        cmp bp, 7FFFh
        je near .19
.16:
        jmp short .18
.17:
        LD mov, ebp, ebx
.18:
        LD add, ebp, ebp
        rcr bp, 1
        LD mov, esi, ebp
        pop edi
        pop ebp
        ret
.19:
        mov bp, 7FFFh
        LD sub, eax, eax
        mov edx, 80000000h
        jmp short .18
EmuCompare:
        push edi
        push esi
        mov si, word [byte eax+08h]
        or si, 8000h
        inc si
        jne short .1
        mov esi, dword [byte eax+04h]
        LD add, esi, esi
        or esi, dword [eax]
        jne short .6
.1:
        mov si, word [byte edx+08h]
        or si, 8000h
        inc si
        jne short .2
        mov esi, dword [byte edx+04h]
        LD add, esi, esi
        or esi, dword [edx]
        jne short .6
.2:
        mov esi, dword [byte eax+06h]
        mov edi, dword [byte edx+06h]
        LD xor, edi, esi
        mov edi, 0
        js short .7
        mov si, word [byte eax+08h]
        cmp si, word [byte edx+08h]
        jne short .3
        mov edi, dword [byte eax+04h]
        cmp edi, dword [byte edx+04h]
        jne short .3
        mov edi, dword [eax]
        cmp edi, dword [edx]
.3:
        mov edi, 0
        je short .5
        rcr eax, 1
        LD xor, esi, eax
.4:
        LD add, esi, esi
        sbb edi, byte 0
        LD add, edi, edi
        inc edi
.5:
        LD mov, eax, edi
        pop esi
        pop edi
        ret
.6:
        mov eax, 2
        pop esi
        pop edi
        ret
.7:
        or edi, dword [eax]
        or edi, dword [edx]
        or edi, dword [byte eax+04h]
        or edi, dword [byte edx+04h]
        mov ax, word [byte eax+08h]
        shl eax, 10h
        mov ax, word [byte edx+08h]
        and eax, 7FFF7FFFh
        LD or, eax, edi
        mov edi, 0
        jne short .4
        pop esi
        pop edi
        ret
EmuDiv:
        push esi
        push ecx
        push ebx
        mov si, word [byte edx+08h]
        mov ecx, dword [byte edx+04h]
        mov ebx, dword [edx]
        shl esi, 10h
        mov si, word [byte eax+08h]
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        call DivideMantissas
        pop ebx
        mov dword [ebx], eax
        mov dword [byte ebx+04h], edx
        mov word [byte ebx+08h], si
        pop ecx
        pop esi
        ret
DivideMantissas:
        LD or, ecx, ecx
        jne short .3
        LD or, ebx, ebx
        jne short .3
        test esi, 7FFF0000h
        jne short .3
        LD or, eax, eax
        jne short .1
        LD or, edx, edx
        jne short .1
        LD mov, eax, esi
        LD add, ax, ax
        jne short .1
        mov al, 1
        mov ah, 81h
        call RaiseFpuError
        mov edx, 0C0000000h
        LD sub, eax, eax
        mov si, 0FFFFh
        jmp short .2
.1:
        mov al, 4
        mov ah, 83h
        call RaiseFpuError
        mov edx, 80000000h
        LD sub, eax, eax
        or si, 7FFFh
.2:
        ret
.3:
        LD or, eax, eax
        jne short .5
        LD or, edx, edx
        jne short .5
        LD add, si, si
        jne short .4
        ret
.4:
        rcr si, 1
.5:
        push ebp
        LD mov, ebp, esp
        push edi
        db 087h,0CEh                            ; insn: xchg ecx,esi
        LD mov, edi, ecx
        rol edi, 10h
        sar edi, 10h
        sar ecx, 10h
        and edi, 80007FFFh
        and ecx, 80007FFFh
        rol edi, 10h
        rol ecx, 10h
        LD add, di, cx
        rol edi, 10h
        rol ecx, 10h
        LD or, di, di
        jne short .7
.6:
        LD add, eax, eax
        LD adc, edx, edx
        dec di
        LD or, edx, edx
        jns short .6
.7:
        LD or, cx, cx
        jne short .9
.8:
        LD add, ebx, ebx
        LD adc, esi, esi
        dec cx
        LD or, esi, esi
        jns short .8
.9:
        LD sub, di, cx
        add di, 3FFFh
        js short .10
        cmp di, 7FFFh
        jb short .10
        LD mov, edi, ecx
        mov di, 7FFFh
        mov edx, 80000000h
        LD sub, eax, eax
        jmp near .22
.10:
        cmp di, byte 0FFC0h
        jge short .11
        LD sub, eax, eax
        LD sub, edx, edx
        LD sub, edi, edi
        jmp near .22
.11:
        push edi
        push esi
        push ebx
        LD mov, ecx, esi
        LD mov, edi, edx
        LD mov, esi, eax
        LD sub, eax, eax
        LD cmp, ecx, edi
        ja short .12
        LD sub, edx, ecx
        inc eax
.12:
        push eax
        LD mov, eax, esi
        div ecx
        push eax
        xchg ebx, eax
        mul ebx
        xchg ecx, eax
        db 087h,0DAh                            ; insn: xchg ebx,edx
        mul edx
        LD add, eax, ebx
        adc edx, byte 0
        mov ebx, dword [byte ebp-010h]
        test byte [byte ebp-014h], 1
        je short .13
        LD add, eax, ebx
        adc edx, dword [byte ebp-0Ch]
.13:
        neg ecx
        LD sbb, esi, eax
        LD sbb, edi, edx
        je short .15
.14:
        sub dword [byte ebp-018h], byte 1
        sbb dword [byte ebp-014h], byte 0
        LD add, ecx, ebx
        adc esi, dword [byte ebp-0Ch]
        adc edi, byte 0
        jne short .14
.15:
        LD mov, edi, esi
        LD mov, esi, ecx
        mov ecx, dword [byte ebp-0Ch]
        LD cmp, ecx, edi
        ja short .16
        LD sub, edi, ecx
        add dword [byte ebp-018h], byte 1
        adc dword [byte ebp-014h], byte 0
.16:
        LD mov, edx, edi
        LD mov, eax, esi
        div ecx
        push eax
        LD or, eax, eax
        je short .18
        xchg ebx, eax
        mul ebx
        xchg ecx, eax
        db 087h,0DAh                            ; insn: xchg ebx,edx
        mul edx
        LD add, eax, ebx
        adc edx, byte 0
        neg ecx
        LD sbb, esi, eax
        LD sbb, edi, edx
        je short .18
.17:
        sub dword [byte ebp-01Ch], byte 1
        sbb dword [byte ebp-018h], byte 0
        sbb dword [byte ebp-014h], byte 0
        add ecx, dword [byte ebp-010h]
        adc esi, dword [byte ebp-0Ch]
        adc edi, byte 0
        jne short .17
.18:
        pop eax
        pop edx
        pop ebx
        add esp, byte 8
        pop edi
        dec di
        shr ebx, 1
        jae short .19
        rcr edx, 1
        rcr eax, 1
        inc edi
.19:
        LD or, di, di
        jg short .22
        jne short .20
        mov cl, 1
        jmp short .21
.20:
        neg di
        LD mov, cx, di
.21:
        LD sub, ebx, ebx
        shrd eax, edx, cl
        shrd edx, ebx, cl
        LD sub, di, di
.22:
        LD add, edi, edi
        rcr di, 1
        LD mov, esi, edi
        pop edi
        pop ebp
        ret
EmuMul:
        push esi
        push ecx
        push ebx
        mov si, word [byte edx+08h]
        mov ecx, dword [byte edx+04h]
        mov ebx, dword [edx]
        shl esi, 10h
        mov si, word [byte eax+08h]
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        call MultiplyMantissas
        pop ebx
        mov dword [ebx], eax
        mov dword [byte ebx+04h], edx
        mov word [byte ebx+08h], si
        pop ecx
        pop esi
        ret
MultiplyMantissas:
        LD or, eax, eax
        jne short .2
        LD or, edx, edx
        jne short .2
        LD add, si, si
        jne short .1
        ret
.1:
        rcr si, 1
.2:
        LD or, ecx, ecx
        jne short .3
        LD or, ebx, ebx
        jne short .3
        test esi, 7FFF0000h
        jne short .3
        LD sub, eax, eax
        LD sub, edx, edx
        LD sub, esi, esi
        ret
.3:
        push ebp
        push edi
        db 087h,0CEh                            ; insn: xchg ecx,esi
        LD mov, edi, ecx
        rol edi, 10h
        sar edi, 10h
        sar ecx, 10h
        and edi, 80007FFFh
        and ecx, 80007FFFh
        LD add, ecx, edi
        sub cx, 3FFEh
        jb short .4
        cmp cx, 7FFFh
        jb short .4
        jmp near .12
.4:
        cmp cx, byte 0FFC0h
        jge short .5
        LD sub, eax, eax
        LD sub, edx, edx
        LD sub, ecx, ecx
        jmp short .11
        db 090h,090h,090h
.5:
        push ecx
        LD sub, ebp, ebp
        push esi
        push edx
        push eax
        mul ebx
        xchg esi, eax
        LD mov, ecx, edx
        pop edx
        mul edx
        LD mov, edi, edx
        LD add, ecx, eax
        LD adc, edi, ebp
        LD adc, ebp, ebp
        pop eax
        xchg ebx, eax
        mul ebx
        LD add, ecx, eax
        LD adc, edi, edx
        adc ebp, byte 0
        LD mov, eax, ebx
        pop edx
        mul edx
        LD add, eax, edi
        LD adc, edx, ebp
        LD mov, ebx, ecx
        pop ecx
        js short .6
        LD add, ebx, ebx
        LD adc, eax, eax
        LD adc, edx, edx
        dec cx
.6:
        LD add, ebx, ebx
        jae short .8
        jne short .7
        LD or, esi, esi
        setne bl
        shr ebx, 1
        jb short .7
        LD mov, esi, eax
        shr esi, 1
.7:
        adc eax, byte 0
        adc edx, byte 0
        jae short .8
        rcr edx, 1
        rcr eax, 1
        inc cx
        cmp cx, 7FFFh
        je near .12
.8:
        LD or, cx, cx
        jg short .11
        jne short .9
        mov cl, 1
        jmp short .10
.9:
        neg cx
.10:
        LD sub, ebx, ebx
        shrd eax, edx, cl
        shrd edx, ebx, cl
        LD sub, cx, cx
.11:
        LD add, ecx, ecx
        rcr cx, 1
        LD mov, esi, ecx
        pop edi
        pop ebp
        ret
.12:
        mov cx, 7FFFh
        mov edx, 80000000h
        LD sub, eax, eax
        jmp short .11
StoreM32IntTrunc:
        push ebx
        mov bl, 0A0h
        jmp short Emu387LdToInt+03h
        push ebx
        mov bh, byte [byte eax+09h]
        push ecx
        mov cx, word [byte eax+08h]
        and cx, 7FFFh
        jne short .1
        LD sub, eax, eax
        jmp short .5
.1:
        sub cx, 3FFEh
        jg short .2
        LD add, bh, bh
        LD sbb, eax, eax
        jmp short .5
.2:
        cmp cx, byte 1Fh
        jle short .3
        mov eax, 80000000h
        jmp short .5
.3:
        LD mov, ch, bh
        mov ebx, dword [eax]
        mov eax, dword [byte eax+04h]
        push edx
        LD sub, edx, edx
        shld edx, eax, cl
        shl eax, cl
        LD or, ebx, eax
        LD mov, eax, edx
        pop edx
        LD add, ch, ch
        jae short .5
        LD or, ebx, ebx
        je short .4
        inc eax
.4:
        neg eax
.5:
        pop ecx
        pop ebx
        ret
StoreM32Int:
        push ebx
        mov bl, 1Fh
        jmp short Emu387LdToInt+03h
Emu387LdToInt:
        push ebx
        mov bl, 20h
        mov bh, byte [byte eax+09h]
        shr bh, 1
        LD or, bh, bl
        push ecx
        mov cx, word [byte eax+08h]
        and cx, 7FFFh
        sub cx, 3FFEh
        jl short .5
        cmp cx, byte 20h
        jg short .4
        and bl, 3Fh
        LD cmp, cl, bl
        jg short .4
        LD mov, ch, bh
        mov ebx, dword [eax]
        mov eax, dword [byte eax+04h]
        LD add, ebx, ebx
        rcr ch, 1
        cmp cl, 20h
        jne short .1
        LD add, ch, ch
        jmp short .2
.1:
        LD sub, ebx, ebx
        shld ebx, eax, cl
        shl eax, cl
        LD add, ch, ch
        LD add, eax, eax
        LD mov, eax, ebx
.2:
        mov cl, 0FFh
        rcr cl, 1
        LD and, ch, cl
        LD add, ch, ch
        adc eax, byte 0
        LD add, ch, ch
        jae short .3
        neg eax
.3:
        pop ecx
        pop ebx
        ret
.4:
        mov eax, 80000000h
        pop ecx
        pop ebx
        ret
.5:
        LD sub, eax, eax
        pop ecx
        pop ebx
        ret
LoadM32Int:
        push ebx
        LD mov, ebx, edx
        LD or, eax, eax
        jns short .1
        neg eax
        mov edx, 0BFFFh
        jmp short Emu387IntToLd+08h
.1:
        pop ebx
Emu387IntToLd:
        push ebx
        LD mov, ebx, edx
        mov edx, 3FFFh
        push ecx
        LD or, eax, eax
        je short .1
        bsr ecx, eax
        LD mov, ch, cl
        mov cl, 1Fh
        LD sub, cl, ch
        shl eax, cl
        LD mov, cl, ch
        movzx ecx, ch
        LD add, ecx, edx
        LD mov, edx, eax
        jmp short .2
.1:
        LD sub, edx, edx
        LD sub, ecx, ecx
.2:
        LD sub, eax, eax
        mov dword [ebx], eax
        mov dword [byte ebx+04h], edx
        mov word [byte ebx+08h], cx
        pop ecx
        pop ebx
        ret
LoadM64Real:
        push ecx
        LD mov, ecx, edx
        shld edx, eax, 0Bh
        shl eax, 0Bh
        sar ecx, 14h
        and cx, 7FFh
        je short .4
        cmp cx, 7FFh
        je short .1
        add cx, 3C00h
        jmp short .3
.1:
        mov cx, 7FFFh
        test edx, 7FFFFFFFh
        jne short .2
        LD or, eax, eax
.2:
        je short .3
        push eax
        mov al, 1
        mov ah, 81h
        call RaiseFpuError
        pop eax
        or edx, 40000000h
.3:
        or edx, 80000000h
        jmp short .7
.4:
        LD or, edx, edx
        jne short .5
        LD or, eax, eax
        jne short .5
        LD sub, ecx, ecx
        jmp short .7
.5:
        mov cx, 3C01h
        LD or, edx, edx
        jne short .6
        xchg edx, eax
        sub cx, byte 20h
.6:
        LD or, edx, edx
        js short .7
        LD add, eax, eax
        LD adc, edx, edx
        dec cx
        jmp short .6
.7:
        mov dword [ebx], eax
        mov dword [byte ebx+04h], edx
        LD add, ecx, ecx
        rcr cx, 1
        mov word [byte ebx+08h], cx
        pop ecx
        ret
StoreM32Real:
        push edx
        push ecx
        push ebx
        LD mov, ebx, eax
        mov edx, 0FFFFFF00h
        mov eax, dword [byte ebx+04h]
        LD mov, ecx, eax
        shl ecx, 19h
        mov cx, word [byte ebx+08h]
        jae short .2
        jne short .1
        cmp dword [ebx], byte 0
        jne short .1
        LD add, edx, edx
.1:
        add eax, 100h
        jae short .2
        mov eax, 80000000h
        inc cx
.2:
        LD and, eax, edx
        LD mov, ebx, ecx
        and cx, 7FFFh
        je short .6
        cmp cx, 7FFFh
        jne short .3
        LD add, eax, eax
        shr eax, 8
        or eax, 0FF000000h
        LD add, bx, bx
        rcr eax, 1
        jmp short .6
.3:
        add cx, 0C080h
        jns short .4
        LD sub, eax, eax
        jmp short .6
.4:
        cmp cx, 0FFh
        jl short .5
        mov eax, 0FF000000h
        LD add, bx, bx
        rcr eax, 1
        jmp short .6
.5:
        LD add, eax, eax
        shrd eax, ecx, 8
        LD add, bx, bx
        rcr eax, 1
.6:
        pop ebx
        pop ecx
        pop edx
        ret
StoreM64Real:
        push ecx
        push ebx
        push esi
        mov cx, word [byte eax+08h]
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        mov esi, 0FFFFF800h
        LD mov, ebx, eax
        shl ebx, 16h
        jae short .2
        jne short .1
        LD add, esi, esi
.1:
        add eax, 800h
        adc edx, byte 0
        jae short .2
        mov edx, 80000000h
        inc cx
.2:
        LD and, eax, esi
        LD mov, ebx, ecx
        and cx, 7FFFh
        add cx, 0C400h
        cmp cx, 7FFh
        jae short .5
        LD or, cx, cx
        jne short .3
        shrd eax, edx, 0Ch
        LD add, edx, edx
        shr edx, 0Ch
        jmp short .4
.3:
        shrd eax, edx, 0Bh
        LD add, edx, edx
        shrd edx, ecx, 0Bh
.4:
        LD add, bx, bx
        rcr edx, 1
        jmp short .10
.5:
        cmp cx, 0C400h
        jb short .9
        cmp cx, byte 0FFCCh
        jl short .7
        sub cx, byte 0Ch
        neg cx
        cmp cl, 20h
        jb short .6
        sub cl, 20h
        LD mov, esi, eax
        LD mov, eax, edx
        LD sub, edx, edx
.6:
        shrd esi, eax, cl
        shrd eax, edx, cl
        shr edx, cl
        LD add, esi, esi
        adc eax, byte 0
        adc edx, byte 0
        jmp short .8
.7:
        LD sub, eax, eax
        LD sub, edx, edx
.8:
        jmp short .10
.9:
        shrd eax, edx, 0Bh
        LD add, edx, edx
        shr edx, 0Bh
        LD add, bx, bx
        rcr edx, 1
        or edx, 7FF00000h
        cmp cx, 43FFh
        je short .10
        push eax
        mov al, 8
        mov ah, 84h
        call RaiseFpuError
        pop eax
.10:
        pop esi
        pop ebx
        pop ecx
        ret
LoadM32Real:
        push ecx
        push ebx
        LD mov, ebx, edx
        LD sub, edx, edx
        LD mov, ecx, eax
        sar ecx, 17h
        and cx, 0FFh
        je short .3
        shl eax, 8
        cmp cl, 0FFh
        je short .1
        add cx, 3F80h
        jmp short .2
.1:
        mov ch, 0FFh
        and eax, 7FFFFFFFh
        je short .2
        or eax, 40000000h
.2:
        LD add, ecx, ecx
        rcr cx, 1
        or eax, 80000000h
.3:
        mov dword [ebx], edx
        mov dword [byte ebx+04h], eax
        mov word [byte ebx+08h], cx
        pop ebx
        pop ecx
        ret
EmuMantissaMasks:
        db 0FFh,0FFh,0FFh,07Fh,0FFh,0FFh,0FFh,03Fh,0FFh,0FFh,0FFh,01Fh,0FFh,0FFh,0FFh,0Fh
        db 0FFh,0FFh,0FFh,07h,0FFh,0FFh,0FFh,03h,0FFh,0FFh,0FFh,01h,0FFh,0FFh,0FFh,00h
        db 0FFh,0FFh,07Fh,00h,0FFh,0FFh,03Fh,00h,0FFh,0FFh,01Fh,00h,0FFh,0FFh,0Fh,00h
        db 0FFh,0FFh,07h,00h,0FFh,0FFh,03h,00h,0FFh,0FFh,01h,00h,0FFh,0FFh,00h,00h
        db 0FFh,07Fh,00h,00h,0FFh,03Fh,00h,00h,0FFh,01Fh,00h,00h,0FFh,0Fh,00h,00h
        db 0FFh,07h,00h,00h,0FFh,03h,00h,00h,0FFh,01h,00h,00h,0FFh,00h,00h,00h
        db 07Fh,00h,00h,00h,03Fh,00h,00h,00h,01Fh,00h,00h,00h,0Fh,00h,00h,00h
        db 07h,00h,00h,00h,03h,00h,00h,00h,01h,00h,00h,00h,00h,00h,00h,00h
ExtToInt:
        push edi
        LD mov, edi, eax
        LD sub, ebx, ebx
        mov bx, word [byte edi+08h]
        cmp dx, 400h
        je short .1
        cmp dx, 800h
.1:
        jne short .2
        LD or, bh, bh
        jns short .2
        xor dx, 0C00h
.2:
        cmp dx, 0C00h
        jne short .3
        mov dx, 400h
.3:
        and bx, 7FFFh
        sub bx, 403Fh
        jl short .4
        pop edi
        ret
.4:
        mov ecx, dword [edi]
        add bx, byte 20h
        jl short .9
        mov eax, dword [nosplit cs:ebx*4+EmuMantissaMasks]
        LD and, ecx, eax
        xor dword [edi], ecx
        inc eax
        cmp dx, 400h
        je short .8
        cmp dx, byte 0
        jne short .7
        LD add, ecx, ecx
        LD cmp, eax, ecx
        ja near .8
        jne short .7
        rol eax, 1
        jae short .5
        test dword [byte edi+04h], eax
        jmp short .6
.5:
        test dword [edi], eax
.6:
        je near .8
        ror eax, 1
.7:
        LD or, ecx, ecx
        je short .8
        add dword [edi], eax
        adc dword [byte edi+04h], byte 0
        jae short .8
        rcr dword [byte edi+04h], 1
        inc word [byte edi+08h]
.8:
        pop edi
        ret
.9:
        push esi
        mov dword [edi], 0
        mov esi, dword [byte edi+04h]
        add bx, byte 20h
        jl short .14
        mov eax, dword [nosplit cs:ebx*4+EmuMantissaMasks]
        LD and, esi, eax
        xor dword [byte edi+04h], esi
        inc eax
        cmp dx, 400h
        je short .13
        cmp dx, byte 0
        jne short .11
        rol ecx, 1
        LD adc, esi, esi
        LD cmp, eax, esi
        ja near .13
        jne short .11
        LD or, ecx, ecx
        jne near .12
        LD add, eax, eax
        jb short .10
        test dword [byte edi+04h], eax
.10:
        je near .13
        shr eax, 1
.11:
        LD or, ecx, esi
        je short .13
.12:
        add dword [byte edi+04h], eax
        jae short .13
        rcr dword [byte edi+04h], 1
        inc word [byte edi+08h]
.13:
        pop esi
        pop edi
        ret
.14:
        cmp dx, 400h
        je short .16
        cmp dx, byte 0
        jne short .15
        inc bx
        jne near .16
        cmp esi, 80000000h
        jne short .15
        LD or, ecx, ecx
        je near .16
.15:
        mov dword [byte edi+04h], 80000000h
        or word [byte edi+08h], 3FFFh
        pop esi
        pop edi
        ret
.16:
        LD sub, eax, eax
        mov dword [byte edi+04h], eax
        mov word [byte edi+08h], ax
        pop esi
        pop edi
        ret
EmuRemPolyCoefs:
        db 04Eh,018h,0E6h,0C0h,0E4h,0C7h,0D1h,0B5h,0FAh,03Fh,029h,0Bh,01h,08h,08h,09Bh
        db 0C6h,084h,0FBh,0BFh,01Ah,026h,0C5h,06Ch,02Eh,02h,046h,09Dh,0FBh,03Fh,02Ah,098h
        db 06Bh,0Ah,09Dh,0B9h,02Bh,0BAh,0FBh,0BFh,071h,01h,02Bh,095h,027h,027h,08Eh,0E3h
        db 0FBh,03Fh,0FCh,068h,09Ch,0DDh,072h,024h,049h,092h,0FCh,0BFh,0C1h,0ADh,0EBh,094h
        db 0CCh,0CCh,0CCh,0CCh,0FCh,03Fh,0F2h,081h,097h,0AAh,0AAh,0AAh,0AAh,0AAh,0FDh,0BFh
        db 00h,00h,00h,00h,00h,00h,00h,080h,0FFh,03Fh
EmuRemainder:
        push edi
        push esi
        push ecx
        LD mov, edi, eax
        mov cx, word [byte edi+08h]
        shl cx, 1
        jne short .3
        test byte [byte edx+09h], 80h
        je short .1
        mov word [byte ebx+08h], 4000h
        mov dword [byte ebx+04h], 0C90FDAA2h
        mov dword [ebx], 2168C235h
        jmp short .2
.1:
        mov word [byte ebx+08h], 0
        mov dword [byte ebx+04h], 0
        mov dword [ebx], 0
.2:
        jmp short .7
.3:
        mov cx, word [byte edx+08h]
        shl cx, 1
        jne short .4
        mov ax, word [byte edi+08h]
        and ax, 8000h
        or ax, 3FFFh
        mov word [byte ebx+08h], ax
        mov dword [byte ebx+04h], 0C90FDAA2h
        mov dword [ebx], 2168C235h
        jmp short .7
.4:
        mov ch, byte [byte edi+09h]
        call EmuDiv
        LD mov, eax, ebx
        call RemainderStep
        mov dl, byte [byte ebx+09h]
        LD or, ch, ch
        js short .6
        LD or, dl, dl
        jns short .5
        LD mov, eax, ebx
        push dword 4000h
        push dword 0C90FDAA2h
        push dword 2168C235h
        call AddExtRaw
.5:
        jmp short .7
.6:
        LD or, dl, dl
        jle short .7
        LD mov, eax, ebx
        push dword 0C000h
        push dword 0C90FDAA2h
        push dword 2168C235h
        call AddExtRaw
.7:
        pop ecx
        pop esi
        pop edi
        ret
RemainderStep:
        push edi
        push esi
        push ecx
        LD mov, edi, eax
        mov ch, 0
        mov cl, byte [byte edi+09h]
        and byte [byte edi+09h], 7Fh
        cmp word [byte edi+08h], 3FFFh
        jne short .1
        cmp dword [byte edi+04h], 80000000h
        jne short .1
        cmp dword [edi], byte 0
        jne short .1
        mov dword [edi], 2168C235h
        mov dword [byte edi+04h], 0C90FDAA2h
        mov ax, 3FFEh
        and cl, 80h
        LD or, ah, cl
        mov word [byte edi+08h], ax
        pop ecx
        pop esi
        pop edi
        ret
.1:
        push edx
        push ebx
        cmp word [byte edi+08h], 3FFFh
        jl short .2
        push ecx
        mov si, word [byte edi+08h]
        mov ecx, dword [byte edi+04h]
        mov ebx, dword [edi]
        shl esi, 10h
        mov si, 3FFFh
        mov edx, 80000000h
        mov eax, 0
        call DivideMantissas
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        pop ecx
        mov ch, 2
.2:
        mov ax, word [byte edi+08h]
        cmp ax, 3FFDh
        jne short .3
        mov eax, dword [byte edi+04h]
        cmp eax, 8930A2F4h
        jne short .3
        mov eax, dword [edi]
        cmp eax, 0F66AB09Bh
.3:
        jbe short .4
        push ecx
        mov ebx, 0C265539Eh
        mov ecx, 0DDB3D742h
        mov esi, 3FFF0000h
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        call AddMantissas
        push eax
        push edx
        push esi
        mov ebx, 0C265539Eh
        mov ecx, 0DDB3D742h
        mov esi, 3FFF0000h
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        call MultiplyMantissas
        LD sub, ebx, ebx
        mov ecx, 80000000h
        rol esi, 10h
        mov si, 0BFFFh
        rol esi, 10h
        call AddMantissas
        pop ebx
        shl ebx, 10h
        LD mov, bx, si
        LD mov, esi, ebx
        pop ecx
        pop ebx
        call DivideMantissas
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        pop ecx
        or ch, 1
.4:
        LD mov, eax, edi
        lea edx, [EmuRemPolyCoefs]
        mov ebx, 8
        call PolyEvalOdd
        shr ch, 1
        jae short .5
        LD mov, eax, edi
        push dword 3FFEh
        push dword 860A91C1h
        push dword 6B9B2C23h
        LD mov, ebx, edi
        call AddExtRaw
.5:
        shr ch, 1
        jae short .6
        push dword 0BFFFh
        push dword 0C90FDAA2h
        push dword 2168C235h
        LD mov, eax, edi
        LD mov, ebx, edi
        call AddExtRaw
        xor byte [byte ebx+09h], 80h
.6:
        cmp cl, 0
        jns short .7
        xor byte [byte edi+09h], 80h
.7:
        pop ebx
        pop edx
        pop ecx
        pop esi
        pop edi
        ret
EmuRoundInt:
        cmp word [byte eax+08h], byte 0
        jne short .1
        cmp dword [byte eax+04h], byte 0
        jne short .1
        cmp dword [eax], byte 0
        jne short .1
        LD sub, eax, eax
        ret
.1:
        cmp word [byte edx+08h], byte 0
        jne short .2
        cmp dword [byte edx+04h], byte 0
        jne short .2
        cmp dword [edx], byte 0
        jne short .2
        LD sub, edx, edx
        mov dword [eax], edx
        mov dword [byte eax+04h], edx
        mov word [byte eax+08h], dx
        LD sub, eax, eax
        ret
.2:
        push ebp
        push esi
        push edi
        push edx
        push ecx
        push ebx
        push eax
        mov si, word [byte eax+08h]
        mov di, word [byte edx+08h]
        mov ecx, dword [byte edx+04h]
        mov ebx, dword [edx]
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        call RoundMantissa
        pop ecx
        mov dword [ecx], eax
        mov dword [byte ecx+04h], edx
        mov word [byte ecx+08h], si
        LD mov, eax, edi
        pop ebx
        pop ecx
        pop edx
        pop edi
        pop esi
        pop ebp
        ret
RoundMantissa:
        push esi
        push edi
        and esi, 7FFFh
        and edi, 7FFFh
        LD sub, esi, edi
        jl short .9
        LD sub, edi, edi
.1:
        LD cmp, ecx, edx
        jne short .2
        LD cmp, ebx, eax
        je near .3
.2:
        jae short .4
.3:
        LD sub, eax, ebx
        LD sbb, edx, ecx
        stc
.4:
        LD adc, edi, edi
        dec esi
        jl near .5
        LD add, eax, eax
        LD adc, edx, edx
        jb short .3
        LD or, edx, edx
        js short .1
        jmp short .4
.5:
        LD sub, esi, esi
        LD or, eax, eax
        jne short .6
        LD or, edx, edx
        jne short .6
        jmp short .8
.6:
        LD or, edx, edx
        js short .7
        LD adc, eax, eax
        LD adc, edx, edx
        dec esi
        jmp short .6
.7:
        pop ecx
        push ecx
        and ecx, 7FFFh
        LD add, esi, ecx
.8:
        jmp short .10
.9:
        LD add, esi, edi
        LD sub, edi, edi
.10:
        pop ecx
        pop ebx
        and ebx, 8000h
        LD or, esi, ebx
        LD or, edx, edx
        jne short .11
        LD sub, esi, esi
.11:
        LD xor, bx, cx
        jns short .12
        neg edi
.12:
        ret
EmuExamine:
        push ebx
        push edx
        LD mov, ebx, eax
        mov ax, word [dword cs:edi+unk_A32D6]
        LD mov, edx, eax
        and ax, word [byte ds:ebp+08h]
        LD cmp, ax, dx
        jne short .1
        mov al, 41h
        mov dh, 0
        jmp short .7
.1:
        not edx
        and word [byte ds:ebp+08h], dx
        mov ax, word [byte ebx+08h]
        LD mov, edx, eax
        and dh, 80h
        rol dh, 1
        shl dh, 1
        and ax, 7FFFh
        jne short .3
        mov eax, dword [byte ebx+04h]
        or eax, dword [ebx]
        mov al, 44h
        jne short .2
        mov ax, word [dword cs:edi+unk_A32D0]
        or word [byte ds:ebp+08h], ax
        mov al, 40h
.2:
        jmp short .7
.3:
        cmp ax, 7FFFh
        jne short .6
        mov ax, word [dword cs:edi+unk_A32D4]
        or word [byte ds:ebp+08h], ax
        cmp dword [ebx], byte 0
        jne short .4
        mov eax, dword [byte ebx+04h]
        cmp eax, 80000000h
.4:
        mov al, 1
        jne short .5
        mov al, 5
.5:
        jmp short .7
.6:
        test byte [byte ebx+07h], 80h
        mov al, 4
        jne short .7
        mov ax, word [dword cs:edi+unk_A32D4]
        or word [byte ds:ebp+08h], ax
        mov al, 44h
.7:
        LD or, al, dh
        mov dx, word [byte ds:ebp+04h]
        and dx, 0B8FFh
        LD or, dh, al
        mov word [byte ds:ebp+04h], dx
        pop edx
        pop ebx
        ret
        db 090h
EmuLog2PolyNum:
        db 0E9h,046h,0E9h,0B5h,09Ah,0ADh,020h,0CAh,0FEh,0BFh,09h,065h,07Fh,0B5h,00h,051h
        db 012h,083h,03h,040h,028h,0D2h,0ACh,09Dh,095h,0F8h,03Fh,080h,05h,0C0h
EmuLog2PolyDen:
        db 00h,00h,00h,00h,00h,00h,00h,080h,0FFh,03Fh,0BBh,076h,070h,03Eh,05Bh,02h
        db 0ACh,08Eh,04h,0C0h,060h,0EFh,033h,0A9h,0D0h,01Fh,04h,09Ch,07h,040h,096h,0BBh
        db 083h,06Ch,0E0h,0F4h,05Fh,0C0h,08h,0C0h
AddOne:
        push ebx
        push edx
        push eax
        push dword 3FFFh
        push dword 80000000h
        push byte 0
        LD mov, ebx, eax
        call AddExtRaw
        pop eax
        pop edx
        pop ebx
EmuLog2:
        push edi
        push esi
        push edx
        push ecx
        push ebx
        push eax
        call Log2Core
        pop eax
        LD mov, ebx, edx
        push edx
        call EmuMul
        pop edi
        mov si, word [byte edi+08h]
        mov ecx, dword [byte edi+04h]
        mov ebx, dword [edi]
        shl esi, 10h
        mov si, 3FFFh
        mov edx, 0B8AA3B29h
        mov eax, 5C17F0BDh
        call MultiplyMantissas
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        pop ebx
        pop ecx
        pop edx
        pop esi
        pop edi
        ret
Log2Core:
        push edi
        push esi
        push edx
        push ecx
        push ebx
        LD sub, ecx, ecx
        mov cx, word [byte eax+08h]
        LD or, cx, cx
        js short .1
        jmp short .1
.1:
        LD mov, edi, eax
        mov edx, 3FFEh
        sub ecx, 3FFEh
        push ecx
        mov word [byte edi+08h], dx
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov esi, 0BFFE3FFEh
        mov ecx, 80000000h
        LD sub, ebx, ebx
        call AddMantissas
        cmp word [byte edi+08h], 3FFEh
        jne short .2
        cmp dword [byte edi+04h], 0B504F333h
        jne short .2
        cmp dword [edi], 0F9DE6484h
.2:
        jbe short .3
        and esi, 0FFFFh
        or esi, 0BFFE0000h
        mov ecx, 80000000h
        LD sub, ebx, ebx
        call AddMantissas
        jmp short .4
.3:
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        dec dword [esp]
.4:
        push eax
        push edx
        push esi
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        dec si
        and esi, 0FFFFh
        or esi, 3FFE0000h
        mov ecx, 80000000h
        LD sub, ebx, ebx
        call AddMantissas
        shl esi, 10h
        LD mov, ecx, edx
        LD mov, ebx, eax
        pop eax
        LD mov, si, ax
        pop edx
        pop eax
        call DivideMantissas
        push eax
        push edx
        push esi
        LD mov, ecx, esi
        shl esi, 10h
        LD mov, si, cx
        LD mov, ecx, edx
        LD mov, ebx, eax
        call MultiplyMantissas
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        mov ebx, 3
        lea ecx, [EmuLog2PolyDen]
        call PolyEval
        push eax
        push edx
        push esi
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        lea ecx, [EmuLog2PolyNum]
        mov ebx, 2
        call PolyEval
        pop ecx
        rol esi, 10h
        LD mov, si, cx
        rol esi, 10h
        pop ecx
        pop ebx
        call DivideMantissas
        mov ebx, dword [edi]
        mov ecx, dword [byte edi+04h]
        rol esi, 10h
        mov si, word [byte edi+08h]
        rol esi, 10h
        call MultiplyMantissas
        rol esi, 10h
        mov si, word [esp]
        rol esi, 10h
        mov ecx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        call MultiplyMantissas
        rol esi, 10h
        pop ecx
        LD mov, si, cx
        rol esi, 10h
        pop ecx
        pop ebx
        call AddMantissas
        pop ecx
        LD or, ecx, ecx
        je short .5
        push eax
        push edx
        push esi
        LD mov, edx, edi
        LD mov, eax, ecx
        call LoadM32Int
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        and esi, 0FFFFh
        or esi, 0BFF20000h
        mov ecx, 0DE8082E3h
        mov ebx, 865435Ch
        call MultiplyMantissas
        pop ecx
        rol esi, 10h
        LD mov, si, cx
        rol esi, 10h
        pop ecx
        pop ebx
        call AddMantissas
        push eax
        push edx
        push esi
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        and esi, 0FFFFh
        or esi, 3FFE0000h
        mov ecx, 0B1800000h
        LD sub, ebx, ebx
        call MultiplyMantissas
        pop ecx
        rol esi, 10h
        LD mov, si, cx
        rol esi, 10h
        pop ecx
        pop ebx
        call AddMantissas
.5:
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        pop ebx
        pop ecx
        pop edx
        pop esi
        pop edi
        ret
        db 090h
EmuSinPolyCoefs:
        db 059h,053h,06Ah,085h,081h,03Bh,096h,0CAh,0CEh,03Fh,08Fh,0F8h,0C0h,09Dh,039h,09Fh
        db 03Fh,0D7h,0D6h,0BFh,0E5h,04Bh,068h,043h,09Dh,030h,092h,0B0h,0DEh,03Fh,07Fh,01Ch
        db 027h,0AAh,03Fh,02Bh,032h,0D7h,0E5h,0BFh,07Dh,09Ch,039h,0B6h,02Ah,01Dh,0EFh,0B8h
        db 0ECh,03Fh,0Ch,0D0h,00h,0Dh,0D0h,00h,0Dh,0D0h,0F2h,0BFh,088h,088h,088h,088h
        db 088h,088h,088h,088h,0F8h,03Fh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0FCh,0BFh
        db 00h,00h,00h,00h,00h,00h,00h,080h,0FFh,03Fh
EmuCosPolyCoefs:
        db 08Fh,0F8h,0C0h,09Dh,039h,09Fh,03Fh,0D7h,0D2h,03Fh,05h,0E9h,0E4h,03h,046h,0A5h
        db 0CBh,0C9h,0DAh,0BFh,0AAh,0BDh,0C4h,0C6h,07Fh,0C7h,076h,08Fh,0E2h,03Fh,097h,0E3h
        db 0FAh,0C4h,0BBh,07Dh,0F2h,093h,0E9h,0BFh,0Dh,0D0h,00h,0Dh,0D0h,00h,0Dh,0D0h
        db 0EFh,03Fh,0Bh,0B6h,060h,0Bh,0B6h,060h,0Bh,0B6h,0F5h,0BFh,0AAh,0AAh,0AAh,0AAh
        db 0AAh,0AAh,0AAh,0AAh,0FAh,03Fh,00h,00h,00h,00h,00h,00h,00h,080h,0FEh,0BFh
        db 00h,00h,00h,00h,00h,00h,00h,080h,0FFh,03Fh
EmuSinCosTermCounts:
        db 00h,00h,01h,00h,02h,00h,03h,00h,04h,00h,04h,00h,05h,00h,05h,00h
        db 06h,00h
SinCosCore:
        push ebp
        push edi
        push edx
        push ecx
        push ebx
        LD mov, ebp, esp
        sub esp, byte 0Ch
        LD mov, edi, eax
        LD sub, ecx, ecx
        mov cx, word [byte eax+08h]
        and cx, 7FFFh
        sub cx, 3FFEh
        cmp cx, byte 20h
        jl short .1
.1:
        push ecx
        push esi
        push edi
        mov si, word [byte eax+08h]
        mov di, 3FFEh
        mov ecx, 0C90FDAA2h
        mov ebx, 2168C235h
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        call RoundMantissa
        pop ecx
        mov dword [ecx], eax
        mov dword [byte ecx+04h], edx
        mov word [byte ecx+08h], si
        LD mov, eax, edi
        LD mov, edi, ecx
        pop esi
        test byte [byte edi+09h], 80h
        je short .2
        push eax
        LD mov, ebx, edi
        LD mov, eax, edi
        push dword 3FFEh
        push dword 0C90FDAA2h
        push dword 2168C235h
        call AddExtRaw
        pop eax
        dec eax
.2:
        LD mov, ebx, esi
        LD mov, ah, bl
        and bl, 2
        LD add, al, bl
        and al, 7
        push eax
        test al, 1
        je short .3
        push dword 0BFFEh
        push dword 0C90FDAA2h
        push dword 2168C235h
        LD mov, eax, edi
        LD mov, ebx, edi
        call AddExtRaw
        xor byte [byte ebx+09h], 80h
.3:
        LD sub, ecx, ecx
        mov cx, word [byte edi+08h]
        sub cx, 3FFEh
        cmp cx, byte 0FFE0h
        jge short .4
        mov dword [byte ebp-0Ch], 0
        mov dword [byte ebp-08h], 80000000h
        mov word [byte ebp-04h], 3FFFh
        jmp near .10
.4:
        LD or, cx, cx
        js short .5
        mov cx, 0
.5:
        neg cx
        cmp cx, byte 8
        jle short .6
        mov cx, 8
.6:
        mov cx, word [nosplit cs:ecx*2+EmuSinCosTermCounts]
        push ecx
        mov eax, dword [byte ebp-014h]
        inc al
        and al, 2
        jne short .7
        cmp ah, 1
        je short .7
        jmp short .8
.7:
        push eax
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        shl esi, 10h
        mov si, word [byte edi+08h]
        LD mov, ebx, eax
        LD mov, ecx, edx
        call MultiplyMantissas
        mov ecx, dword [byte ebp-018h]
        mov ebx, 8
        LD sub, ebx, ecx
        lea ecx, [ecx+ecx*4]
        lea ecx, [nosplit ecx*2+EmuCosPolyCoefs]
        call PolyEval
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-08h], edx
        mov word [byte ebp-04h], si
        pop eax
.8:
        cmp al, 0
        je short .9
        cmp ah, 1
        je short .9
        jmp short .10
.9:
        LD mov, eax, edi
        mov ecx, dword [byte ebp-018h]
        mov ebx, 8
        LD sub, ebx, ecx
        lea ecx, [ecx+ecx*4]
        LD add, ecx, ecx
        lea edx, [EmuSinPolyCoefs]
        LD add, edx, ecx
        call PolyEvalOdd
.10:
        mov eax, dword [byte ebp-014h]
        inc al
        and al, 2
        je short .11
        mov eax, dword [byte ebp-0Ch]
        mov edx, dword [byte ebp-08h]
        mov si, word [byte ebp-04h]
        jmp short .12
.11:
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
.12:
        mov ecx, dword [byte ebp-014h]
        test cl, 4
        je short .13
        xor si, 8000h
.13:
        cmp ch, 1
        jne short .18
        rol esi, 10h
        add cl, 2
        LD mov, bl, cl
        inc bl
        and bl, 2
        je short .14
        and cl, 4
        mov ebx, dword [byte ebp-0Ch]
        mov ecx, dword [byte ebp-08h]
        mov si, word [byte ebp-04h]
        jmp short .15
.14:
        and cl, 4
        mov ebx, dword [edi]
        mov ecx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
.15:
        je short .16
        xor esi, 8000h
.16:
        rol esi, 10h
        LD or, ebx, ebx
        jne short .17
        LD or, ecx, ecx
        jne short .17
        test esi, 7FFF0000h
        jne short .17
        LD sub, eax, eax
        mov edx, 80000000h
        or si, 7FFFh
        jmp short .18
.17:
        call DivideMantissas
.18:
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        LD mov, esp, ebp
        pop ebx
        pop ecx
        pop edx
        pop edi
        pop ebp
        ret
EmuSin:
        push esi
        LD sub, esi, esi
        call SinCosCore
        pop esi
        ret
EmuCos:
        push esi
        mov esi, 2
        call SinCosCore
        pop esi
        ret
EmuTan:
        push esi
        mov esi, 1
        call SinCosCore
        pop esi
        ret
        db 090h
EmuTan_E:
        adc eax, 67CC487Bh
        ret
        db 0AAh,085h,0FFh,03Fh,0E7h,0D6h,08Bh,0EAh,0E3h,0C1h,095h,08Bh,0FFh,03Fh,06Fh,0A9h
        db 0B8h,08Dh,051h,0F0h,037h,098h,0FFh,03Fh,084h,064h,0DEh,0F9h,033h,0F3h,04h,0B5h
        db 0FFh,03Fh
EmuAtan:
        push ebp
        push edi
        push esi
        push edx
        push ecx
        push ebx
        LD mov, edi, eax
        LD sub, esi, esi
        mov cx, word [byte edi+08h]
        and byte [byte edi+09h], 7Fh
        cmp word [byte edi+08h], byte 0
        jne short .1
        cmp dword [byte edi+04h], byte 0
        jne short .1
        cmp dword [edi], byte 0
.1:
        je short .9
        LD or, cx, cx
        jns short .2
        dec esi
        push dword 0BFFFh
        push dword 80000000h
        push byte 0
        LD mov, eax, edi
        LD mov, ebx, edi
        call AddExtRaw
        xor byte [byte ebx+09h], 80h
.2:
        mov bx, word [byte edi+08h]
        add bx, byte 4
        LD sub, ecx, ecx
        mov edx, dword [byte edi+04h]
        mov eax, dword [edi]
.3:
        cmp bx, 3FFFh
        jb short .4
        LD add, eax, eax
        LD adc, edx, edx
        LD adc, ecx, ecx
        dec bx
        jmp short .3
.4:
        LD or, edx, edx
        jne short .5
        LD or, eax, eax
.5:
        jne short .6
        LD sub, ebx, ebx
        jmp short .8
.6:
        LD or, edx, edx
        js short .7
        LD add, eax, eax
        LD adc, edx, edx
        dec bx
        jmp short .6
.7:
        sub bx, byte 4
.8:
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], bx
        jmp short .10
.9:
        LD sub, ecx, ecx
.10:
        push esi
        push ecx
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        shl esi, 10h
        mov si, word [byte edi+08h]
        LD mov, ebx, eax
        LD mov, ecx, edx
        call MultiplyMantissas
        push eax
        push edx
        push esi
        mov ecx, 0A6829A79h
        mov ebx, 1BF21F8Ch
        and esi, 0FFFFh
        or esi, 40030000h
        call AddMantissas
        LD mov, ebp, esp
        xchg eax, dword [byte ebp+08h]
        xchg edx, dword [byte ebp+04h]
        xchg esi, dword [byte ebp+00h]
        mov ecx, 0EC96F0D6h
        mov ebx, 9D7BFDBh
        and esi, 0FFFFh
        or esi, 3FFA0000h
        call MultiplyMantissas
        mov ecx, 0E6D5051Ah
        mov ebx, 0E536E187h
        and esi, 0FFFFh
        or esi, 40010000h
        call AddMantissas
        mov ebx, dword [edi]
        mov ecx, dword [byte edi+04h]
        rol esi, 10h
        mov si, word [byte edi+08h]
        rol esi, 10h
        call MultiplyMantissas
        push eax
        push edx
        push esi
        xor esi, 8000h
        rol esi, 10h
        mov si, word [byte ebp+00h]
        rol esi, 10h
        mov ebx, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+04h]
        call AddMantissas
        xchg eax, dword [byte ebp-04h]
        xchg edx, dword [byte ebp-08h]
        xchg esi, dword [byte ebp-0Ch]
        rol esi, 10h
        mov si, word [byte ebp+00h]
        rol esi, 10h
        mov ebx, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+04h]
        call AddMantissas
        rol esi, 10h
        mov si, word [byte ebp-0Ch]
        rol esi, 10h
        pop ecx
        pop ecx
        pop ebx
        call DivideMantissas
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        add esp, byte 0Ch
        pop ecx
        lea esi, [EmuTan_E]
.11:
        LD or, ecx, ecx
        je short .13
        shr ecx, 1
        jae short .12
        push ecx
        push esi
        mov ax, word [byte edi+08h]
        mov ecx, dword [byte edi+04h]
        mov ebx, dword [edi]
        shl eax, 10h
        mov ax, word [byte cs:esi+08h]
        mov edx, dword [byte cs:esi+04h]
        mov esi, dword [cs:esi]
        xchg esi, eax
        call MultiplyMantissas
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        pop esi
        pop ecx
.12:
        lea esi, [byte esi+0Ah]
        jmp short .11
.13:
        pop esi
        add word [byte edi+08h], si
        LD mov, eax, edi
        push dword 0BFFFh
        push dword 80000000h
        push byte 0
        LD mov, ebx, edi
        call AddExtRaw
        pop ebx
        pop ecx
        pop edx
        pop esi
        pop edi
        pop ebp
        ret
EmuExp2:
        push edi
        push esi
        push edx
        push ecx
        push ebx
        mov cx, word [byte eax+08h]
        mov edx, dword [byte eax+04h]
        mov ebx, dword [eax]
        LD or, ebx, ebx
        jne short .4
        LD or, edx, edx
        jne short .3
        LD add, cx, cx
        je near .12
.1:
        mov word [byte eax+08h], 0FFFFh
        mov dword [byte eax+04h], 0
        mov dword [eax], 0
.2:
        or byte [byte eax+07h], 0C0h
        jmp near .12
.3:
        cmp cx, 7FFFh
        je near .12
.4:
        LD mov, edx, ecx
        and dh, 7Fh
        cmp dx, 7FFFh
        je short .2
        LD add, cx, cx
        jb short .2
        shr cx, 1
        je short .5
        mov edx, dword [byte eax+04h]
        LD add, edx, edx
        jae short .1
.5:
        mov edx, dword [byte eax+04h]
        LD sub, edi, edi
        push eax
        sub cx, 3FFFh
        sar cx, 1
        jb short .6
        shr edx, 1
        rcr ebx, 1
        rcr edi, 1
.6:
        add cx, 3FFFh
        mov word [byte eax+08h], cx
        LD mov, ecx, edx
        LD mov, eax, ebx
        LD mov, esi, edx
        stc
        rcr esi, 1
        inc edx
        je short .9
        dec edx
.7:
        div esi
        dec esi
        LD cmp, esi, eax
        jbe short .8
        inc esi
        LD add, esi, eax
        rcr esi, 1
        LD mov, edx, ecx
        LD mov, eax, ebx
        jmp short .7
.8:
        inc esi
        LD mov, ecx, eax
        LD mov, eax, edi
        div esi
        LD add, esi, ecx
        jmp short .10
.9:
        LD cmp, eax, esi
        je short .11
        xchg edx, eax
        LD mov, eax, edi
        div esi
.10:
        LD sub, edx, edx
        stc
        rcr esi, 1
        rcr eax, 1
        LD adc, eax, edx
.11:
        LD adc, edx, esi
        pop esi
        mov dword [esi], eax
        mov dword [byte esi+04h], edx
.12:
        pop ebx
        pop ecx
        pop edx
        pop esi
        pop edi
        ret
PolyEvalExt:
        push esi
        push ecx
        push eax
        LD mov, ecx, edx
        mov si, word [byte eax+08h]
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        call PolyEval
        pop ecx
        mov dword [ecx], eax
        mov dword [byte ecx+04h], edx
        mov word [byte ecx+08h], si
        pop ecx
        pop esi
        ret
PolyEval:
        push ebp
        push edi
        push ecx
        push ebx
        push esi
        push edx
        push eax
        LD mov, ebp, esp
        LD mov, edi, ecx
        mov eax, dword [cs:edi]
        mov edx, dword [byte cs:edi+04h]
        mov si, word [byte cs:edi+08h]
.1:
        rol esi, 10h
        mov si, word [byte ebp+08h]
        rol esi, 10h
        mov ebx, dword [byte ebp+00h]
        mov ecx, dword [byte ebp+04h]
        call MultiplyMantissas
        lea edi, [byte edi+0Ah]
        mov ebx, dword [cs:edi]
        mov ecx, dword [byte cs:edi+04h]
        rol esi, 10h
        mov si, word [byte cs:edi+08h]
        rol esi, 10h
        call AddMantissas
        dec dword [byte ebp+0Ch]
        jne short .1
        add esp, byte 10h
        pop ecx
        pop edi
        pop ebp
        ret
PolyEvalOdd:
        push edi
        push esi
        push ecx
        push ebx
        push edx
        LD mov, edi, eax
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        shl esi, 10h
        mov si, word [byte edi+08h]
        LD mov, ebx, eax
        LD mov, ecx, edx
        call MultiplyMantissas
        pop ecx
        pop ebx
        call PolyEval
        rol esi, 10h
        mov ebx, dword [edi]
        mov ecx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        rol esi, 10h
        call MultiplyMantissas
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        pop ecx
        pop esi
        pop edi
        ret
__hook387:
        push ebx
        push ecx
        push esi
        push edi
        push es
        push ebp
        push edx
        mov ebp, eax
        mov ax, 1600h
        int 2Fh
        test al, al
        je short .1
        cmp al, 80h
        je short .1
        xor al, al
        xor edx, edx
        xor ecx, ecx
        xor ebx, ebx
        mov ah, 0FAh
        int 2Fh
        cmp ax, 666h
        jne short .1
        mov al, 22h
        xor edx, edx
        xor ecx, ecx
        xor ebx, ebx
        mov ah, 0FAh
        int 2Fh
        test ax, ax
        jne short .1
        mov dh, 1
        mov al, 1Eh
        xor ecx, ecx
        xor ebx, ebx
        mov byte [Hook387Saved], dh
        xor edx, edx
        mov ah, 0FAh
        int 2Fh
        mov eax, cs
        mov ebx, Hook387Save
        mov edx, eax
        mov ecx, ebx
        mov al, 20h
        shr ecx, 10h
        mov ah, 0FAh
        int 2Fh
        mov al, 1
        jmp short .4
.1:
        mov edx, dword [esp]
        test ebp, ebp
        jne short .2
        test dx, dx
        je short .3
.2:
        mov esi, str_RATIONALDOS4G
        mov eax, 0A00h
        push es
        int 31h
        sbb eax, eax
        pop es
        test eax, eax
        jne short .3
        mov eax, 7
        mov ebx, __int7
        mov ecx, cs
        call _dos_setvect_
        mov es, word [esp]
        mov ah, byte [byte es:ebp+040h]
        mov byte [byte es:ebp+03Eh], 1
        or ah, 4
        mov byte [byte es:ebp+040h], ah
        mov eax, cr0
        or al, 4
        mov dl, 1
        mov cr0, eax
        mov ah, 30h
        int 21h
        mov byte [Hook387Flag], dl
.3:
        xor al, al
.4:
        add esp, byte 4
        pop ebp
        pop es
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
__unhook387:
        push ebx
        push ecx
        push es
        mov es, edx
        mov dl, byte [Hook387Saved]
        test dl, dl
        je short .1
        mov eax, cs
        mov edx, eax
        xor ecx, ecx
        xor ebx, ebx
        mov al, 21h
        mov ah, 0FAh
        int 2Fh
        mov al, 1Fh
        xor edx, edx
        xor ecx, ecx
        xor ebx, ebx
        mov ah, 0FAh
        int 2Fh
        mov al, 1
        pop es
        pop ecx
        pop ebx
        ret
.1:
        cmp byte [Hook387Flag], 0
        je short .2
        mov bl, byte [byte es:eax+040h]
        mov byte [byte es:eax+03Eh], dl
        and bl, 0FBh
        mov byte [byte es:eax+040h], bl
        mov eax, cr0
        and al, 0FBh
        mov cr0, eax
        mov ah, 30h
        int 21h
.2:
        xor al, al
        pop es
        pop ecx
        pop ebx
        ret
EmuNoOp:
        ret
__init_80x87:
        push ax
        wait
        fninit
        fld1
        fldz
        fdivp
        fld st0
        fchs
        fcompp
        fnstsw ax
        mov al, 2
        sahf
        je short .1
        mov al, 3
.1:
        wait
        fninit
        fldcw word [esp]
        xchg ax, word [esp]
        pop ax
        ret
        db 00h,00h,00h
