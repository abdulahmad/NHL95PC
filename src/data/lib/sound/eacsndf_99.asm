; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_F22FC nobits alloc noexec write align=1
global DigiFadeLevel, DigiFadeAccum, DigiFadeStep, DigiFadeChannel, DigiFadeDriver
DigiFadeLevel:
        resb 4
DigiFadeAccum:
        resb 4
DigiFadeStep:
        resb 4
DigiFadeChannel:
        resb 4
DigiFadeDriver:
        resb 65
