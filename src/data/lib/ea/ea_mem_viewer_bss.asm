; BSS of lib/ea/ea_mem_viewer (src/lib/ea/ea_mem_viewer).
bits 32
%include "hockey.inc"
section s_EDA08 nobits alloc noexec write align=1
global memlist1, memlist0
memlist1:                                       ; memory block list head returned by GetMemListHead(1); used
                                                ; by AddHighMemList, AddMemListRegion, FindCachedFile ...
        resb 4
memlist0:                                       ; memory block list head returned by GetMemListHead(0); used
                                                ; by GetMemListHead, MemViewerListHead
        resb 156
