; The photo banks.
bits 32
%include "hockey.inc"
section s_D9980 nobits alloc noexec write align=1
global photobanks
photobanks:                                     ; 17h loaded .PPV player photo banks (LoadPlayerPhotos); used
                                                ; by EnsureFreeMemory, FreePhotoBanks, IndexPhotoBank ...
        resb 184
