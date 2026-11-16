; The EA memory manager. Allocating and freeing the blocks the game asks for.
bits 32
%include "hockey.inc"
section s_8DCC0 progbits alloc exec nowrite align=1
extern _nexpand_, _nfree_, _nmalloc_, _nmsize_
global GrabLargestBlock, loc_8DCC5, loc_8DCD6, loc_8DCD9
GrabLargestBlock:
        mov edx, 4000000h
loc_8DCC5:
        mov eax, edx
        call _nmalloc_
        mov ebx, eax
        test eax, eax
        jne short loc_8DCD6
        sar edx, 1
        jmp short loc_8DCC5
loc_8DCD6:
        jne short loc_8DCD9
        ret
loc_8DCD9:
        mov edx, 4000000h
        call _nexpand_
        mov eax, ebx
        call _nmsize_
        mov edx, eax
        mov eax, ebx
        call _nfree_
        mov eax, edx
        ret
        db 08Bh,0C0h
