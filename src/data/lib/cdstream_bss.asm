; BSS of lib/cdstream (src/lib/cdstream).
bits 32
%include "hockey.inc"
section s_DC8A0 nobits alloc noexec write align=1
global StreamHandle, CurStream
StreamHandle:                                   ; CD stream handle; used by CdStreamCreate,
                                                ; CdStreamCreateSecondary, CdStreamService ...
        resb 40
CurStream:                                      ; Stream record the CD stream service is working on; used by
                                                ; CdStreamCreate, CdStreamService
        resb 8
