; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_EDCFC nobits alloc noexec write align=1
global byte_EDE7D, byte_EDEAC, dword_EDCFC, dword_EDD00, dword_EDD04, dword_EDE34, dword_EDE5C, MemViewTop
global MemViewCount, dword_EDE68, MemViewTitle, MemViewRow, MemViewList, dword_EDE78, dword_EDE7C, MemViewMode
global dword_EDE84, dword_EDE8C, dword_EDE90, dword_EDE94, dword_EDE98, dword_EDE9C, dword_EDEA0, dword_EDEA4
global dword_EDEA8, dword_EDEB0, dword_EDEE0, dword_EDEE4, dword_EDEE8, dword_EDEEC, dword_EDEF0, dword_EDEF4
global dword_EDEF8, dword_EDEFC, dword_EDF00, unk_EDE88
dword_EDCFC:
        resb 4
dword_EDD00:
        resb 4
dword_EDD04:
        resb 304
dword_EDE34:
        resb 40
dword_EDE5C:
        resb 4
MemViewTop:
        resb 4
MemViewCount:
        resb 4
dword_EDE68:
        resb 4
MemViewTitle:
        resb 4
MemViewRow:
        resb 4
MemViewList:
        resb 4
dword_EDE78:
        resb 4
dword_EDE7C:
        resb 1
byte_EDE7D:
        resb 3
MemViewMode:
        resb 4
dword_EDE84:
        resb 4
unk_EDE88:
        resb 4
dword_EDE8C:
        resb 4
dword_EDE90:
        resb 4
dword_EDE94:
        resb 4
dword_EDE98:
        resb 4
dword_EDE9C:
        resb 4
dword_EDEA0:
        resb 4
dword_EDEA4:
        resb 4
dword_EDEA8:
        resb 4
byte_EDEAC:
        resb 4
dword_EDEB0:
        resb 48
dword_EDEE0:
        resb 4
dword_EDEE4:
        resb 4
dword_EDEE8:
        resb 4
dword_EDEEC:
        resb 4
dword_EDEF0:
        resb 4
dword_EDEF4:
        resb 4
dword_EDEF8:
        resb 4
dword_EDEFC:
        resb 4
dword_EDF00:
        resb 4
