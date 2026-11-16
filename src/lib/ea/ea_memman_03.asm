; The EA memory manager. Allocating and freeing the blocks the game asks for.
bits 32
%include "hockey.inc"
section s_8DCC0 progbits alloc exec nowrite align=1
extern _nexpand_, _nfree_, _nmalloc_, _nmsize_
global GrabLargestBlock
GrabLargestBlock:
        mov edx, 4000000h
.1:
        mov eax, edx
        call _nmalloc_
        mov ebx, eax
        test eax, eax
        jne short .2
        sar edx, 1
        jmp short .1
.2:
        jne short .3
        ret
.3:
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
