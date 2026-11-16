; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_F18A4 nobits alloc noexec write align=1
global SeqTracks, SeqTrackFlags, byte_F1D61, SongRelease, SeqTrackPos
SongRelease:
        resb 376
SeqTracks:
        resb 1
SeqTrackFlags:
        resb 1
SeqTrackPos:
        resb 835
byte_F1D61:
        resb 1179
