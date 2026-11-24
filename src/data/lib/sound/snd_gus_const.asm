; Strings and constants of src/lib/sound/snd_gus.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4A9C progbits alloc noexec write align=1
global str_PAT, str_ULTRADIR, str_MIDI
str_PAT:                                        ; ".PAT" string literal; used by GusLoadMidiPatch
        db 02Eh,050h,041h,054h,00h
str_ULTRADIR:                                   ; "ULTRADIR" string literal; used by GusStartup
        db 055h,04Ch,054h,052h,041h,044h,049h,052h,00h
str_MIDI:                                       ; "\MIDI\" string literal; used by GusStartup
        db 05Ch,04Dh,049h,044h,049h,05Ch,00h,00h,00h,00h
