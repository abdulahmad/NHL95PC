; Tables for the EA libraries: the mouse, the clip rectangle, and the file and video state.
bits 32
%include "hockey.inc"
section s_F234D nobits alloc noexec write align=1
global MidiChanVolume, MidiChanCtrlState
MidiChanVolume:
        resb 1
MidiChanCtrlState:
        resb 110
