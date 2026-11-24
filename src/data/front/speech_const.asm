; Strings and constants of front/speech (src/front/speech), in link order.
bits 32
%include "hockey.inc"
section s_C3782 progbits alloc noexec write align=1
global str_Speechbuf, str_Sentence, str_SampleMemMan, str_SpeechBank, F64_BankPercent, F64_BankRate5512, F64_BankRate11025, F64_SlotPercent
global F64_SlotRate11025
str_Speechbuf:                                  ; string 'speechbuf'; used by InitSpeechSlots
        db 073h,070h,065h,065h,063h,068h,062h,075h,066h,00h
str_Sentence:                                   ; string 'sentence'; used by InitSpeech
        db 073h,065h,06Eh,074h,065h,06Eh,063h,065h,00h
str_SampleMemMan:                               ; string 'sample mem man'; used by InitSpeech
        db 073h,061h,06Dh,070h,06Ch,065h,020h,06Dh,065h,06Dh,020h,06Dh,061h,06Eh,00h
str_SpeechBank:                                 ; string 'speech bank'; used by InitSpeech
        db 073h,070h,065h,065h,063h,068h,020h,062h,061h,06Eh,06Bh,00h
F64_BankPercent:                                ; Double 100.0 used by OpenSpeechBank
        db 00h,00h,00h,00h,00h,00h,059h,040h
F64_BankRate5512:                               ; Double 5512.0 used by OpenSpeechBank
        db 00h,00h,00h,00h,00h,088h,0B5h,040h
F64_BankRate11025:                              ; used by OpenSpeechBank
        db 00h,00h,00h,00h,080h,088h,0C5h,040h
F64_SlotPercent:                                ; Double 100.0 used by LoadSpeechSlot
        db 00h,00h,00h,00h,00h,00h,059h,040h
F64_SlotRate11025:                              ; used by LoadSpeechSlot
        db 00h,00h,00h,00h,080h,088h,0C5h,040h
