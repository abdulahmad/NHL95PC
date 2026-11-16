; Tables for the sound drivers.
bits 32
%include "hockey.inc"
section s_F0000 nobits alloc noexec write align=1
global SoundDrvWorkArea
SoundDrvWorkArea:
        resb 5892
