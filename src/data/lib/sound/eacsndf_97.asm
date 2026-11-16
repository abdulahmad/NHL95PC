; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_F18A4 nobits alloc noexec write align=1
global SeqTracks, SeqTrackFlags, SongRelease, SeqTrackPos
SongRelease:                                    ; Release flag of each song record; used by ReleaseAllVoices,
                                                ; StopSongId
        resb 376
SeqTracks:                                      ; Track records (54h bytes each); used by FindFreeTrack,
                                                ; ReleaseSong, SeqChannelNotesOff ...
        resb 1
SeqTrackFlags:                                  ; Flags byte of each track record; used by SndClearTables
        resb 1
SeqTrackPos:                                    ; Data position of each track record; used by SndClearTables
        resb 835
        resb 1179
