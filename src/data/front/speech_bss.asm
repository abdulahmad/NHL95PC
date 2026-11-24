; BSS of front/speech (src/front/speech).
bits 32
%include "hockey.inc"
section s_ED7B4 nobits alloc noexec write align=1
global samplereq, speechcopybuf
samplereq:                                      ; 'sample mem man': 20 requested names + counters; used by
                                                ; InitSpeech, IsSampleRequested, MakeSampleRoom ...
        resb 4
speechcopybuf:                                  ; copy buffer for MoveSampleMem; used by InitSpeech,
                                                ; MoveSampleMem
        resb 4
