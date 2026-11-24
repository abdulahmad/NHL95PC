; Initialised data of front/main (src/front/main).
bits 32
%include "hockey.inc"
section s_C4CFC progbits alloc noexec write align=1
global SpeechSlotMemSize, joypresent, inputticks, joysampling, joyqhead, joyqcount
SpeechSlotMemSize:                              ; used by MenuCentralRegistry, RunIntro, SetSoundDevice ...
        db 00h,00h,00h,00h
joypresent:                                     ; used by ReadJoyPad, main_
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
inputticks:                                     ; SampleInputTick tick counter (capped at 1000), cleared by
                                                ; ResetInputSampling; used by ResetInputSampling,
                                                ; SampleInputTick
        db 00h,00h,00h,00h
joysampling:                                    ; timer ISR SampleInputTick samples the pads into joyqueue
                                                ; only while this is non-zero; joyq_pop and the sound calls
                                                ; save it in joysampling_save, clear it and restore it; used
                                                ; by ClockTick, FreeGameMemory, Gameloop ...
        db 00h,00h,00h,00h
joyqhead:                                       ; input queue read index 0-49 (joyq_pop wraps it at 32h; ISR
                                                ; writes at (head+count) mod 50); used by SampleInputTick,
                                                ; joyq_peek, joyq_pop
        db 00h,00h,00h,00h
joyqcount:                                      ; input queue entries (ISR increments up to 50, joyq_pop
                                                ; decrements); used by SampleInputTick, joyq_flush, joyq_peek
                                                ; ...
        db 00h,00h,00h,00h
