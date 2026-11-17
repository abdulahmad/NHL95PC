; The first four bytes of the data segment.
bits 32
%include "hockey.inc"
section s_C0000 progbits alloc noexec write align=1
global __nullarea
__nullarea:                                     ; Watcom _NULL area: the 01h-filled words at the first data
                                                ; address; the port snapshots the data from here
        db 01h,01h,01h,00h
