; Tables for the EA libraries: the mouse, the clip rectangle, and the file and video state.
bits 32
%include "hockey.inc"
section s_F21FC nobits alloc noexec write align=1
global MidiOutQueue
MidiOutQueue:
        resb 256
