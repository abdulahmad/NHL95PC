; The stack the Watcom runtime uses.
bits 32
%include "hockey.inc"
section s_F7B88 nobits alloc noexec write align=1
global stackarea
stackarea:                                      ; the stack area after the game's variables; the port builds
                                                ; the command tail and program name at its start; used by
                                                ; __saved_DS
        resb 12296
