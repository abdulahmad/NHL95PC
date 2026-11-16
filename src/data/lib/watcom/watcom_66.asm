; Watcom runtime data.
bits 32
%include "hockey.inc"
section s_D657C progbits alloc noexec write align=1
extern EmuNoOp
global Hook387Flag, Hook387Saved, EmuInitHook, EmuFiniHook, EmuTrapFrame, DefaultControlWord
EmuTrapFrame:                                   ; X87 emulator trap frame; used by EmuTrapExit
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
Hook387Flag:                                    ; used by __hook387, __unhook387
        db 00h
Hook387Saved:                                   ; used by __hook387, __unhook387
        db 00h,00h,00h
DefaultControlWord:                             ; used by __init_8087_, __sys_init_387_emulator
        db 07Fh,012h,00h,00h
EmuInitHook:                                    ; X87 emulator init routine; used by __init_8087_, spawnve_
        dd EmuNoOp
EmuFiniHook:                                    ; X87 emulator shutdown routine; used by __init_8087_,
                                                ; spawnve_
        dd EmuNoOp
